//
//  OrderEntity.m
//  Yjyx
//
//  Created by zhujianyu on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderEntity

+(OrderEntity *)wrapOrderEntityWithDic:(NSDictionary *)dic
{
    OrderEntity *entity = [[OrderEntity alloc] init];
    entity.orderID = [dic objectForKey:@"id"];
    entity.paiddatetime = [dic objectForKey:@"paiddatetime"];
    entity.product__name = [dic objectForKey:@"product__name"];
    entity.total_fee = [dic objectForKey:@"total_fee"];
    entity.tradeno_yijiao = [dic objectForKey:@"tradeno_yijiao"];
    return entity;
}

@end
