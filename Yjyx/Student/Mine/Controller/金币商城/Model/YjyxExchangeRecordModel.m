//
//  YjyxExchangeRecordModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxExchangeRecordModel.h"

@implementation YjyxExchangeRecordModel

+ (instancetype)exchangeRecordModelWithDict:(NSDictionary *)dict
{
    YjyxExchangeRecordModel *model = [[self alloc] init];
    model.exec_datetime = dict[@"exec_datetime"];
    model.goods_type_name = dict[@"goods_type__name"];
    model.specific_info = dict[@"specific_info"];
    model.exchange_coins = dict[@"exchange_coins"];
    model.p_id = dict[@"id"];
    return model;
}

- (NSString *)exec_datetime
{
    NSArray *arr = [_exec_datetime componentsSeparatedByString:@"."];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *date = [fmt dateFromString:arr[0]];
    fmt.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
    return [fmt stringFromDate:date];
}
- (CGFloat)cellHeight
{
    if(_cellHeight != 0){
        return _cellHeight;
    }
    CGFloat cellHeight = 0;
    cellHeight += 88;
    NSLog(@"%@", self.specific_info);
    if(![self.specific_info isEqual:[NSNull null]]){
        CGRect rect = [self.specific_info boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
        cellHeight += rect.size.height;
    }
   
    cellHeight +=  8;
    return cellHeight;
}
@end
