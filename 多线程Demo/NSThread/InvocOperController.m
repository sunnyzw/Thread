//
//  InvocOperController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/9.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "InvocOperController.h"

@interface InvocOperController ()

@end

@implementation InvocOperController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 多线程下载图片
- (void)loadImgClick:(UIButton *)sender {
    /*
     创建一个调用操作
     object:调用方法参数
     */
    NSInvocationOperation * invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImg) object:nil];
    // 创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作,而是添加到NSOperationQueue中
    //    [invocationOperation start];
    
    // 创建操作队列
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
    // 注意添加到操作队列后，队列会开启一个线程执行此操作
    [operationQueue addOperation:invocationOperation];
}

#pragma mark - 加载图片
- (void)loadImg {
    // 请求数据
    NSData * data = [self requestData];
    /*
     将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:是否线程任务完成执行
     */
    [self performSelectorOnMainThread:@selector(updateImg:) withObject:data waitUntilDone:YES];
}

#pragma mark - 请求图片数据
- (NSData *)requestData {
    // 对于多线程操作建议把线程放到@autoreleasepool中
    @autoreleasepool {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:IMG_URL,1]];
        NSData * data = [NSData dataWithContentsOfURL:url];
        return data;
    }
}

#pragma mark - 将图片显示到界面
- (void)updateImg:(NSData *)imgData {
    UIImage * img = [UIImage imageWithData:imgData];
    self.imgView.frame = CGRectMake(0, (HEIGHT-(img.size.height*WIDTH/img.size.width))/2, WIDTH, img.size.height*WIDTH/img.size.width);
    self.imgView.image = img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
