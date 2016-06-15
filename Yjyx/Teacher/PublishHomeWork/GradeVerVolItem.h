//
//  GradeVerVolItem.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeVerVolItem : NSObject
// 年级号
@property (assign, nonatomic) NSInteger gradeid;
// 上下册
@property (assign, nonatomic) NSInteger volid;
// 版本号
@property (assign, nonatomic) NSInteger verid;

+ (instancetype)gradeVerVolItemWithGrade:(NSInteger)gradeid andVolid:(NSInteger)volid andVerid:(NSInteger)verid;
@end