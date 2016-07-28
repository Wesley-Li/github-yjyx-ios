//
//  YjyxExchangeRecordModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxExchangeRecordModel : NSObject

@property (strong, nonatomic) NSString *exec_datetime; // 兑换日期
@property (strong, nonatomic) NSString *goods_type_name; // 商品名称
@property (strong, nonatomic) NSString *specific_info; // 充值卡序列号
@property (strong, nonatomic) NSNumber *exchange_coins; // 兑换是花费的金币
@property (strong, nonatomic) NSNumber *p_id; // 商品id
@property (assign, nonatomic) CGFloat cellHeight;

+ (instancetype)exchangeRecordModelWithDict:(NSDictionary *)dict;
@end
