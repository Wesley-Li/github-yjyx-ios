//
//  GetTaskModel.h
//  Yjyx
//
//  Created by liushaochang on 16/7/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTaskModel : NSObject

@property (nonatomic, copy) NSString *delivertime;
@property (nonatomic, copy) NSString *finishtime;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, strong) NSNumber *taskid;
@property (nonatomic, strong) NSNumber *taskType;


- (void) initModelWithDic:(NSDictionary *)dic;

@end
