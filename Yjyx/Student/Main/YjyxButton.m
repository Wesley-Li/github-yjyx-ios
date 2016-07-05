//
//  YjyxButton.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxButton.h"

@implementation YjyxButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.width = self.width;
    self.imageView.height  = self.height - 15;
    self.titleLabel.width = self.width;
    self.titleLabel.height = 15;
    self.titleLabel.x = 0;
    self.titleLabel.y =  self.imageView.height;
}

@end
