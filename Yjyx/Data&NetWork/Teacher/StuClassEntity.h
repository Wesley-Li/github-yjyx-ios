//
//  StuClassEntity.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuClassEntity : NSObject

@property (nonatomic, strong) NSArray *memberlist;// 学生ID
@property (nonatomic, copy) NSString *gradeid;// 年级ID
@property (nonatomic, copy) NSString *cid;// 班级ID
@property (nonatomic, copy) NSString *name;// 班级名称

- (void)initStuClassWithDic:(NSDictionary *)dic;

@end
