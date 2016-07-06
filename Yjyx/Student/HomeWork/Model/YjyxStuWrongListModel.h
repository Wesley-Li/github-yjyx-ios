//
//  YjyxStuWrongListModel.h
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxStuWrongListModel : NSObject

@property (nonatomic, strong) NSArray *stuAnswer;
@property (nonatomic, strong) NSString *correctAnswer;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *q_id;
@property (nonatomic, strong) NSNumber *q_type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *showView;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *explanation;


- (void)initModelWithDic:(NSDictionary *)dic;


@end
