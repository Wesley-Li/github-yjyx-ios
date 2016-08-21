//
//  SummaryResultModel.m
//  Yjyx
//
//  Created by liushaochang on 16/8/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SummaryResultModel.h"

@implementation SummaryResultModel

- (void)initModelWithDic:(NSDictionary *)dic {

    self.c_num = [dic[@"C"] isEqual:[NSNull null]] ? 0 : dic[@"C"];
    self.w_num = [dic[@"W"] isEqual:[NSNull null]] ? 0 : dic[@"W"];
}

@end
