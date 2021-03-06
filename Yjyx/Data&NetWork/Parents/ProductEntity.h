//
//  ProductEntity.h
//  Yjyx
//
//  Created by zhujianyu on 16/4/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductEntity : NSObject
@property(nonatomic, strong) NSString *productID;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *producttype;
@property(nonatomic, strong) NSString *subject_id;
@property(nonatomic, strong) NSString *subject_name;
@property(nonatomic, strong) NSString *trialDays;
@property(nonatomic, strong) NSArray *price_pacakge;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSNumber *status;

+(ProductEntity *)wrapProductEntityWithDic:(NSDictionary *)dic;

@end
