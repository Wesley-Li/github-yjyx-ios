//
//  TCustomView.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TCustomView.h"

@implementation TCustomView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        UIView *containerView = [[[UINib nibWithNibName:@"TCustomView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];

    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
