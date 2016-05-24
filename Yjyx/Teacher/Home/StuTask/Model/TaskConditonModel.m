//
//  TaskConditonModel.m
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskConditonModel.h"

@implementation TaskConditonModel


- (void)initModelWithArray:(NSArray *)arr {

    self.t_id = arr[0];
    self.answerArr = arr[1];
    self.rightOrWrong = arr[2];
    self.time = arr[3];
    
}


@end
