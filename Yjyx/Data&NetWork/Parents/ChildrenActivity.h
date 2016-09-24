//
//  ChildrenActivity.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildrenActivity : NSObject
@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *finished;
@property(nonatomic,strong) NSString *activityID;
@property(nonatomic,strong) NSString *link;
@property(nonatomic,strong) NSString *tasktype;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *update;
@property(nonatomic,strong) NSString *rid;
@property (strong, nonatomic) NSNumber *spendTime; // 花费时间
@property (strong, nonatomic) NSNumber *task__suggestspendtime; // 建议时间
+(ChildrenActivity *)wrapChildrenActivityWithDic:(NSDictionary *)dic;
@end
