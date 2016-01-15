//
//  Header.h
//  多线程Demo
//
//  Created by SmartDoc on 16/1/9.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "ImgData.h"

#define IMG_URL @"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define ROW_COUNT 4
#define COLUMN_COUNT 3
#define ROW_HEIGHT ([UIScreen mainScreen].bounds.size.width-20)/3
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
