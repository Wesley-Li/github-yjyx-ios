//
//  YjyxStuAnswerModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxStuAnswerModel : NSObject

@property (strong, nonatomic) NSNumber *subject_type; // 1 代表选择 2 代表填空题
@property (strong, nonatomic) NSString *t_id;
@property (strong, nonatomic) NSArray *stuAnswerArr;
@property (strong, nonatomic) NSNumber *isRight;
@property (strong, nonatomic) NSNumber *s_time;

+ (instancetype)stuAnswerModelWithArr:(NSArray *)arr;
@end
