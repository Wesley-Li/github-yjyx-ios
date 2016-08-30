//
//  TaskListTableViewCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskModel, TaskListTableViewCell;

@protocol TaskListTableViewCellDelegate <NSObject>

- (void)taskListTableViewCell:(TaskListTableViewCell *)cell releaseWorkBtn:(UIButton *)btn;

@end
@interface TaskListTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;

@property (strong, nonatomic) id<TaskListTableViewCellDelegate> delegate;
- (void)setValueWithTaskModel:(TaskModel *)model;

@end
