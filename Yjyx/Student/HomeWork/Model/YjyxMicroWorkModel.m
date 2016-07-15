//
//  YjyxMicroWorkModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxMicroWorkModel.h"

@implementation YjyxMicroWorkModel

+ (instancetype)microWorkModelWithDict:(NSDictionary *)dict
{
    YjyxMicroWorkModel *model =[[self alloc] init];
    model.knowledgedesc = dict[@"knowledgedesc"];
    model.name = dict[@"name"];
    model.videoobjlist = [dict[@"videoobjlist"] JSONValue];
    return model;
}
@end
