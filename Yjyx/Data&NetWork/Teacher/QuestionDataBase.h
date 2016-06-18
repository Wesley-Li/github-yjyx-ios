//
//  QuestionDataBase.h
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChaperContentItem;
@interface QuestionDataBase : NSObject

+ (QuestionDataBase *)shareDataBase;



// 删除数据库
- (void)deleteQuestionTable;

// 添加题目
- (void)insertQuestion:(ChaperContentItem *)model;

// 删除题目
- (void)deleteQuestionByid:(NSString *)qid andQuestionType:(NSString *)subject_type;

// 查询所有题目
- (NSMutableArray *)selectAllQuestion;

// 根据id和类型查询
- (NSMutableArray *)selectQuestionByid:(NSString *)qid andQuestionType:(NSString *)subject_type;

// 根据类型查询
- (NSMutableArray *)selectQuestionByQuestionType:(NSString *)subject_type;


@end
