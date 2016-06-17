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
@property (nonatomic, strong) NSNumber *gradeid;// 年级ID
@property (nonatomic, strong) NSNumber *cid;// 班级ID
@property (nonatomic, strong) NSNumber *invitecode;// 邀请码
@property (nonatomic, copy) NSString *name;// 班级名称

@property (assign, nonatomic, readwrite) BOOL isExpanded;

- (void)initStuClassWithDic:(NSDictionary *)dic;

@end
