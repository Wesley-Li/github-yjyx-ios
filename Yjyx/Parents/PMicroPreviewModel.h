//
//  PMicroPreviewModel.h
//  Yjyx
//
//  Created by liushaochang on 16/6/29.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMicroPreviewModel : NSObject

@property (nonatomic, copy) NSString *content;// 题目内容

- (void)initModelWithDic:(NSDictionary *)dic;

@end
