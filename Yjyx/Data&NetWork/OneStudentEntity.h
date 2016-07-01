//
//  OneStudentEntity.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/30.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneStudentEntity : NSObject
@property (strong, nonatomic) NSNumber *classid; // 所在班级id
@property (strong, nonatomic) NSString *classname; // 班级名称
@property (strong, nonatomic) NSString *phonenumber; // 电话号码
@property (strong, nonatomic) NSString *schoolprovincename; // 学校所在省份
@property (strong, nonatomic) NSString *invitecode; // 家长邀请码
@property (strong, nonatomic) NSNumber *coins; // 亿教币
@property (strong, nonatomic) NSString *email; // 邮箱
@property (strong, nonatomic) NSString *username; // 帐户名
@property (strong, nonatomic) NSArray *teacherlist; // 老师列表
@property (strong, nonatomic) NSString *realname; // 真实姓名
@property (strong, nonatomic) NSString *schoolcityname; // 学校所在城市名
@property (strong, nonatomic) NSNumber *gradeid; // 年级id
@property (strong, nonatomic) NSString *schooldistictname;
@property (strong, nonatomic) NSNumber *schooltypeid;
@property (strong, nonatomic) NSString *sessionid; // 用来后续请求
@property (strong, nonatomic) NSString *schooltypename;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSNumber *schoolid;
@property (strong, nonatomic) NSString *gradename; // 年级名称
@property (strong, nonatomic) NSString *schoolname; // 学校名称
@property (strong, nonatomic) NSString *avatar_url; // 小孩头像
@property (strong, nonatomic) NSDictionary *notify_setting; // 消息推送设置

+ (instancetype)studentEntityWithDict:(NSDictionary *)dict;
@end
