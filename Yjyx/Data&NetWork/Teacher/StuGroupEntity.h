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
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *name;

- (void)initStuGroupWithDic:(NSDictionary *)dic;

@end
