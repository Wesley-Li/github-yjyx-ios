//
//  SpendTimeCell.m
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SpendTimeCell.h"

@interface SpendTimeCell()
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@end
@implementation SpendTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFinishTime:(NSInteger)finishTime
{
    _finishTime = finishTime;
    self.timeTitleLabel.text = @"建议完成时间";
   
    self.spendTimeLabel.text = [NSString stringWithFormat:@"%ld分钟", finishTime];
}
- (void)setValueWithDic:(NSDictionary *)dic {
    
    self.timeTitleLabel.text = @"用时";
    
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
