//
//  OrderEntity.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderEntity : NSObject

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *paiddatetime;
@property (nonatomic, strong) NSString *product__name;
@property (nonatomic, strong) NSString *total_fee;
@property (nonatomic, strong) NSString *tradeno_yijiao;

+(OrderEntity *)wrapOrderEntityWithDic:(NSDictionary *)dic;

@end
