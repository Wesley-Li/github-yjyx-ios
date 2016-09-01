//
//  YjyxThreeStageAnswerController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxThreeStageAnswerController : UIViewController

@property (strong, nonatomic) NSMutableArray *threeStageSubjectArr;
@property (strong, nonatomic) NSNumber *subjectid;
@property (strong, nonatomic) NSMutableArray *randomFiveArr;
@property (strong, nonatomic) NSString *knowledge;

@property (assign, nonatomic) NSInteger openMember;// 1代表开通了会员

@end
