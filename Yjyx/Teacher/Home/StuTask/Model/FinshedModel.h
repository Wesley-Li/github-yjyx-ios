//
//  FinshedModel.h
//  Yjyx
//
//  Created by wangdapeng on 16/5/10.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinshedModel : NSObject

@property (nonatomic, strong) NSString * Name; //学生名字
@property (nonatomic, strong) NSNumber * studentID; //对应学生的ID号
@property (nonatomic, strong) NSNumber * finishedResult; //是否完成
@property (nonatomic, strong) NSNumber * resourcesRid;//相关资源
@property (nonatomic, strong) NSNumber * TasktrackID;//后台tasktrack的id号
@property (nonatomic, strong) NSString * ImageAvatar;//学生的头像地址	 
@property (nonatomic, strong) NSNumber * workType;//作业类型

- (void)initFinshedModelWithDic:(NSDictionary *)dic;

@end
