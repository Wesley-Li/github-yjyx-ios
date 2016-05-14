//
//  TeacherEntity.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TeacherEntity.h"

@implementation TeacherEntity

+ (TeacherEntity *)wrapTeacherWithDic:(NSDictionary *)dic {

    TeacherEntity *teacherEntity = [[TeacherEntity alloc] init];
    
    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    
    teacherEntity.name = dic[@"name"];
    teacherEntity.phone = dic[@"phone"];
    teacherEntity.email = dic[@"email"];
    teacherEntity.sessionid = dic[@"sessionid"];
    teacherEntity.avatar = dic[@"avatar"];
    teacherEntity.birth = dic[@"birth"];
    teacherEntity.coins = [numberF stringFromNumber: dic[@"coins"]];
    teacherEntity.age = dic[@"age"];
    
    teacherEntity.school_province = [dic[@"school"] objectForKey:@"province"];
    teacherEntity.school_city = [dic[@"school"] objectForKey:@"city"];
    teacherEntity.school_district = [dic[@"school"] objectForKey:@"district"];
    teacherEntity.school_id = [numberF stringFromNumber:[dic[@"school"] objectForKey:@"schoolid"]];
    teacherEntity.school_name = [dic[@"school"] objectForKey:@"name"];
    teacherEntity.school_typeid = [numberF stringFromNumber:[dic[@"school"] objectForKey:@"typeid"]];
    teacherEntity.school_typename = [dic[@"school"] objectForKey:@"typename"];
    
    teacherEntity.school_classes = [[dic[@"school"] objectForKey:@"classes"] componentsSeparatedByString:@","];

    
    return teacherEntity;
}


@end
