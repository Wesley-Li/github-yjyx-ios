//
//  TaskModel.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic, copy) NSString *delivertime;// 发布时间
@property (nonatomic, copy) NSString *t_description;// 说明
@property (nonatomic, copy) NSString *deadlinetime;// 截止时间
@property (nonatomic, copy) NSString *resourcename;//资源名称
@property (nonatomic, strong) NSNumber *finished;// 该任务完成学生数
@property (nonatomic, strong) NSNumber *total;// 该任务总共布置给的学生数
@property (nonatomic, strong) NSNumber *tasktype;// 作业类型
@property (nonatomic, strong) NSNumber *t_id;// 任务id号
@property (nonatomic, strong) NSNumber *relatedresourceid;// 相关资源数id


- (void)initTaskModelWithDic:(NSDictionary *)dic;

@end
