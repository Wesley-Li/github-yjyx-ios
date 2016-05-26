//
//  TaskConditonModel.h
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskConditonModel : NSObject


@property (nonatomic, strong) NSNumber *t_id;// 题目id
@property (nonatomic, strong) NSArray *answerArr;// 答案数组
@property (nonatomic, assign) NSNumber *rightOrWrong;// 对错
@property (nonatomic, strong) NSNumber *time;// 用时


- (void)initModelWithArray:(NSArray *)arr;

@end
