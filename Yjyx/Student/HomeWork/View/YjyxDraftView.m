//
//  YjyxDraftView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/11.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDraftView.h"
#import "YjyxDrawView.h"
@interface YjyxDraftView()

@property (weak, nonatomic) IBOutlet YjyxDrawView *drawView;

@end
@implementation YjyxDraftView

+ (instancetype)draftView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (IBAction)leaveBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)revokeBtnClick:(UIButton *)sender {
    [self.drawView revoke];
}
- (IBAction)goBtnClick:(UIButton *)sender {
    [self.drawView goForward];
}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    [self.drawView clear];
}

@end
