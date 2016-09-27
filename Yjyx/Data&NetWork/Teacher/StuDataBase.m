//
//  StuDataBase.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StuDataBase.h"
#import "FMDB.h"
#import "StudentEntity.h"
#import "StuClassEntity.h"
#import "StuGroupEntity.h"

@interface StuDataBase ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation StuDataBase

static StuDataBase *singleton = nil;

+ (StuDataBase *)shareStuDataBase {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[StuDataBase alloc] init];
        // 单例创建即附带数据库
        [singleton creatStuDataBase];
        
    });
    
    return singleton;
}

// 创建学生数据库
- (void)creatStuDataBase {

    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 存储路径
    NSString *path = [filePath stringByAppendingPathComponent:@"db.sqlite"];
    
    self.db = [FMDatabase databaseWithPath:path];
    
    // 打开数据库,并创建数据库文件
    BOOL isOpen = [self.db open];
    
    if (!isOpen) {
        NSLog(@"打开有误");
    }
    [self creatStuListTable];
}


// 创建学生列表(包含3张表)
- (void)creatStuListTable {
    
    [self.db open];
    // 学生列表
    BOOL isSuccess = [self.db executeUpdate:@"create table if not exists StuList(id integer PRIMARY KEY AUTOINCREMENT,user_id text, realname text, avatar_url text, isyjmember text)"];
    NSLog(@"%@", isSuccess ? @"建表成功" : @"建表失败");
    // 班级列表
    [self.db executeUpdate:@"create table if not exists SC(id integer PRIMARY KEY AUTOINCREMENT, cid text, memberlist text, gradeid text, name text, invitecode text, gradename text)"];
    // 群组列表
    [self.db executeUpdate:@"create table if not exists SG(id integer PRIMARY KEY AUTOINCREMENT, gid text , memberlist text, name text)"];
    
    [self.db close];
    
}

// 删除学生表
- (void)deleteStuTable {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 存储路径
    NSString *path = [filePath stringByAppendingPathComponent:@"db.sqlite"];
    
    self.db = [FMDatabase databaseWithPath:path];
    
    [self.db open];
    BOOL isSuccess = [self.db executeUpdate:@"drop table if exists StuList"];
    NSLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");
    [self.db executeUpdate:@"drop table if exists SC"];
    [self.db executeUpdate:@"drop table if exists SG"];
    [self.db close];
    
    // 重新建表
    [self creatStuListTable];
    
}

// 插入学生数据
- (void)insertStudent:(StudentEntity *)student {
    [self.db open];
    BOOL isSuccess = [self.db executeUpdate:@"insert into StuList(user_id, realname, avatar_url, isyjmember) values(?,?,?,?)", student.user_id, student.realname, student.avatar_url, student.isyjmember];
    NSLog(@"%@", isSuccess ? @"插入学生数据成功" : @"插入学生数据失败");
    [self.db close];
}

// 插入班级数据
- (void)insertStuClass:(StuClassEntity *)stuClass {
    [self.db open];
    NSData *memberListData = [NSJSONSerialization dataWithJSONObject:stuClass.memberlist options:NSJSONWritingPrettyPrinted error:nil];
    NSString *memberListString = [[NSString alloc] initWithData:memberListData encoding:NSUTF8StringEncoding];
    
    BOOL isSuccess = [self.db executeUpdate:@"insert into SC(cid, memberlist, gradeid, name, invitecode, gradename) values(?,?,?,?,?,?)", stuClass.cid, memberListString, stuClass.gradeid, stuClass.name, stuClass.invitecode, stuClass.gradename];
    NSLog(@"%@", isSuccess ? @"插入班级数据成功" : @"插入班级数据失败");
    [self.db close];
}

// 插入群组数据
- (void)insertStuGroup:(StuGroupEntity *)stuGroup {
    
    [self.db open];
//    NSData *dataMemberList = [NSKeyedArchiver archivedDataWithRootObject:stuGroup.memberlist];
     NSData *dataMemberList = [NSJSONSerialization dataWithJSONObject:stuGroup.memberlist options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataListString = [[NSString alloc] initWithData:dataMemberList encoding:NSUTF8StringEncoding];
    BOOL isSuccess = [self.db executeUpdate:@"insert into SG(memberlist, gid, name) values(?,?,?)", dataListString, stuGroup.gid, stuGroup.name];
    NSLog(@"%@", isSuccess ? @"插入群组数据成功" : @"插入群组数据失败");
    [self.db close];
}

// 查询所有数据
- (NSMutableArray *)selectAllStudent {
    [self.db open];
    NSMutableArray *group = [NSMutableArray array];
    // 查询所有数据
    FMResultSet *set = [self.db executeQuery:@"select * from StuList"];
    
    while ([set next]) {
        // 获取每行字段中对应的数据
        NSString *sid = [set stringForColumn:@"user_id"];
        NSString *realname = [set stringForColumn:@"realname"];
        NSString *avatar_url = [set stringForColumn:@"avatar_url"];
        NSString *isyjmember = [set stringForColumn:@"isyjmember"];
        
        // 封装到模型对象
        StudentEntity *model = [[StudentEntity alloc] init];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        model.user_id = [numberFormatter numberFromString:sid];
        model.realname = realname;
        model.avatar_url = avatar_url;
        model.isyjmember = [numberFormatter numberFromString:isyjmember];
        
        [group addObject:model];

    }
    [self.db close];
    return group;

}

// 查询所有班级
- (NSMutableArray *)selectAllClass {
    [self.db open];

    NSMutableArray *group = [NSMutableArray array];
    FMResultSet *set = [self.db executeQuery:@"select * from SC"];
    while ([set next]) {
        // 获取数据
        NSString *cid = [set stringForColumn:@"cid"];
        NSString *gradeid = [set stringForColumn:@"gradeid"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *invitecode = [set stringForColumn:@"invitecode"];
        NSString *memberlist = [set stringForColumn:@"memberlist"];
        NSString *gradename = [set stringForColumn:@"gradename"];
        
        // 封装到模型
        StuClassEntity *model = [[StuClassEntity alloc] init];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        model.cid = [numberFormatter numberFromString:cid];
        model.gradeid = [numberFormatter numberFromString:gradeid];
        model.invitecode = [numberFormatter numberFromString:invitecode];
        model.name = name;
        model.gradename = gradename;
        
        NSData *data = [memberlist dataUsingEncoding:NSUTF8StringEncoding];
        model.memberlist = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        [group addObject:model];
        
    }
    [self.db close];

    return group;
}

// 查询所有群组
- (NSMutableArray *)selectAllGroup {
    [self.db open];
    NSMutableArray *group = [NSMutableArray array];
    FMResultSet *set = [self.db executeQuery:@"select * from SG"];
    while ([set next]) {
        // 获取数据
        NSString *gid = [set stringForColumn:@"gid"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *memberlist = [set stringForColumn:@"memberlist"];
        
        // 封装
        StuGroupEntity *model = [[StuGroupEntity alloc] init];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        model.gid = [numberFormatter numberFromString:gid];
        model.name = name;
        
        NSData *data = [memberlist dataUsingEncoding:NSUTF8StringEncoding];
        model.memberlist = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        [group addObject:model];
        
    }
    [self.db close];

    return group;

}

- (StudentEntity *)selectStuById:(NSNumber *)Sid {
    [self.db open];
    // 封装到模型对象
    StudentEntity *model = [[StudentEntity alloc] init];
    // 查询所有数据
    FMResultSet *set = [self.db executeQuery:@"select * from StuList where user_id = ?", Sid];
    
    while ([set next]) {
        // 获取每行字段中对应的数据
        NSString *sid = [set stringForColumn:@"user_id"];
        NSString *realname = [set stringForColumn:@"realname"];
        NSString *avatar_url = [set stringForColumn:@"avatar_url"];
        NSString *isyjmember = [set stringForColumn:@"isyjmember"];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        model.user_id = [numberFormatter numberFromString:sid];
        model.realname = realname;
        model.avatar_url = avatar_url;
        model.isyjmember = [numberFormatter numberFromString:isyjmember];
        
    }
    [self.db close];
    return model;
    
}




// 删除所有数据
- (void)deleteAllStudent {
    
    

}

@end
