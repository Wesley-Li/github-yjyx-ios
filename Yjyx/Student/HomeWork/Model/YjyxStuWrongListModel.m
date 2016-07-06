//
//  YjyxStuWrongListModel.m
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuWrongListModel.h"

@implementation YjyxStuWrongListModel

- (void)initModelWithDic:(NSDictionary *)dic {
    // 学生答案
    if ([[dic allKeys] containsObject:@"a"]) {
        self.stuAnswer = dic[@"a"];
    }
    
    // 正确答案
    self.correctAnswer = dic[@"answer"];
    
    // 题目难度等级
    self.level = dic[@"level"];
    
    // 题目类型
    self.q_type = dic[@"t"];
    
    // 题目id
    self.q_id = dic[@"i"];
    
    // 题目内容
    self.content = dic[@"content"];
    
    // 是否显示解题方法按钮
    self.showView = dic[@"showview"];
    
    // 视频地址,文字解析
    if ([[dic allKeys] containsObject:@"videourl"]) {
        self.videoUrl = dic[@"videourl"];
    }
    
    if ([[dic allKeys] containsObject:@"explanation"]) {
        self.explanation = dic[@"explanation"];
    }
    
    
    
    
    
}


@end
