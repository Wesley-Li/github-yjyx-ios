//
//  ChaperContentItem.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChaperContentItem : NSObject
// 题目id
@property (assign, nonatomic) NSInteger t_id;
// 题目内容
@property (strong, nonatomic) NSString *content_text;
// 出题人类型
@property (assign, nonatomic) NSInteger person_type;
// 出题人id
@property (assign, nonatomic) NSInteger p_id;
// 难度
@property (assign, nonatomic) NSInteger level;
// 题目的类型
@property (strong, nonatomic) NSString *subject_type;
// cell的高度
@property (assign, nonatomic) CGFloat cellHeight;
// RClabel的frame
@property (assign, nonatomic) CGRect RCLabelFrame;

@property (nonatomic, assign) BOOL add;// 添加标识


+ (instancetype)chaperContentItemWithArray:(NSArray *)array;


@end
