//
//  YiTeachContentModel.m
//  Yjyx
//
//  Created by liushaochang on 16/8/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YiTeachContentModel.h"

@implementation YiTeachContentModel

- (void)initModelWithArray:(NSArray *)array {

    self.ID = array[0];
    self.content = array[1];
}


@end
