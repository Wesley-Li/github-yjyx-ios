//
//  YjyxWorkDetailController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxWorkDetailController : UIViewController

@property (strong, nonatomic) NSString *t_title;
@property (strong, nonatomic) NSNumber *t_id;
@property (strong, nonatomic) NSNumber *taskType;


@property (strong, nonatomic) NSNumber *subject_id;
@property (assign, nonatomic) NSInteger isFinished;

@property (assign, nonatomic) NSInteger openMember;// 1代表开通了会员
@end
