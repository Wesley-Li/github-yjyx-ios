//
//  ChildrenResultModel.m
//  Yjyx
//
//  Created by liushaochang on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenResultModel.h"

@implementation ChildrenResultModel

- (void)initModelWithDic:(NSDictionary *)dic {

    self.showview = dic[@"showview"];
    self.videourl = dic[@"videourl"];
    self.explanation = dic[@"explanation"];
    self.content = dic[@"content"];
    self.answer = dic[@"answer"];
    self.q_id = dic[@"id"];
    
    if ([self.questionType isEqualToString:@"choice"]) {
        self.answerCount = dic[@"choicecount"];
    }else {
    
        self.answerCount = dic[@"blankcount"];
    }
    
}

@end
