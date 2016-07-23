//
//  YjyxStuAnswerModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuAnswerModel.h"

@implementation YjyxStuAnswerModel

+ (instancetype)stuAnswerModelWithArr:(NSArray *)arr
{
    YjyxStuAnswerModel *model = [[self alloc] init];
    model.t_id = [arr[0] stringValue];
    model.stuAnswerArr = arr[1];
    model.isRight = arr[2];
    model.s_time = arr[3];
    if (arr.count == 5) {
        model.writeprocess = arr[4];
        if ([[arr[4] objectForKey:@"writeprocess"] count] == 0 ) {
            
            model.anonatationShow = NO;
        }else {
            NSArray *array = [arr[4] objectForKey:@"writeprocess"];
            for (int i = 0; i < array.count; i++) {
                if ([array[i][@"img"] length] != 0) {
                    model.anonatationShow = YES;
                    break;
                }else {
                    
                    model.anonatationShow = NO;
                }
                
            }
            
        }

    }
    return model;
}
@end
