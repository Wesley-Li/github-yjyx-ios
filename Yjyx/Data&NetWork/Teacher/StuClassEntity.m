//
//  StuClassEntity.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StuClassEntity.h"

@implementation StuClassEntity

- (void)initStuClassWithDic:(NSDictionary *)dic {

    self.memberlist = dic[@"memberlist"];
    self.gradeid = dic[@"gradeid"];
    self.cid = dic[@"id"];
    
//    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    self.invitecode = dic[@"invitecode"];
    self.name = dic[@"name"];
}

@end
