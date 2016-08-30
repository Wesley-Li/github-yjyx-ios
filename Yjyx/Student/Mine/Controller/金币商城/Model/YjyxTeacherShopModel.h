//
//  YjyxTeacherShopModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxTeacherShopModel : NSObject

@property (strong, nonatomic) NSNumber *status; // 状态
@property (strong, nonatomic) NSString *name; // 名字
@property (strong, nonatomic) NSNumber *exchange_coins; // 兑换所需的金币数
@property (strong, nonatomic) NSString *goods_display; // 显示图
@property (strong, nonatomic) NSString *goods_info; // 商品描述
@property (strong, nonatomic) NSNumber *p_id; // 商品类型id


+ (instancetype)teacherShopModelWithDict:(NSDictionary *)dict;
@end
