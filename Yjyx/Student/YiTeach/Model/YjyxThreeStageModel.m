//
//  YjyxThreeStageModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxThreeStageModel.h"

@implementation YjyxThreeStageModel

+ (instancetype)threeStageModelWithDict:(NSDictionary *)dict
{
    YjyxThreeStageModel *model = [[self alloc] init];
    model.videourl = dict[@"videourl"];
    model.explanation = dict[@"explanation"];
    model.subjectid = dict[@"subjectid"];
    model.t_id = dict[@"id"];
    model.level = dict[@"level"];
    model.content = dict[@"content"];
    model.answer = dict[@"answer"];
    model.choicecount = dict[@"choicecount"];
    return model;
}
@end
