//
//  TaskListTableViewCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskModel;
@interface TaskListTableViewCell : UITableViewCell


- (void)setValueWithTaskModel:(TaskModel *)model;

@end
