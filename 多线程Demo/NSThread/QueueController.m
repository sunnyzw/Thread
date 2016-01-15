//
//  SerialQueueController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/9.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "QueueController.h"

@interface QueueController ()

@property (nonatomic,strong) NSMutableArray * imgViews;
@property (nonatomic,strong) NSMutableArray * imgNames;

@end

@implementation QueueController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    [self.leftLoadBtn setTitle:@"串行加载图片" forState:UIControlStateNormal];
    [self.rightLoadBtn setTitle:@"并发加载图片" forState:UIControlStateNormal];

}

#pragma mark - 界面布局
-(void)layoutUI {
    // 创建多个图片控件用于显示图片
    self.imgViews = [[NSMutableArray alloc] init];
    for (int r = 0; r < ROW_COUNT; r++) {
        for (int c = 0; c < COLUMN_COUNT; c++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING)+80, ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [self.imgViews addObject:imageView];
        }
    }
    
    // 创建图片链接
    self.imgNames = [NSMutableArray array];
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; i++) {
        [self.imgNames addObject:[NSString stringWithFormat:IMG_URL,i]];
    }
}

#pragma mark - 串行队列下载图片
- (void)leftLoadImgClick:(id)sender {
    int count = ROW_COUNT*COLUMN_COUNT;

    /*
     创建一个串行队列
     第一个参数：队列名称
     第二个参数：队列类型
     */
    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL); // 注意queue对象不是指针类型
    // 创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
    //非ARC环境请释放
    //    dispatch_release(seriQueue);
}

#pragma mark - 并行队列下载图片
- (void)rightLoadImgClick:(id)sender {
    int count = ROW_COUNT*COLUMN_COUNT;
    
    /*
     取得全局队列
     第一个参数：线程优先级
     第二个参数：标记参数，目前没有用，一般传入0
     */
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个线程用于填充图片
    for (int i = 0; i<count; ++i) {
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}

#pragma mark - 加载图片
- (void)loadImage:(NSNumber *)index {
    // 如果在串行队列中会发现当前线程打印变化完全一样，因为他们在一个线程中
    NSLog(@"thread is :%@",[NSThread currentThread]);
    
    int i = [index intValue];
    //请求数据
    NSData * data = [self requestData:i];
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i];
    });
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(int)index {
    NSURL * url = [NSURL URLWithString:self.imgNames[index]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    return data;
}

#pragma mark - 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(int)index {
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = self.imgViews[index];
    imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
