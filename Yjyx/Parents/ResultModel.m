//
//  ResultModel.m
//  Yjyx
//
//  Created by liushaochang on 16/6/28.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel

- (void)initModelWithArray:(NSArray *)array {

    self.q_id = array[0];
    self.myAnswer = array[1];
    self.rightOrWrong = array[2];
    self.time = array[3];
}


@end
