//
//  YjyxDoingWorkController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxDoingWorkController : UIViewController

@property (strong, nonatomic) NSNumber *taskid;
@property (strong, nonatomic) NSNumber *examid;

@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSNumber *type;

@property (strong, nonatomic) NSString *workTitle; // 做作业标题

@property (strong, nonatomic) NSMutableArray *jumpDoworkArr;
@property (strong, nonatomic) NSNumber *subject_id;
@end
