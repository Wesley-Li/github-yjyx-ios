//
//  StudentEntity.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StudentEntity.h"

@implementation StudentEntity



- (void)initStudentWithDic:(NSDictionary *)dic {
    
    self.avatar_url = dic[@"avatar_url"];
    self.user_id = dic[@"user_id"];
    self.realname = dic[@"realname"];
    self.isyjmember = dic[@"isyjmember"];
}

@end
