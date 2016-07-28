//
//  VideoNumShowCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "VideoNumShowCell.h"
#import "MicroDetailModel.h"

@interface VideoNumShowCell()

@property (strong, nonatomic) UIButton *preBtn;
@end
@implementation VideoNumShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%@", _model);
}

- (void)setModel:(MicroDetailModel *)model
{
    _model = model;
    for (UIView *view in self.contentView.subviews) {
        if (view != nil) {
            return;
        }
        [view removeFromSuperview];
    }
    NSLog(@"%ld+++++++", model.videoUrlArr.count);
    if (model.videoUrlArr.count == 1) {
        return;
    }
    CGFloat margin = 15;
    CGFloat btnWH = (SCREEN_WIDTH - 6 * margin) / 5;
    for (int i = 0; i < model.videoUrlArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(margin + (margin + btnWH) * i, 40 - btnWH / 2, btnWH, btnWH);
        btn.layer.cornerRadius = btnWH / 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.tag = i;
        if (btn.tag == 0) {
            self.preBtn = btn;
            btn.backgroundColor = [UIColor lightGrayColor];
            btn.layer.borderWidth = 0;
        }
        [btn addTarget:self action:@selector(videoNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}
- (void)videoNumBtnClick:(UIButton *)btn
{
    self.preBtn.backgroundColor = [UIColor whiteColor];
    self.preBtn.layer.borderWidth = 1;
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.borderWidth = 0;
    self.preBtn.selected = NO;
    btn.selected = YES;
    self.preBtn = btn;
    
    if([self.delegate respondsToSelector:@selector(videoNumShowCell:videoNumBtnClick:)]){
        [self.delegate videoNumShowCell:self videoNumBtnClick:btn];
    }
}
@end
