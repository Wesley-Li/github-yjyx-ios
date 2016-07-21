//
//  VoiceListCell.m
//  Yjyx
//
//  Created by liushaochang on 16/7/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "VoiceListCell.h"

@implementation VoiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.voiceView.layer.cornerRadius = 6;
    self.voiceView.layer.masksToBounds = YES;
    
    // 播放音频动画
    self.animationImage.animationImages = @[[UIImage imageNamed:@"voice-2"],[UIImage imageNamed:@"voice-3"],[UIImage imageNamed:@"voice-1"],[UIImage imageNamed:@"voice-4"]];
    [self.animationImage setAnimationRepeatCount:0];
    [self.animationImage setAnimationDuration:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
