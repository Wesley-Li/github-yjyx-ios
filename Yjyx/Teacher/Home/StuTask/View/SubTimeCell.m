//
//  SubTimeCell.m
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SubTimeCell.h"

@implementation SubTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithDic:(NSDictionary *)dic {

    NSArray *arr = [dic[@"submittime"] componentsSeparatedByString:@"T"];
    NSArray *arr2 = [arr[1] componentsSeparatedByString:@":"];
    NSString *timeString = [NSString stringWithFormat:@"%@日%@:%@", arr[0], arr2[0], arr2[1]];
    self.subTimeLabel.text = timeString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
