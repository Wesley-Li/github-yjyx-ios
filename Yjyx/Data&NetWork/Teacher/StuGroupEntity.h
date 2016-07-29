//
//  StuGroupEntity.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuGroupEntity : NSObject

@property (nonatomic, strong) NSArray *memberlist;
@property (nonatomic, strong) NSNumber *gid;
@property (nonatomic, copy) NSString *name;

@property (assign, nonatomic) BOOL isExpanded;
@property (assign, nonatomic, readwrite) BOOL isSelect;
- (void)initStuGroupWithDic:(NSDictionary *)dic;

@end
