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
@property (copy, nonatomic) NSString *total_wrong_num;
// 题目的类型
@property (assign, nonatomic) NSInteger questiontype;
// 题目id
@property (assign, nonatomic) NSInteger questionid;

// 底部条需要拉伸的长度
@property (assign, nonatomic) CGFloat pullHeight;
// 是否是选题
@property (assign, nonatomic) BOOL isSelected;
// 是否需要加载更多答案
@property (assign, nonatomic) BOOL isLoadMore;
// cell的高度
@property (assign, nonatomic) CGFloat cellHeight;


+ (instancetype)wrongSubjectModelWithDict:(NSDictionary *)dict;
@end
