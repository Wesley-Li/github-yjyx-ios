//
//  ReleaseVideoCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseVideoCell.h"
#import "OneSubjectModel.h"
@implementation ReleaseVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(OneSubjectModel *)model
{
    _model = model;
    if ([model.videourl isEqualToString:@""]) {
        self.videoLabel.hidden = YES;
    }else{
        self.videoLabel.hidden = NO;
    }
}

@end
