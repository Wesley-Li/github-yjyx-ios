//
//  ReleaseMicroController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskModel;
@interface ReleaseMicroController : UIViewController

@property (strong, nonatomic) NSNumber *w_id;

// 追加学生
@property (strong, nonatomic) NSArray *addStuArr;
@property (nonatomic, strong) TaskModel *taskModel;

// 发布相同作业
@property (strong, nonatomic) NSNumber *examid;
@property (assign, nonatomic) NSInteger releaseType; // 发布作业类型 1代表相同作业 2代表追加学生

@end
