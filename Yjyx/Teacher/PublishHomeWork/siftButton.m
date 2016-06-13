//
//  siftButton.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "siftButton.h"

@implementation siftButton

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.layer.borderWidth = 1;
    [self setBackgroundImage:[UIImage imageNamed:@"list_btn_confirm_focus"] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  
    self.layer.borderColor = [UIColor grayColor].CGColor;
  
    
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
