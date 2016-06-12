//
//  GradeContentItem.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeContentItem : NSObject
/*
 * 章节目录
 */
@property (copy, nonatomic) NSString *g_id;
/*
 * 父章节
 */
@property (copy, nonatomic) NSString *parent;
/*
 * 章节内容
 */
@property (copy, nonatomic) NSString *text;

+ (instancetype )gradeContentItem:(NSDictionary *)dict;
@end
