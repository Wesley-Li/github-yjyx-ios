//
//  YjyxTodayWorkModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxTodayWorkModel.h"

@implementation YjyxTodayWorkModel

+ (instancetype)todayWorkModelWithDict:(NSDictionary *)dict
{
    YjyxTodayWorkModel *model = [[self alloc] init];
    model.finishtime = dict[@"finishtime"];
    model.task_delivertime = dict[@"task__delivertime"];
    model.task_subjectid = dict[@"task__subjectid"];
    model.task_relatedresourceid = dict[@"task__relatedresourceid"];
    model.summary = dict[@"summary"];
    model.finished  = dict[@"finished"];
    model.delivername  = dict[@"delivername"];
    model.tasktype = dict[@"tasktype"];
    model.task_description = dict[@"task__description"];
    model.t_id = dict[@"id"];
    return model;
}
- (NSString *)task_delivertime
{
    NSLog(@"%@", _task_delivertime);
    NSArray *arr = [_task_delivertime componentsSeparatedByString:@"."];
    NSString *timeStr = arr.firstObject;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *tempDate = [fmt dateFromString:timeStr];
    NSLog(@"%@", tempDate);
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *str = [fmt stringFromDate:tempDate];
    return str;
}
- (NSString *)task_description
{
    return [_task_description stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end

