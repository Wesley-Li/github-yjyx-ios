//
//  NextTableViewController.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextTableViewController : UITableViewController

@property (nonatomic, strong) NSNumber *taskid;// 任务id
@property (nonatomic, strong) NSNumber *qtype;//题目类型
@property (nonatomic, strong) NSNumber *qid;// 题目id
@property (nonatomic, strong) NSNumber *C_count;// 作对的学生数
@property (nonatomic, strong) NSNumber *W_count;// 做错的学生数



@end
