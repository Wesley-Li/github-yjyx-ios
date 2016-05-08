//
//  BlankFillModel.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlankFillModel : NSObject

@property (nonatomic, strong) NSNumber *b_id;
@property (nonatomic, strong) NSNumber *AVT;// 平均耗时
@property (nonatomic, strong) NSNumber *C_count;// 作对的学生数
@property (nonatomic, strong) NSArray *CNL;// 作对学生id列表
@property (nonatomic, strong) NSNumber *W_count;// 做错的学生数
@property (nonatomic, strong) NSArray *WNL;// 做错的学生列表

- (void)initBlankFillModelWithDic:(NSDictionary *)dic;

@end
