//
//  WrongDataBase.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YjyxWrongSubModel;
@interface WrongDataBase : NSObject

+ (WrongDataBase *)shareDataBase;



// 删除数据库
- (void)deleteQuestionTable;

// 添加题目
- (void)insertQuestion:(YjyxWrongSubModel *)model;

// 删除题目
- (void)deleteQuestionByid:(NSString *)w_id andQuestionType:(NSString *)subject_type;

// 查询所有题目
- (NSMutableArray *)selectAllQuestion;

// 根据id和类型查询
- (NSMutableArray *)selectQuestionByid:(NSString *)w_id andQuestionType:(NSString *)subject_type;
@end
