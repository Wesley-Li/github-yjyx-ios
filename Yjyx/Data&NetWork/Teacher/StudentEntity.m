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
    self.realname = dic[@"realname"];
    
    if ([[dic allKeys] containsObject:@"user_id"]) {
        self.user_id = dic[@"user_id"];
    }
    
    if ([[dic allKeys] containsObject:@"isyjmember"]) {
        self.isyjmember = dic[@"isyjmember"];
    }
    
}

@end
