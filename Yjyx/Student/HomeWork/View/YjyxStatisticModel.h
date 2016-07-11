//
//  YjyxStatisticModel.h
//  Yjyx
//
//  Created by liushaochang on 16/7/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxStatisticModel : NSObject


@property (nonatomic, strong) NSString *name;// 学科名称
@property (nonatomic, strong) NSNumber *questiontotal;// 总共做的题目数
@property (nonatomic, strong) NSNumber *tasks_num;// 完成任务数
@property (nonatomic, strong) NSNumber *questioncorrect;// 做对题目数
@property (nonatomic, strong) NSNumber *subjectid;// 科目ID
@property (nonatomic, strong) NSNumber *recv_num;// 总的收到的任务数
@property (nonatomic, strong) NSNumber *questionwrong;// 做错题目数
@property (nonatomic, strong) NSString *yj_member;// 会员图标
@property (nonatomic, strong) NSString *icon;// 学科图片



- (void)initModelWithDic:(NSDictionary *)dic;






@end
