//
//  YjyxTeacherShopModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxTeacherShopModel.h"

@implementation YjyxTeacherShopModel

+ (instancetype)teacherShopModelWithDict:(NSDictionary *)dict
{
    YjyxTeacherShopModel  *model = [[self alloc] init];
    model.status = dict[@"status"];
    model.name = dict[@"name"];
    model.exchange_coins = dict[@"exchange_coins"];
    model.goods_display = dict[@"goods_display"];
    model.goods_info = dict[@"goods_info"];
    model.p_id = dict[@"id"];
    return model;
}

@end
