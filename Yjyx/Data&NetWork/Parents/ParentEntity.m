//
//  ParentEntity.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentEntity.h"

@implementation ParentEntity

+(ParentEntity*)wrapParentWithdic:(NSDictionary *)dic
{
    ParentEntity *parentEntity = [[ParentEntity alloc] init];
    parentEntity.name = [[dic objectForKey:@"name"] isEmpty]?@"":[dic objectForKey:@"name"];
    parentEntity.pid = [dic objectForKey:@"pid"];
    parentEntity.avatar = ([[dic objectForKey:@"avatar"] isKindOfClass:[NSNull class]]||[[dic objectForKey:@"avatar"] isEmpty])?@"":[dic objectForKey:@"avatar"];
    parentEntity.childrens = [[NSMutableArray alloc] init];
    for (int i =0; i<[[dic objectForKey:@"children"] count]; i++) {
        ChildrenEntity *childrenEntity = [ChildrenEntity wrapChildrenWithDic:[[dic objectForKey:@"children"] objectAtIndex:i]];
        [parentEntity.childrens addObject:childrenEntity];
    }
    parentEntity.notify_sound = [[dic objectForKey:@"notify_setting"] objectForKey:@"notify_sound"];
    parentEntity.receive_notify = [[dic objectForKey:@"notify_setting"] objectForKey:@"receive_notify"];
    parentEntity.notify_with_sound = [[dic objectForKey:@"notify_setting"] objectForKey:@"notify_with_sound"];
    
    return parentEntity;
}

@end
