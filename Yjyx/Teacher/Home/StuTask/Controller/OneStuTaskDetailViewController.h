//
//  OneStuTaskDetailViewController.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YourAnswerCell;
@interface OneStuTaskDetailViewController : UITableViewController


@property (nonatomic, strong) NSNumber *taskid;// 任务id
@property (nonatomic, strong) NSNumber *suid;// 学生的user id
@property (nonatomic, strong) NSNumber *qtype; // 题目类型
@property (nonatomic, strong) NSNumber *qid; // 题目id

@property (nonatomic, copy) NSString *right;// 对错

@property (nonatomic, copy) NSString *answer;// 答案
//@property (nonatomic, copy) NSArray *answerArr;// 答案数组

@end
