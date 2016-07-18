//
//  ChaperContentItem.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChaperContentItem.h"


@implementation ChaperContentItem

+ (instancetype)chaperContentItemWithArray:(NSArray *)arr
{
    ChaperContentItem *item = [[self alloc] init];
    item.t_id = [arr[0] integerValue];
    item.content_text = arr[2];
    item.person_type = [arr[3] integerValue];
    item.p_id = [arr[4] integerValue];
    if ([arr[5] isEqual:[NSNull null]]) {
        item.level = -1;
        return nil;
    }else{
    item.level = [arr[5] integerValue];
    }
    if ([arr[6] isEqualToString:@"choice"]) {
        item.subject_type = @"1";
    }else{
        item.subject_type = @"2";
    }
    
    
    item.add = NO;
    
    return item;
}

@end
