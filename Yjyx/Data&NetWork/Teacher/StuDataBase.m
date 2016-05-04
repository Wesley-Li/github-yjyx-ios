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
    
    // 创建学生列表
    [self creatStuListTable];
    

    
}


// 创建学生列表(包含3张表)
- (void)creatStuListTable {
    // 学生列表
    BOOL isSuccess = [self.db executeUpdate:@"create table StuList(user_id text primary key, realname text, avatar_url text)"];
    NSLog(@"%@", isSuccess ? @"建表成功" : @"建表失败");
    // 班级列表
    [self.db executeUpdate:@"create table SC(memberlist blob, gradeid text, cid text primary key, name text)"];
    // 群组列表
    [self.db executeUpdate:@"create table SG(memberlist blob, gid text primary key, name text)"];
    
}

// 删除学生表
- (void)deleteStuTable {
    
    BOOL isSuccess = [self.db executeUpdate:@"drop table if exists StuList"];
    NSLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");
    [self.db executeUpdate:@"drop table if exists SC"];
    [self.db executeUpdate:@"drop table if exists SG"];
}

// 插入学生数据
- (void)insertStudent:(StudentEntity *)student {

    BOOL isSuccess = [self.db executeUpdate:@"insert into StuList(user_id, realname, avatar_url) values(?,?,?)", student.user_id, student.realname, student.avatar_url];
    NSLog(@"%@", isSuccess ? @"插入数据成功" : @"插入数据失败");
}

// 插入班级数据
- (void)insertStuClass:(StuClassEntity *)stuClass {
    NSData *memberListData = [NSKeyedArchiver archivedDataWithRootObject:stuClass.memberlist];
    [self.db executeUpdate:@"insert into SC(memberlist, gradeid, cid, name) values(?,?,?,?)", memberListData, stuClass.gradeid, stuClass.cid, stuClass.name];
}

// 插入群组数据
- (void)insertStuGroup:(StuGroupEntity *)stuGroup {

    NSData *dataMemberList = [NSKeyedArchiver archivedDataWithRootObject:stuGroup.memberlist];
    [self.db executeUpdate:@"insert into SG(memberlist, gid, name) values(?,?,?)", dataMemberList, stuGroup.gid, stuGroup.name];
}

// 查询所有数据
//- (NSArray *)selectAllStudent {
//    
//    
//
//}
- (NSArray *)selectStuById:(NSString *)Sid {

    NSMutableArray *group = [NSMutableArray array];
    // 查询所有数据
    FMResultSet *set = [self.db executeQuery:@"select * from StuList where id = ?", Sid];
    
    while ([set next]) {
        // 获取每行字段中对应的数据
        NSString *sid = [set stringForColumn:@"user_id"];
        NSString *realname = [set stringForColumn:@"realname"];
        NSString *avatar_url = [set stringForColumn:@"avatar_url"];
        
        // 封装到模型对象
        StudentEntity *model = [[StudentEntity alloc] init];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        model.user_id = [numberFormatter numberFromString:sid];
        model.realname = realname;
        model.avatar_url = avatar_url;
        
        [group addObject:model];
        
    }
    return group;
}




// 删除所有数据
- (void)deleteAllStudent {
    
    

}

@end
