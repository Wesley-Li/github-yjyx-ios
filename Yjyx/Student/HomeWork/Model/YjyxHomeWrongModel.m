//
//  YjyxHomeWrongModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeWrongModel.h"

@implementation YjyxHomeWrongModel

+ (instancetype)homeWrongModelWithDict:(NSDictionary *)dict
{
    YjyxHomeWrongModel  *model = [[self alloc] init];
    model.yj_member = [dict[@"avatar"] JSONValue][@"yj_member"];
    model.icon = [dict[@"avatar"] JSONValue][@"icon"];
    model.failedquestions = [dict[@"failedquestions"] JSONValue];
//    NSLog(@"%@", model.failedquestions);
    model.subjectid = dict[@"subjectid"];
    model.subjectname = dict[@"subjectname"];
    
    return model;
}
@end
