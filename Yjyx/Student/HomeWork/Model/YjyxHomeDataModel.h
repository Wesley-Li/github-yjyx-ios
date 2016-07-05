//
//  YjyxHomeDataModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxHomeDataModel : NSObject
@property (strong, nonatomic) NSNumber *s_id; // 学科id
@property (strong, nonatomic) NSString *name; // 学科名称
@property (strong, nonatomic) NSString *yj_member; // 会员图片
@property (strong, nonatomic) NSString *icon; // 学科图片
@property (strong, nonatomic) NSArray *todaytasks; // 今天任务

+ (instancetype)homeDataModelWithDict:(NSDictionary *)dict;
@end
