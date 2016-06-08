//
//  ProductEntity.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity

+ (ProductEntity *)wrapProductEntityWithDic:(NSDictionary *)dic
{
    ProductEntity *entity = [[ProductEntity alloc] init];
    entity.productID = [dic objectForKey:@"id"];
    entity.img = [dic objectForKey:@"img"];
    entity.price_pacakge = [dic objectForKey:@"price_pacakge"];
    entity.producttype = [dic objectForKey:@"producttype"];
    entity.subject_id = [dic objectForKey:@"subject_id"];
    entity.subject_name = [dic objectForKey:@"subject_name"];
    entity.trialDays = [dic objectForKey:@"trialDays"];
    entity.content = [dic objectForKey:@"description"];
    entity.status = dic[@"status"];
    return entity;
}

@end
