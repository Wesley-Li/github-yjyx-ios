//
//  OneSubjectModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneSubjectModel : NSObject
// 内容
@property (copy, nonatomic) NSString *content;
// 解题视频地址
@property (copy, nonatomic) NSString *videourl;
// 总共选项个数
@property (copy, nonatomic) NSString *choicecount;
// 文字解析
@property (copy, nonatomic) NSString *explanation;
// 难度等级
@property (assign, nonatomic) NSInteger level;
// 答案
@property (copy, nonatomic) NSString *answer;
// 题目id
@property (assign, nonatomic) NSInteger t_id;
// 第一行cell的高度
@property (assign, nonatomic) CGFloat firstCellHeight;
// 第一行RCLabel的frame
@property (assign, nonatomic) CGRect firstFrame;
// 第二行cell的高度
@property (assign, nonatomic) CGFloat secondCellHeight;
// 第三行cell的高度
@property (assign, nonatomic) CGFloat threeCellHeight;
// 第三行RCLabel的frame
@property (assign, nonatomic) CGRect threeFrame;

+ (instancetype)oneSubjectModelWithDict:(NSDictionary *)dict;
@end
