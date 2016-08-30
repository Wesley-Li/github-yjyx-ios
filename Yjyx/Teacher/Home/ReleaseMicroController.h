//
//  ReleaseMicroController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseMicroController : UIViewController

@property (strong, nonatomic) NSNumber *w_id;

// 发布相同作业
@property (strong, nonatomic) NSNumber *examid;
@property (assign, nonatomic) NSInteger releaseType; // 发布作业类型 1代表相同作业
@end
