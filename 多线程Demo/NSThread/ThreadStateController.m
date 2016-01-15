//
//  MoreThreadController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/8.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "ThreadStateController.h"

@interface ThreadStateController ()

@property (nonatomic,strong) NSMutableArray * imgViews;
@property (nonatomic,strong) NSMutableArray * imgNames;
@property (nonatomic,strong) NSMutableArray * threads;

@end

@implementation ThreadStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

#pragma mark - 界面布局
- (void)layoutUI {
    //创建多个图片控件用于显示图片
    self.imgViews = [[NSMutableArray alloc] init];
    for (int r = 0; r < ROW_COUNT; r++) {
        for (int c = 0; c < COLUMN_COUNT; c++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING)+80, ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [self.imgViews addObject:imageView];
        }
    }
    
    //创建图片链接
    self.imgNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; i++) {
        [self.imgNames addObject:[NSString stringWithFormat:IMG_URL,i]];
    }
}

#pragma mark - 多线程下载图片
- (void)leftLoadImgClick:(id)sender {
    int count = ROW_COUNT*COLUMN_COUNT;
    self.threads = [NSMutableArray arrayWithCapacity:count];
    
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImg:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        [self.threads addObject:thread];
    }
    //循环启动线程
    for (int i = 0; i < count; ++i) {
        NSThread * thread = self.threads[i];
        [thread start];
    }
}

#pragma mark - 加载图片
- (void)loadImg:(NSNumber *)index {
    int i = [index intValue];
    
    NSData * data = [self requestData:i];
    
    NSThread * currentThread = [NSThread currentThread];
    
    // 如果当前线程处于取消状态，则退出当前线程
    if (currentThread.isCancelled) {
        NSLog(@"thread(%@) will be cancelled!",currentThread);
        [NSThread exit]; // 取消当前线程
    }
    
    ImgData * imgData = [[ImgData alloc] init];
    imgData.index = i;
    imgData.data = data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imgData waitUntilDone:YES];
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(int)index {
    // 对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        NSURL * url = [NSURL URLWithString:self.imgNames[index]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return data;
    }
}

#pragma mark - 将图片显示到界面
- (void)updateImage:(ImgData *)imgData {
    UIImage * img = [UIImage imageWithData:imgData.data];
    UIImageView * imgView = self.imgViews[imgData.index];
    imgView.image = img;
}

#pragma mark - 停止加载图片
- (void)rightLoadImgClick:(id)sender {
    for (int i = 0; i< ROW_COUNT*COLUMN_COUNT; i++) {
        NSThread * thread = self.threads[i];
        // 判断线程是否完成，如果没有完成则设置为取消状态
        // 注意设置为取消状态仅仅是改变了线程状态而言，并不能终止线程
        if (!thread.isFinished) {
            [thread cancel];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
