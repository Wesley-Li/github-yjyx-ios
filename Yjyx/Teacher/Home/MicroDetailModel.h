//
//  MicroDetailModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroDetailModel : NSObject

// 创建时间
@property (copy, nonatomic) NSString *create_time;
// 题目名称
@property (copy, nonatomic) NSString *name;
// 知识点描述
@property (copy, nonatomic) NSString *knowledgedesc;
// 视频地址数组
@property (strong, nonatomic) NSMutableArray *videoUrlArr;
// 微课id
@property (strong, nonatomic) NSNumber *w_id;
// 题目列表
@property (strong, nonatomic) NSArray *questionList;
// 编辑按钮是否是选中状态
@property (assign, nonatomic) BOOL isSelected;

// 全部需要解题步骤
@property (assign, nonatomic) BOOL isShouldProcess;
+ (instancetype)microDetailModelWithDict:(NSDictionary *)dict;
@end
