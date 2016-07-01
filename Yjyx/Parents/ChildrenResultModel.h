//
//  ChildrenResultModel.h
//  Yjyx
//
//  Created by liushaochang on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildrenResultModel : NSObject

// 主要是题目内容的数据

@property (nonatomic, copy) NSString *questionType;// 类型
@property (nonatomic, strong) NSNumber *showview;// 判断"解题方法"按钮是否显示
@property (nonatomic, strong) NSString *videourl;// 视频播放地址
@property (nonatomic, strong) NSString *explanation;// 解析
@property (nonatomic, strong) NSString *content;// 题目内容
@property (nonatomic, strong) NSString *answer;//答案
@property (nonatomic, strong) NSNumber *answerCount;// 答案个数或者选项个数
@property (nonatomic, strong) NSNumber *q_id;// 本题id
@property (nonatomic, assign) CGFloat height;// cell高度



- (void)initModelWithDic:(NSDictionary *)dic;


@end
