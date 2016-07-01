//
//  MyMicroModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMicroModel : NSObject
// 微课id
@property (strong, nonatomic) NSNumber *m_id;
// 微课名称
@property (strong, nonatomic) NSString *name;
// 微课描述
@property (strong, nonatomic) NSString *descrip;
// 出题人类型
@property (assign, nonatomic) NSInteger p_type;

+ (instancetype)myMicroModelWithArr:(NSArray *)arr;
@end
