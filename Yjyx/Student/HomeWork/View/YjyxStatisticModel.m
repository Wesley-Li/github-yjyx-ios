//
//  YjyxStatisticModel.m
//  Yjyx
//
//  Created by liushaochang on 16/7/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStatisticModel.h"

@implementation YjyxStatisticModel


- (void)initModelWithDic:(NSDictionary *)dic {

    self.name = dic[@"name"];
    self.questiontotal = [dic[@"questiontotal"] isEqual:[NSNull null]] ? @0 : dic[@"questiontotal"];
    self.tasks_num = [dic[@"tasks_num"] isEqual:[NSNull null]] ? @0 : dic[@"tasks_num"];
    self.questioncorrect = [dic[@"questioncorrect"] isEqual:[NSNull null]] ? @0 : dic[@"questioncorrect"];
    self.subjectid = dic[@"subjectid"];
    self.recv_num = [dic[@"recv_num"] isEqual:[NSNull null]] ? @0 : dic[@"recv_num"];
    self.questionwrong = [dic[@"questionwrong"] isEqual:[NSNull null]] ? @0 : dic[@"questionwrong"];
    self.yj_member = [[dic[@"avatar"] JSONValue]objectForKey:@"yj_member"];


}



@end
