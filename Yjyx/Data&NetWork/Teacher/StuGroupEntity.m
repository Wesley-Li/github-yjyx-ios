//
//  StuGroupEntity.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StuGroupEntity.h"

@implementation StuGroupEntity

- (void)initStuGroupWithDic:(NSDictionary *)dic {

    self.memberlist = dic[@"memberlist"];
    
    self.gid = dic[@"id"];
    self.name = dic[@"name"];

}

@end
