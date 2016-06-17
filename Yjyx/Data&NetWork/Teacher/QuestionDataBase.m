//
//  QuestionDataBase.m
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "QuestionDataBase.h"
#import "ChaperContentItem.h"
#import "FMDB.h"

@interface QuestionDataBase ()

@property (nonatomic, strong) FMDatabase *question_db;


@end

@implementation QuestionDataBase

static QuestionDataBase *singleton = nil;

+ (QuestionDataBase *)shareDataBase {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[QuestionDataBase alloc] init];
        
        // 创建数据库
        [singleton creatQuestionDataBase];
        
    });
    
    return singleton;

}


// 创建数据库
- (void)creatQuestionDataBase {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断文件是否存在
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [filePath stringByAppendingPathComponent:@"q_db.sqlite"];
    
    self.question_db = [FMDatabase databaseWithPath:path];
    BOOL isOpen = [self.question_db open];
    if (!isOpen) {
        NSLog(@"试题数据库打开出错");
    }
    
    // 创建数据表
    [self creatQuestionTable];

}

// 创建数据表
- (void)creatQuestionTable {

    BOOL isSuccess = [self.question_db executeUpdate:@"create table if not exists Question(id integer PRIMARY KEY AUTOINCREMENT, t_id text, content_text, person_type, p_id, level, subject_type, cellHeight, RCLabelFrame)"];
    NSLog(@"%@", isSuccess ? @"试题表建立成功" : @"试题表建立失败");
}

// 删除数据表
- (void)deleteQuestionTable {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断文件是否存在
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [filePath stringByAppendingPathComponent:@"q_db.sqlite"];
    self.question_db = [FMDatabase databaseWithPath:path];
    BOOL isOpen = [self.question_db open];
    if (!isOpen) {
        NSLog(@"试题数据库打开出错");
    }
    
    BOOL isSuccess = [self.question_db executeUpdate:@"drop table if exists Question"];
    NSLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");


}

// 添加题目
- (void)insertQuestion:(ChaperContentItem *)model {
    
    NSString *t_id = [NSString stringWithFormat:@"%ld", model.t_id];
    NSString *person_type = [NSString stringWithFormat:@"%ld", model.person_type];
    NSString *p_id = [NSString stringWithFormat:@"%ld", model.p_id];
    NSString *level = [NSString stringWithFormat:@"%ld", model.level];
    NSString *cellHeight = [NSString stringWithFormat:@"%f", model.cellHeight];
    NSString *RCLabelFrame = NSStringFromCGRect(model.RCLabelFrame);
    
    BOOL isSuccess = [self.question_db executeUpdate:@"insert into Question(t_id, content_text, person_type, p_id, level, subject_type, cellHeight, RCLabelFrame) values(?,?,?,?,?,?,?,?)", t_id, model.content_text, person_type, p_id, level, model.subject_type, cellHeight, RCLabelFrame];
    
    NSLog(@"%@", isSuccess ? @"添加试题成功" : @"添加试题失败");


}

// 删除题目
- (void)deleteQuestionByid:(NSString *)qid andQuestionType:(NSString *)subject_type {

    BOOL isSuccess = [self.question_db executeUpdate:@"delete from Question where t_id = ? and subject_type = ?", qid, subject_type];
    NSLog(@"%@", isSuccess ? @"删除题目成功" : @"删除题目失败");
}

// 查询所有题目
- (NSMutableArray *)selectAllQuestion {
    
    NSMutableArray *group = [NSMutableArray array];
    
    FMResultSet *set = [self.question_db executeQuery:@"select * from Question"];
    
    while ([set next]) {
        NSString *t_id = [set stringForColumn:@"t_id"];
        NSString *content_text = [set stringForColumn:@"content_text"];
        NSString *person_type = [set stringForColumn:@"person_type"];
        NSString *p_id = [set stringForColumn:@"p_id"];
        NSString *level = [set stringForColumn:@"level"];
        NSString *subject_type = [set stringForColumn:@"subject_type"];
        NSString *cellHeight = [set stringForColumn:@"cellHeight"];
        NSString *RCLabelFrame = [set stringForColumn:@"RCLabelFrame"];
        
        // 封装到模型
        ChaperContentItem *model = [[ChaperContentItem alloc] init];
        model.t_id = [t_id integerValue];
        model.content_text = content_text;
        model.person_type = [person_type integerValue];
        model.p_id = [p_id integerValue];
        model.level = [level integerValue];
        model.subject_type = subject_type;
        model.cellHeight = [cellHeight floatValue];
        model.RCLabelFrame = CGRectFromString(RCLabelFrame);
        
        [group addObject:model];
        
    }
    
    return group;


}

// 根据id查询
- (NSMutableArray *)selectQuestionByid:(NSString *)qid andQuestionType:(NSString *)subject_type {
    
    NSMutableArray *group = [NSMutableArray array];
    
    FMResultSet *set = [self.question_db executeQuery:@"select * from Question where t_id = ? and subject_type = ?", qid, subject_type];
    
    while ([set next]) {
        NSString *t_id = [set stringForColumn:@"t_id"];
        NSString *content_text = [set stringForColumn:@"content_text"];
        NSString *person_type = [set stringForColumn:@"person_type"];
        NSString *p_id = [set stringForColumn:@"p_id"];
        NSString *level = [set stringForColumn:@"level"];
        NSString *subject_type = [set stringForColumn:@"subject_type"];
        NSString *cellHeight = [set stringForColumn:@"cellHeight"];
        NSString *RCLabelFrame = [set stringForColumn:@"RCLabelFrame"];
        
        // 封装到模型
        ChaperContentItem *model = [[ChaperContentItem alloc] init];
        model.t_id = [t_id integerValue];
        model.content_text = content_text;
        model.person_type = [person_type integerValue];
        model.p_id = [p_id integerValue];
        model.level = [level integerValue];
        model.subject_type = subject_type;
        model.cellHeight = [cellHeight floatValue];
        model.RCLabelFrame = CGRectFromString(RCLabelFrame);
        
        [group addObject:model];
        
    }
    
    return group;
    


}



@end
