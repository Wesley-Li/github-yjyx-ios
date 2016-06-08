//
//  GradeContentItem.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "GradeContentItem.h"

@implementation GradeContentItem

+ (instancetype)gradeContentItem:(NSDictionary *)dict
{
    GradeContentItem *item = [[self alloc] init];
    item.g_id = dict[@"id"];
    item.parent = dict[@"parent"];
    item.text = dict[@"text"];
    return item;
}
@end
