//
//  TaskModel.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

- (void)initTaskModelWithDic:(NSDictionary *)dic {

    self.delivertime = dic[@"delivertime"];
    self.t_description = dic[@"description"];
    self.deadlinetime = dic[@"deadlinetime"];
    self.finished = dic[@"finished"];
    self.total = dic[@"total"];
    self.tasktype = dic[@"tasktype"];
    self.t_id = dic[@"id"];
    self.relatedresourceid = dic[@"relatedresourceid"];

}


@end
