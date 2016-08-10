//
//  YjyxHomeAdModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeAdModel.h"

@implementation YjyxHomeAdModel

+ (instancetype)homeAdModelWithDict:(NSDictionary *)dict
{
    YjyxHomeAdModel *model = [[self alloc] init];
    model.detail_page = dict[@"detail_page"];
    model.img = dict[@"img"];
    return model;
}
@end
