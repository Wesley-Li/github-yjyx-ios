//
//  ResultModel.h
//  Yjyx
//
//  Created by liushaochang on 16/6/28.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

// 主要是学生答题情况
@property (nonatomic, copy) NSString *questionType;
@property (nonatomic, strong) NSNumber *q_id;// 题目id
@property (nonatomic, strong) NSArray *myAnswer;// 学生输入结果
@property (nonatomic, strong) NSNumber *rightOrWrong;// 是否正确
@property (nonatomic, strong) NSNumber *time;// 本题所花时间
@property (nonatomic, strong) NSArray *writeprocess;// 批注

- (void)initModelWithArray:(NSArray *)array;



@end
