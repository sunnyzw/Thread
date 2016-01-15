//
//  BlockOperController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/9.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "BlockOperController.h"

@interface BlockOperController ()

@property (nonatomic,strong) NSMutableArray * imgViews;
@property (nonatomic,strong) NSMutableArray * imgNames;

@end

@implementation BlockOperController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)layoutUI {
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
    
    //创建图片链接
    self.imgNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < ROW_COUNT*COLUMN_COUNT; i++) {
        [self.imgNames addObject:[NSString stringWithFormat:IMG_URL,i]];
    }
}

#pragma mark - 多线程下载图片
- (void)loadImgClick:(UIButton *)sender {
    int count = ROW_COUNT*COLUMN_COUNT;
    // 创建操作队列
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 5; // 设置最大并发线程数
    // 创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        //方法1：创建操作块添加到队列
        //        //创建多线程操作
        //        NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
        //            [self loadImage:[NSNumber numberWithInt:i]];
        //        }];
        //        //创建操作队列
        //
        //        [operationQueue addOperation:blockOperation];
        
        // 方法2：直接使用操队列添加操作
        [operationQueue addOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
    }
    
//    ——————————————优先加载一张图片————————————————
//    NSBlockOperation * lastBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        [self loadImage:[NSNumber numberWithInt:(count-1)]];
//    }];
//    // 创建多个线程用于填充图片
//    for (int i = 0; i < count-1; ++i) {
//        // 方法1：创建操作块添加到队列
//        // 创建多线程操作
//        NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        }];
//        // 设置依赖操作为最后一张图片加载操作
//        [blockOperation addDependency:lastBlockOperation];
//        
//        [operationQueue addOperation:blockOperation];
//        
//    }
//    // 将最后一个图片的加载操作加入线程队列
//    [operationQueue addOperation:lastBlockOperation];
}

#pragma mark 加载图片
- (void)loadImage:(NSNumber *)index {
    int i = [index intValue];
    // 请求数据
    NSData * data = [self requestData:i];
    NSLog(@"%@",[NSThread currentThread]);
    // 更新UI界面,此处调用了主线程队列的方法（mainQueue是UI主线程）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImageWithData:data andIndex:i];
    }];
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(int)index {
    NSURL * url = [NSURL URLWithString:self.imgNames[index]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return data;
}

#pragma mark - 将图片显示到界面
- (void)updateImageWithData:(NSData *)data andIndex:(int)index {
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = self.imgViews[index];
    imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
