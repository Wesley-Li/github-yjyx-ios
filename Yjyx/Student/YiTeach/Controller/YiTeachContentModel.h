//
//  YiTeachContentModel.h
//  Yjyx
//
//  Created by liushaochang on 16/8/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YiTeachContentModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *content;

- (void)initModelWithArray:(NSArray *)array;

@end
