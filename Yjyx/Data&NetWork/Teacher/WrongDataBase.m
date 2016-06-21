//
//  WrongDataBase.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongDataBase.h"
#import "YjyxWrongSubModel.h"
#import "FMDB.h"
@interface WrongDataBase()

@property (nonatomic, strong) FMDatabase *question_db;

@end
@implementation WrongDataBase

static WrongDataBase *singleton = nil;

+ (WrongDataBase *)shareDataBase {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[WrongDataBase alloc] init];
        
        // 创建数据库
        [singleton creatQuestionDataBase];
        
    });
    
    return singleton;
    
}


- (void)creatQuestionDataBase
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断文件是否存在
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [filePath stringByAppendingPathComponent:@"w_db.sqlite"];
    
    self.question_db = [FMDatabase databaseWithPath:path];
    BOOL isOpen = [self.question_db open];
    if (!isOpen) {
        NSLog(@"试题数据库打开出错");
    }
    // 创建数据表
    [self creatQuestionTable];
}
// 创建数据表
- (void)creatQuestionTable
{
    BOOL isSuccess = [self.question_db executeUpdate:@"create table if not exists Question(id integer PRIMARY KEY AUTOINCREMENT, w_id text, answer, content, total_wrong_num, questionid, level, questiontype, cellHeight, cellFrame)"];
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
    
    NSString *path = [filePath stringByAppendingPathComponent:@"w_db.sqlite"];
    self.question_db = [FMDatabase databaseWithPath:path];
    BOOL isOpen = [self.question_db open];
    if (!isOpen) {
        NSLog(@"试题数据库打开出错");
    }
    
    BOOL isSuccess = [self.question_db executeUpdate:@"drop table if exists Question"];
    NSLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");
    
    // 重新建表
    [self creatQuestionTable];
    
}
// 添加题目
- (void)insertQuestion:(YjyxWrongSubModel *)model {
    
    NSString *w_id = [NSString stringWithFormat:@"%ld", model.t_id];
    NSString *questiontype = [NSString stringWithFormat:@"%ld", model.questiontype];
    NSString *questionid = [NSString stringWithFormat:@"%ld", model.questionid];
    NSString *level = [NSString stringWithFormat:@"%ld", model.level];
    NSString *cellHeight = [NSString stringWithFormat:@"%f", model.cellHeight];
    NSString *cellFrame = NSStringFromCGRect(model.cellFrame);
    NSString *answer = model.answer;
    NSString *content = model.content;
    NSString *total_wrong_num =  model.total_wrong_num;
    
    BOOL isSuccess = [self.question_db executeUpdate:@"insert into Question(w_id, content, questiontype, questionid, level, cellHeight, cellFrame, answer, total_wrong_num) values(?,?,?,?,?,?,?,?,?)", w_id, content, questiontype, questionid, level,  cellHeight, cellFrame, answer, total_wrong_num];
    
    NSLog(@"%@", isSuccess ? @"添加试题成功" : @"添加试题失败");
    
}
// 删除题目
- (void)deleteQuestionByid:(NSString *)w_id andQuestionType:(NSString *)questiontype {
    
    BOOL isSuccess = [self.question_db executeUpdate:@"delete from Question where w_id = ? and questiontype = ?", w_id, questiontype];
    NSLog(@"%@", isSuccess ? @"删除题目成功" : @"删除题目失败");
}
// 查询所有题目
- (NSMutableArray *)selectAllQuestion {
    
    NSMutableArray *group = [NSMutableArray array];
    
    FMResultSet *set = [self.question_db executeQuery:@"select * from Question"];
    
    while ([set next]) {
        NSString *w_id = [set stringForColumn:@"w_id"];
        NSString *content = [set stringForColumn:@"content"];
        NSString *questiontype = [set stringForColumn:@"questiontype"];
        NSString *questionid = [set stringForColumn:@"questionid"];
        NSString *level = [set stringForColumn:@"level"];
        NSString *cellHeight = [set stringForColumn:@"cellHeight"];
        NSString *cellFrame = [set stringForColumn:@"cellFrame"];
        NSString *answer = [set stringForColumn:@"answer"];
        NSString *total_wrong_num = [set stringForColumn:@"total_wrong_num"];
        
        // 封装到模型
        YjyxWrongSubModel *model = [[YjyxWrongSubModel alloc] init];
        model.t_id = [w_id integerValue];
        model.content = content;
        model.questiontype = [questiontype integerValue];
        model.questionid = [questionid integerValue];
        model.level = [level integerValue];
        model.cellHeight = [cellHeight floatValue];
        model.cellFrame = CGRectFromString(cellFrame);
        model.answer = answer;
        model.total_wrong_num = total_wrong_num;
        
        [group addObject:model];
        
    }
    
    return group;
    
    
}
// 根据id查询
- (NSMutableArray *)selectQuestionByid:(NSString *)w_id andQuestionType:(NSString *)questiontype {
    
    NSMutableArray *group = [NSMutableArray array];
    
    FMResultSet *set = [self.question_db executeQuery:@"select * from Question where w_id = ? and questiontype = ?", w_id, questiontype];
    
    while ([set next]) {
        NSString *w_id = [set stringForColumn:@"w_id"];
        NSString *content = [set stringForColumn:@"content"];
        NSString *questiontype = [set stringForColumn:@"questiontype"];
        NSString *questionid = [set stringForColumn:@"questionid"];
        NSString *level = [set stringForColumn:@"level"];
        NSString *cellHeight = [set stringForColumn:@"cellHeight"];
        NSString *cellFrame = [set stringForColumn:@"cellFrame"];
        NSString *answer = [set stringForColumn:@"answer"];
        NSString *total_wrong_num = [set stringForColumn:@"total_wrong_num"];
        
        // 封装到模型
        YjyxWrongSubModel *model = [[YjyxWrongSubModel alloc] init];
        model.t_id = [w_id integerValue];
        model.content = content;
        model.questiontype = [questiontype integerValue];
        model.questionid = [questionid integerValue];
        model.level = [level integerValue];
        model.cellHeight = [cellHeight floatValue];
        model.cellFrame = CGRectFromString(cellFrame);
        model.answer = answer;
        model.total_wrong_num = total_wrong_num;
        
        [group addObject:model];
        
    }
    
    return group;
    
    
    
}
@end
