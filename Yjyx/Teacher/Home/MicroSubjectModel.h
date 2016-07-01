//
//  MicroSubjectModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroSubjectModel : NSObject
// 内容
@property (copy, nonatomic) NSString *content;
// 题目的类型
@property (assign, nonatomic) NSInteger type;

// 题目id
@property (strong, nonatomic) NSNumber *s_id;
// 题目的难度
@property (copy, nonatomic) NSString *level;

// cell的高度
@property (assign, nonatomic) CGFloat cellHeight;
// RCLabel的rect
@property (assign, nonatomic) CGRect RCLabelFrame;
// 按钮是否展示
@property (assign, nonatomic) BOOL btnIsShow;
// 记录cell的个数
@property (assign, nonatomic) NSInteger index;

+ (instancetype)microSubjectModel:(NSDictionary *)dict andType:(NSInteger)type;
@end
