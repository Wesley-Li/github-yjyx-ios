//
//  ChildrenEntity.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildrenEntity : NSObject
@property (strong, nonatomic) NSString *childavatar;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *relation;
@property (strong, nonatomic) NSString *isOpen;

+(ChildrenEntity *)wrapChildrenWithDic:(NSDictionary *)dic;
@end
