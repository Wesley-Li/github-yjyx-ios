//
//  YjyxWorkDetailModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkDetailModel.h"

@implementation YjyxWorkDetailModel

+ (instancetype)workDetailModelWithDict:(NSDictionary *)dict
{
    YjyxWorkDetailModel *model = [[self alloc] init];
    model.level = dict[@"level"];
    model.explanation = dict[@"explanation"];
    model.videourl = dict[@"videourl"];
    model.content = dict[@"content"];
    model.showview = dict[@"showview"];
    model.answer = dict[@"answer"];
    model.choicecount = [dict[@"choicecount"] integerValue];
    return model;
}



@end
