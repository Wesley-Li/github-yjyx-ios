//
//  StuDataBase.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StudentEntity;
@class StuClassEntity;
@class StuGroupEntity;
@interface StuDataBase : NSObject

+ (StuDataBase *)shareStuDataBase;



// 添加数据
- (void)insertStudent:(StudentEntity *)student;
- (void)insertStuClass:(StuClassEntity *)stuClass;
- (void)insertStuGroup:(StuGroupEntity *)stuGroup;

// 查询所有数据
// 查询所有学生
- (NSMutableArray *)selectAllStudent;
// 查询所有班级
- (NSMutableArray *)selectAllClass;
// 查询所有群组
- (NSMutableArray *)selectAllGroup;
// 根据id查询学生
- (StudentEntity *)selectStuById:(NSString *)Sid;


// 创建数据库
- (void)creatStuDataBase;

// 删除所有数据
- (void)deleteAllStudent;

// 删除表
- (void)deleteStuTable;

@end
