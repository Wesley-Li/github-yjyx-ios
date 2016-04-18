//
//  YjyxOverallData.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxOverallData.h"

@implementation YjyxOverallData
+ (instancetype)sharedInstance{
    //xs 单例化创建修改 , 普通那样创建的话多线程下是不安全的
    static YjyxOverallData * instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[YjyxOverallData alloc] init];
    });
    return instance;
}

-(ChildrenEntity *)getChildrenWithCid:(NSString *)cid
{
    ChildrenEntity *childrenEntity = nil;
    for (ChildrenEntity *entity in [YjyxOverallData sharedInstance].parentInfo.childrens) {
        if ([cid integerValue] == [entity.cid integerValue]) {
            childrenEntity = entity;
        }
    }
    return childrenEntity;
}

@end
