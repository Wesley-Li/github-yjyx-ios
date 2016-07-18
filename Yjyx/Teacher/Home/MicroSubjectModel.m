//
//  MicroSubjectModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroSubjectModel.h"

@implementation MicroSubjectModel

+ (instancetype)microSubjectModel:(NSDictionary *)dict andType:(NSInteger)type
{
    MicroSubjectModel *model = [[self alloc] init];
    model.content = dict[@"content"];
    model.s_id = dict[@"id"];
    NSLog(@"%@", dict[@"level"]);
    if ([dict[@"level"] isEqual:@1]) {
        model.level = @"简单";
    }else if ([dict[@"level"] isEqual:@2]){
        model.level = @"中等";
    }else{
        model.level = @"较难";
    }
    
    model.type = type;
    
    return model;
}


@end
