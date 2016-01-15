//
//  ThreadStateController.h
//  多线程Demo
//
//  Created by SmartDoc on 16/1/8.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadStateController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *leftLoadBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightLoadBtn;

- (IBAction)leftLoadImgClick:(id)sender;
- (IBAction)rightLoadImgClick:(id)sender;

@end
