//
//  YjyxThreeStageSubjectCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxThreeStageSubjectCell.h"
#import "YjyxThreeStageModel.h"
@interface YjyxThreeStageSubjectCell()

@property (weak, nonatomic) IBOutlet UIView *bgViiew;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *answerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end
@implementation YjyxThreeStageSubjectCell
static CGFloat btnWH = 44;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgViiew.layer.cornerRadius = 5;
    self.bgViiew.layer.borderWidth = 1;
    self.bgViiew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [self setupAnswerView];
}
- (void)setupAnswerView
{
    NSArray *choiceAnswer = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
    
    for (UIView *view in self.answerView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *answerArr = [_model.stuAnswer componentsSeparatedByString:@"|"];
    CGFloat margin = ((SCREEN_WIDTH - 24) - 6 * btnWH) / 7;
    NSInteger choiceTotalNum = [_model.choicecount integerValue];
    CGFloat beginX = (5 - (choiceTotalNum - 1) % 6) * (margin + btnWH);
    for (int i = 0; i < choiceTotalNum; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:choiceAnswer[i] forState:UIControlStateNormal];
        btn.width = btnWH;
        btn.height = btnWH;
        if(choiceTotalNum <= 6){
            btn.x = margin + beginX + i * (margin + btnWH);
            btn.centerY = 30;
        }else{
            btn.x = margin + beginX * (i / 6) + (i % 6) * (margin + btnWH);
            btn.centerY = i / 6  * (30 + 30) + 30;
        }
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
        btn.tag = 200 + i;
        if([answerArr containsObject:[NSString stringWithFormat:@"%ld", btn.tag - 200]]){
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        if (btn.selected == NO) {
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = btnWH / 2;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        }else{
            btn.backgroundColor = STUDENTCOLOR;
            btn.layer.cornerRadius = btnWH / 2;
        }
        
        [btn addTarget:self action:@selector(answerBtnNumClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:btn];
    }
    
}
- (void)answerBtnNumClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == NO) {
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = btnWH / 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }else{
        btn.backgroundColor = STUDENTCOLOR;
        btn.layer.cornerRadius = btnWH / 2;
        btn.layer.borderWidth = 0;
    }
    if ([self.delegate respondsToSelector:@selector(threeStageSubjectCell:doingSubjectBtnClick:)]) {
        [self.delegate threeStageSubjectCell:self doingSubjectBtnClick:btn];
    }
}
- (void)setModel:(YjyxThreeStageModel *)model
{
    _model = model;
    [self setupAnswerView];
    if ([model.choicecount integerValue] > 6) {
        self.bottomConstraint.constant = 120;
    }else{
        self.bottomConstraint.constant = 60;
    }
    
}

@end
