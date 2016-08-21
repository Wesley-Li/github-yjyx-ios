//
//  YjyxStuSummaryModel.m
//  Yjyx
//
//  Created by liushaochang on 16/8/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuSummaryModel.h"

@implementation YjyxStuSummaryModel

- (void)initModelWithDic:(NSDictionary *)dic {
    
    self.c_num = dic[@"C"];
    self.w_num = dic[@"W"];
}


@end
