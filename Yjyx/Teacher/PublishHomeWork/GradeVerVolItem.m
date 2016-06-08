//
//  GradeVerVolItem.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "GradeVerVolItem.h"

@implementation GradeVerVolItem

+ (instancetype)gradeVerVolItemWithGrade:(NSInteger)gradeid andVolid:(NSInteger)volid anfVerid:(NSInteger)verid
{
    GradeVerVolItem *item = [[self alloc] init];
    item.gradeid = gradeid;
    item.verid = verid;
    item.volid = volid;
    return item;
}
@end
