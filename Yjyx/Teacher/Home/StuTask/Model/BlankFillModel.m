//
//  BlankFillModel.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "BlankFillModel.h"

@implementation BlankFillModel

- (void)initBlankFillModelWithDic:(NSDictionary *)dic {

    self.b_id = dic[@"id"];
    self.AVT = dic[@"AVT"];
    self.C_count = dic[@"C"];
    self.CNL = dic[@"CNL"];
    self.W_count = dic[@"W"];
    self.WNL = dic[@"WNL"];
}

@end
