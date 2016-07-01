//
//  ReleaseMicroCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseMicroCell.h"

@implementation ReleaseMicroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackButtonClicked" object:nil];
}

@end
