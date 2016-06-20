//
//  YjyxWrongSubModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxWrongSubModel : NSObject
// 正确答案
@property (copy, nonatomic) NSString *answer;
// 题目内容
@property (copy, nonatomic) NSString *content;
// 题目id
@property (assign, nonatomic) NSInteger t_id;
// 题目的难度
@property (assign, nonatomic) NSInteger level;
// 总错题数
@property (assign, nonatomic) NSInteger total_wrong_num;
// 题目的类型
@property (assign, nonatomic) NSInteger questiontype;
// 题目id
@property (assign, nonatomic) NSInteger questionid;
// cell的高度
@property (assign, nonatomic) CGFloat cellHeight;
// RCLabel的frame
@property (assign, nonatomic) CGRect cellFrame;

+ (instancetype)wrongSubjectModelWithDict:(NSDictionary *)dict;
@end
