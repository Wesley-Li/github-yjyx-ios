//
//  YjyxDoingWorkModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDoingWorkModel.h"

@implementation YjyxDoingWorkModel

+ (instancetype)doingWorkModelWithDict:(NSDictionary *)dict
{
    YjyxDoingWorkModel  *model = [[self alloc] init];
    model.blankcount = dict[@"blankcount"];
    model.choicecount  = dict[@"choicecount"];
    model.content = dict[@"content"];
    model.answer = dict[@"answer"];
    model.t_id = dict[@"id"];
    return model;
}
@end
