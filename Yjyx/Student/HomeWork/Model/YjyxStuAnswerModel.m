//
//  YjyxStuAnswerModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuAnswerModel.h"

@implementation YjyxStuAnswerModel

+ (instancetype)stuAnswerModelWithArr:(NSArray *)arr
{
    YjyxStuAnswerModel *model = [[self alloc] init];
    model.t_id = [arr[0] stringValue];
    model.stuAnswerArr = arr[1];
    model.isRight = arr[2];
    model.s_time = arr[3];
    return model;
}
@end
