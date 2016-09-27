//
//  YjyxOverallData.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentEntity.h"
#import "ChildrenEntity.h"
#import "TeacherEntity.h"
#import "OneStudentEntity.h"

typedef enum PUSH_TYPE{
    PUSHTYPE_PREVIEWHOME = 1,
    PUSHTYPE_PREVIEMICRO = 2,
    PUSHTYPE_RESULTHOMEWORK = 3,
    PUSHTYPE_RESULTMICRO = 4,
    PUSHTYPE_NONE = 5,
}PUSH_TYPE;


@interface YjyxOverallData : NSObject
@property(strong, nonatomic) NSString *baseUrl;
@property(strong, nonatomic) ParentEntity *parentInfo;
@property(strong, nonatomic) TeacherEntity *teacherInfo;
@property(strong, nonatomic) OneStudentEntity *studentInfo;

@property(assign, nonatomic) PUSH_TYPE pushType;
// 家长端
@property(strong, nonatomic) NSString *historyId;
@property(strong, nonatomic) NSString *previewRid;

// 学生端
@property(strong, nonatomic) NSNumber *taskid;
@property(strong, nonatomic) NSNumber *examid;

//获取实例
+ (instancetype)sharedInstance;

//通过小孩cid获取对象
- (ChildrenEntity *)getChildrenWithCid:(NSString *)cid;

@end
