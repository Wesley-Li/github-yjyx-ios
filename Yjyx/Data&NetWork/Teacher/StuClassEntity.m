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
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    self.gradeid = [numberFormatter stringFromNumber:dic[@"gradeid"]];
    self.cid = [numberFormatter stringFromNumber:dic[@"cid"]];
    self.name = dic[@"name"];
}

@end
