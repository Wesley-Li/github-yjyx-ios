//
//  OrderNewEntity.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNewEntity : NSObject
@property (nonatomic,strong) NSString *tradeno_yijiao;
@property (nonatomic,strong) NSString *paiddatetime;
@property (nonatomic,strong) NSString *total_fee;
@property (nonatomic,strong) NSString *product__name;
@property (nonatomic,strong) NSString *orderID;

+(OrderNewEntity *)wrapOrderEntityWithDic:(NSDictionary *)dic;

@end
