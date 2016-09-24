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
    model.resourcename  = dict[@"resourcename"];
    model.task_id = dict[@"task_id"];
    model.task_relatedresourceid = dict[@"task__relatedresourceid"];
    model.summary = [YjyxTodayWorkModel dictionaryWithJsonString:dict[@"summary"]] ;
    model.finished  = dict[@"finished"];
    model.delivername  = dict[@"delivername"];
    model.tasktype = dict[@"tasktype"];
    model.task_description = dict[@"task__description"];
    model.t_id = dict[@"id"];
    model.totalCorrect = dict[@"task__total_correct"];
    model.totalWrong = dict[@"task__total_wrong"];
    model.spendTime = dict[@"spendTime"];
    model.task__suggestspendtime = dict[@"task__suggestspendtime"];
    return model;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if ([jsonString isEqual: [NSNull null]]) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (NSString *)task_delivertime
{
//    NSLog(@"%@", _task_delivertime);
    NSArray *arr = [_task_delivertime componentsSeparatedByString:@"."];
    NSString *timeStr = arr.firstObject;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *tempDate = [fmt dateFromString:timeStr];
//    NSLog(@"%@", tempDate);
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *str = [fmt stringFromDate:tempDate];
    return str;
}
- (NSString *)finishtime
{
    //    NSLog(@"%@", _task_delivertime);
    NSArray *arr = [_finishtime componentsSeparatedByString:@"."];
    NSString *timeStr = arr.firstObject;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *tempDate = [fmt dateFromString:timeStr];
    //    NSLog(@"%@", tempDate);
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *str = [fmt stringFromDate:tempDate];
    return str;
}
- (NSString *)task_description
{
    return [_task_description stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end

