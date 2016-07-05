//
//  YjyxHomeDataModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeDataModel.h"
#import "YjyxTodayWorkModel.h"
@implementation YjyxHomeDataModel

+ (instancetype)homeDataModelWithDict:(NSDictionary *)dict
{
    YjyxHomeDataModel  *model = [[self alloc] init];
    model.s_id = dict[@"id"];
    model.name = dict[@"name"];
    model.yj_member = [dict[@"avatar"] JSONValue][@"yj_member"];
    model.icon = [dict[@"avatar"] JSONValue][@"icon"];
    NSMutableArray *tempArr = [NSMutableArray array];
    
    NSArray *arr = dict[@"todaytasks"];
    for (NSDictionary *dict in arr) {
        YjyxTodayWorkModel *tempModel = [YjyxTodayWorkModel todayWorkModelWithDict:dict];
        [tempArr addObject:tempModel];
    }
    model.todaytasks = tempArr;
    return model;
}
@end
