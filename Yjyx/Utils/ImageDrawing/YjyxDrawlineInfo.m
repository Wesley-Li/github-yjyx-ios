//
//  YjyxDrawlineInfo.m
//  Yjyx
//
//  Created by liushaochang on 16/7/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDrawlineInfo.h"

@implementation YjyxDrawlineInfo

- (instancetype)init {
    if (self=[super init]) {
        self.linePoints = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

@end
