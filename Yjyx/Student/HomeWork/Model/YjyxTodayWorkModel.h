//
//  YjyxTodayWorkModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxTodayWorkModel : NSObject

@property (strong, nonatomic) NSString *finishtime; // 完成时间
@property (strong, nonatomic) NSString *task_delivertime; // 发布时间
@property (strong, nonatomic) NSNumber *task_subjectid; // 本次作业ID
@property (strong, nonatomic) NSNumber *task_id;
@property (strong, nonatomic) NSString *resourcename; // 资源名
@property (strong, nonatomic) NSNumber *task_relatedresourceid; // 本任务的资源id
@property (strong, nonatomic) NSDictionary *summary; // 总的错误与正确率
@property (strong, nonatomic) NSNumber *finished; // 是否完成
@property (strong, nonatomic) NSString *delivername; // 发布作业的老师名
@property (strong, nonatomic) NSNumber *tasktype; // 作业类型
@property (strong, nonatomic) NSString *task_description; // 任务描述
@property (strong, nonatomic) NSNumber *t_id; // 获取老数据使用
@property (strong, nonatomic) NSNumber *totalCorrect;
@property (strong, nonatomic) NSNumber *totalWrong;
@property (strong, nonatomic) NSNumber *spendTime; // 花费时间
@property (strong, nonatomic) NSNumber *task__suggestspendtime; // 建议时间

@property (assign, nonatomic) CGFloat height;

+ (instancetype)todayWorkModelWithDict:(NSDictionary *)dict;
@end
