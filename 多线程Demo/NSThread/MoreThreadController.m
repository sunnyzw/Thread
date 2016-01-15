//
//  MoreThreadController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/8.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "MoreThreadController.h"

@interface MoreThreadController ()

@property (nonatomic,strong) NSMutableArray * imgViews;

@end

@implementation MoreThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

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
}

#pragma mark - 多线程下载图片
- (void)loadImgClick:(UIButton *)sender {
    // 创建多个线程用于填充图片
    for (int i = 0; i < self.imgViews.count; ++i) {
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImg:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"myThread%i",i]; //设置线程名称
        [thread start];
    }
}

#pragma mark - 加载图片
- (void)loadImg:(NSNumber *)index {
    // currentThread方法可以取得当前操作线程
//    NSLog(@"current thread:%@",[NSThread currentThread]);
    
    int i = [index intValue];
    NSLog(@"%d",i); // 未必按顺序输出
    
    NSData * data = [self requestData:i];
    ImgData * imgData = [[ImgData alloc] init];
    imgData.index = i;
    imgData.data = data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imgData waitUntilDone:YES];
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(int)index {
    // 对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:IMG_URL,index]];
        NSData * data = [NSData dataWithContentsOfURL:url];
        return data;
    }
}

#pragma mark - 将图片显示到界面
- (void)updateImage:(ImgData *)imgData {
    UIImage * img = [UIImage imageWithData:imgData.data];
    UIImageView * imgView = self.imgViews[imgData.index];
    imgView.image = img;
}

- (void)loadImgWithMultiThread {
    NSMutableArray * threads = [[NSMutableArray alloc] init];
    int count = ROW_COUNT*COLUMN_COUNT;
    // 创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImg:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"myThread%i",i]; // 设置线程名称
        if (i == count-1) {
            thread.threadPriority = 1.0;
        } else {
            thread.threadPriority = 0.0;
        }
        [threads addObject:thread];
    }
    
    for (int i = 0; i < count; i++) {
        NSThread * thread = threads[i];
        [thread start];
    }
    
//    // NSObject分类扩展方法
//    for (int i = 0; i < count; ++i) {
//        [self performSelectorInBackground:@selector(loadImg:) withObject:[NSNumber numberWithInt:i]];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
