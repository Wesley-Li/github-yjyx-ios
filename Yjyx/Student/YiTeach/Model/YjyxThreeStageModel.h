//
//  YjyxThreeStageModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxThreeStageModel : NSObject

@property (strong, nonatomic) NSString *videourl; // 视频解析
@property (strong, nonatomic) NSString *explanation; // 文字解析
@property (strong, nonatomic) NSNumber *subjectid; // 科目id
@property (strong, nonatomic) NSNumber *t_id; // 题目id
@property (strong, nonatomic) NSNumber *level; // 题目难度
@property (strong, nonatomic) NSString *content; // 内容
@property (strong, nonatomic) NSString *answer;  // 答案
@property (strong, nonatomic) NSNumber *choicecount; // 选择项数目

+ (instancetype)threeStageModelWithDict:(NSDictionary *)dict;
@end
