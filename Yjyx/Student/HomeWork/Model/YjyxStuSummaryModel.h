//
//  YjyxStuSummaryModel.h
//  Yjyx
//
//  Created by liushaochang on 16/8/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxStuSummaryModel : NSObject

@property (nonatomic, strong) NSNumber *c_num;// 做对人数
@property (nonatomic, strong) NSNumber *w_num;// 做错人数

- (void)initModelWithDic:(NSDictionary *)dic;

@end
