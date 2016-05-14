//
//  FinshedModel.m
//  Yjyx
//
//  Created by wangdapeng on 16/5/10.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "FinshedModel.h"


@implementation FinshedModel

- (void)initFinshedModelWithDic:(NSDictionary *)dic {
    self.Name = dic[@"name"];
    self.studentID = dic  [@"suid"];
    self.finishedResult = dic[@"finished"];
    self.resourcesRid = dic[@"rid"];
    self.TasktrackID = dic[@"id"];
    self.ImageAvatar = dic[@"avatar"];
    self.workType = dic[@"tasktype"];
    
}
@end
