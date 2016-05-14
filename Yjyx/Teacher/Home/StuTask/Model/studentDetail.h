//
//  studentDetail.h
//  Yjyx
//
//  Created by wangdapeng on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface studentDetail : NSObject

@property (nonatomic, strong) NSString * submittime; //作业提交时间
@property (nonatomic,strong ) NSString * SpendTime;  // 作业用时
@property (nonatomic,strong)  NSString * subjectId; // 科目
@property (nonatomic,strong)  NSArray  *  ChoiceArry;// 选择题结果信息
@property (nonatomic,strong) NSNumber * studentId;// 学生ID
@property (nonatomic,strong) NSArray * answerList;// 学生答案列表
@property (nonatomic,strong)  NSNumber * rightOrFalse;//对错
@property (nonatomic, strong) NSNumber * answerSpenTime;//此题用时



- (void)initstudentDetailModelWithDic: (NSArray *)Arr;

@end
