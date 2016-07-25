//
//  MicroDetailModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroDetailModel.h"

@implementation MicroDetailModel

+ (instancetype)microDetailModelWithDict:(NSDictionary *)dict
{
    MicroDetailModel *model = [[self alloc] init];
    model.create_time = dict[@"create_time"];
    NSString *str = dict[@"knowledgedesc"];
    if ([dict[@"knowledgedesc"] containsString:@"&nbsp;"]) {
        str = [dict[@"knowledgedesc"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }
    model.knowledgedesc = str;
    model.name = dict[@"name"];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSLog(@"%@-------", [dict[@"videoobjlist"] JSONValue]);
    NSArray *arr = [dict[@"videoobjlist"] JSONValue];
    for (NSDictionary *dict in arr) {
        [tempArr addObject:dict[@"url"]];
    }
    model.videoUrlArr = tempArr;
    NSLog(@"%@+++_---%@", model.videoUrlArr, tempArr);
    model.questionList = [dict[@"quizcontent"] JSONValue][@"questionList"] ;
    return model;
}
@end
