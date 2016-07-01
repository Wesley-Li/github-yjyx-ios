//
//  MyMicroModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MyMicroModel.h"

@implementation MyMicroModel

+ (instancetype)myMicroModelWithArr:(NSArray *)arr
{
    MyMicroModel *model = [[self alloc] init];
    model.m_id = arr[0];
    model.name = arr[1];
    model.descrip = arr[2];
    model.p_type = [arr[3] integerValue];
    return model;
}
@end
