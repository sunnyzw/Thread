//
//  ThreadSynchroController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/9.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "ThreadSynchroController.h"

@interface ThreadSynchroController ()

{
    NSLock * lock;
}

@property (nonatomic,strong) NSMutableArray * imgViews;
@property (nonatomic,strong) NSMutableArray * imgNames;

@end

@implementation ThreadSynchroController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
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
    for (int i = 0; i < 6; i++) {
        [self.imgNames addObject:[NSString stringWithFormat:IMG_URL,i]];
    }
    
    lock = [[NSLock alloc] init];
}

#pragma mark 多线程下载图片
- (void)loadImgClick:(UIButton *)sender {
    int count = ROW_COUNT*COLUMN_COUNT;
    
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        // 异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}

#pragma mark 加载图片
- (void)loadImage:(NSNumber *)index {
    int i = [index intValue];
    // 请求数据
    NSData * data = [self requestData:i];
    // 更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i];
    });
}

#pragma mark 请求图片数据
- (NSData *)requestData:(int)index {
    NSData * data;
    NSString * name;
    
//    // 加锁
//    [lock lock];
//    if (self.imgNames.count>0) {
//        name=[self.imgNames lastObject];
//        [self.imgNames removeObject:name];
//    }
//    // 使用完解锁
//    [lock unlock];
//    if(name) {
//        NSURL * url = [NSURL URLWithString:name];
//        data = [NSData dataWithContentsOfURL:url];
//    }
//    return data;
    
    
    // @synchronized进行线程同步 ---推介使用
    @synchronized(self) {
        if (self.imgNames.count > 0) {
            name = [self.imgNames lastObject];
            [NSThread sleepForTimeInterval:0.001f];
            [self.imgNames removeObject:name];
        }
    }
    if (name) {
        NSURL * url = [NSURL URLWithString:name];
        data = [NSData dataWithContentsOfURL:url];
    }
    return data;
}

#pragma mark 将图片显示到界面
- (void)updateImageWithData:(NSData *)data andIndex:(int)index {
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = self.imgViews[index];
    imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
