//
//  ChildrenActivity.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenActivity.h"

@implementation ChildrenActivity
+(ChildrenActivity *)wrapChildrenActivityWithDic:(NSDictionary *)dic
{
    ChildrenActivity *childrenActivity = [[ChildrenActivity alloc] init];
    childrenActivity.cid = [dic objectForKey:@"cid"];
    childrenActivity.finished = [dic objectForKey:@"finished"];
    childrenActivity.activityID = [dic objectForKey:@"id"];
    childrenActivity.link = [dic objectForKey:@"link"];
    childrenActivity.tasktype = [dic objectForKey:@"tasktype"];
    childrenActivity.title = [dic objectForKey:@"title"];
    childrenActivity.update = [dic objectForKey:@"update"];
    childrenActivity.rid = [dic objectForKey:@"rid"];
    return childrenActivity;
    
}
@end
