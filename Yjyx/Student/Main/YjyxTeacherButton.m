//
//  YjyxTeacherButton.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxTeacherButton.h"

@implementation YjyxTeacherButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.width = self.imageView.height;
    self.titleLabel.x = CGRectGetMaxX(self.imageView.frame) + 5;
}

@end
