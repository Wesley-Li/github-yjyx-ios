//
//  OneStudentEntity.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/30.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OneStudentEntity.h"

@implementation OneStudentEntity

+ (instancetype)studentEntityWithDict:(NSDictionary *)dict
{
    OneStudentEntity *stuEntity = [[self alloc] init];
    stuEntity.classid = dict[@"classid"];
    stuEntity.classname = dict[@"classname"];
    stuEntity.phonenumber = dict[@"phonenumber"];
    stuEntity.schoolprovincename = dict[@"schoolprovincename"];
    stuEntity.invitecode = dict[@"invitecode"];
    stuEntity.coins = dict[@"coins"];
    stuEntity.email = dict[@"email"];
    stuEntity.username = dict[@"username"];
    stuEntity.teacherlist = dict[@"teacherlist"];
    stuEntity.realname = dict[@"realname"];
    stuEntity.schoolprovincename = dict[@"schoolprovincename"];
    stuEntity.gradeid = dict[@"gradeid"];
    stuEntity.schooldistictname = dict[@"schooldistictname"];
    stuEntity.schooltypeid = dict[@"schooltypeid"];
    stuEntity.sessionid = dict[@"sessionid"];
    stuEntity.schooltypename = dict[@"schooltypename"];
    stuEntity.desc = dict[@"desc"];
    stuEntity.schoolid = dict[@"schoolid"];
    stuEntity.gradename = dict[@"gradename"];
    stuEntity.schoolname = dict[@"schoolname"];
    stuEntity.avatar_url = dict[@"avatar_url"];
    stuEntity.notify_setting = dict[@"notify_setting"];
    return stuEntity;
}
@end
