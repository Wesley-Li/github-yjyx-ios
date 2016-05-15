//
//  OrderNewEntity.m
//  Yjyx
//
//  Created by zhujianyu on 16/5/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OrderNewEntity.h"

@implementation OrderNewEntity
+(OrderNewEntity *)wrapOrderEntityWithDic:(NSDictionary *)dic
{
    OrderNewEntity *entity = [[OrderNewEntity alloc] init];
    entity.orderID = [dic objectForKey:@"id"];
    entity.tradeno_yijiao = [dic objectForKey:@"tradeno_yijiao"];
    entity.paiddatetime = [dic objectForKey:@"paiddatetime"];
    entity.total_fee = [dic objectForKey:@"total_fee"];
    entity.product__name = [dic objectForKey:@"product__name"];
    return entity;
}
@end
