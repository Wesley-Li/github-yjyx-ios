//
//  QuestionDataBase.h
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChaperContentItem, YjyxWrongSubModel, MicroSubjectModel;
@interface QuestionDataBase : NSObject

+ (QuestionDataBase *)shareDataBase;



// 删除数据库
- (void)deleteQuestionTable;
- (void)deleteMicroTable;
- (void)deleteTemptable;

// 添加题目
- (void)insertQuestion:(ChaperContentItem *)model;
// 添加错题
- (void)insertWrong:(YjyxWrongSubModel *)model;
// 添加微课
- (void)insertMirco:(MicroSubjectModel *)model;
// 向临时表添加题目
- (void)insertTemp:(id)model;
// 查询临时表所有题目
- (NSMutableArray *)selectAllTempQuestion;

// 删除题目
- (void)deleteQuestionByid:(NSString *)qid andQuestionType:(NSString *)subject_type andJumpType:(NSString *)jumpT;

// 查询所有题目
- (NSMutableArray *)selectAllQuestionWithJumpType:(NSString *)jumpT;

// 根据id和类型查询
- (NSMutableArray *)selectQuestionByid:(NSString *)qid andQuestionType:(NSString *)subject_type andJumpType:(NSString *)jumpT;

// 根据类型查询
- (NSMutableArray *)selectQuestionByQuestionType:(NSString *)subject_type andJumpType:(NSString *)jumpT;


@end
