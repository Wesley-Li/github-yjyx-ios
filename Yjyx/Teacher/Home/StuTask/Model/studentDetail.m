//
//  studentDetail.m
//  Yjyx
//
//  Created by wangdapeng on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "studentDetail.h"

@implementation studentDetail

- (void)initstudentDetailModelWithDic:(NSArray*)Arr{
    
    self.studentId = Arr [0];
    self.answerList = Arr [1];
    self.rightOrFalse = Arr [2];
    self.answerSpenTime = Arr [3];
    
        
    
    
    
}
@end
