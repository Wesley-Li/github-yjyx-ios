//
//  GetTaskModel.m
//  Yjyx
//
//  Created by liushaochang on 16/7/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "GetTaskModel.h"

@implementation GetTaskModel

- (void) initModelWithDic:(NSDictionary *)dic {

    NSArray *arr1 = [dic[@"delivertime"] componentsSeparatedByString:@"T"];
    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@":"];
    self.delivertime = [NSString stringWithFormat:@"%@ %@:%@", arr1[0], arr2[0], arr2[1]];
    
    if (![dic[@"finishtime"] isEqual:[NSNull null]]) {
        NSArray *arr3 = [dic[@"finishtime"] componentsSeparatedByString:@"T"];
        NSArray *arr4 = [arr3[1] componentsSeparatedByString:@":"];
        NSString *monthDay = [arr3[0] substringFromIndex:5];
        self.finishtime = [NSString stringWithFormat:@"%@ %@:%@", monthDay, arr4[0], arr4[1]];
    }
    
    if (![dic[@"description"] isEqual:[NSNull null]]) {
        self.descriptionText = dic[@"description"];

    }
    
    
    self.taskType = dic[@"tasktype"];
    self.taskid = dic[@"taskid"];
    
    self.tasktrackid = dic[@"tasktrackid"];
    
}

@end
