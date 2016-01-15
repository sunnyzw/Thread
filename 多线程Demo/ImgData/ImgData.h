//
//  ImgData.h
//  多线程Demo
//
//  Created by SmartDoc on 16/1/8.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgData : NSObject

@property (nonatomic,assign) int index; // 索引
@property (nonatomic,strong) NSData * data; // 图片数据

@end
