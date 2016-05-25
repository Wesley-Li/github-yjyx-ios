//
//  SpendTimeCell.m
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SpendTimeCell.h"

@implementation SpendTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setValueWithDic:(NSDictionary *)dic {
    
    NSNumber *seconds = [dic[@"result"] objectForKey:@"spendTime"];
    NSInteger second = [seconds integerValue];
    
    NSInteger sec = second % 60;
    NSInteger min = (second / 60) % 60;
    NSInteger hours = second / 3600;

    self.spendTimeLabel.text = [NSString stringWithFormat:@"%ld小时:%ld分:%ld秒", hours, min, sec];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
