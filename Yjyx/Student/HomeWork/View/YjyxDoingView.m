//
//  YjyxDoingView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDoingView.h"

@interface YjyxDoingView()

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@end
@implementation YjyxDoingView

- (void)awakeFromNib
{
    self.oneBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.oneBtn.layer.borderWidth = 1;
    self.twoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.twoBtn.layer.borderWidth = 1;
    self.threeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.threeBtn.layer.borderWidth = 1;
    self.fourBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.fourBtn.layer.borderWidth = 1;
 
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
}
+ (instancetype)doingView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (IBAction)answerBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = STUDENTCOLOR;
    }else{
        sender.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        UITextField *blankAnswer = [[UITextField alloc] init];
//        blankAnswer1.borderStyle = UITextBorderStyleLine;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 2)];
        blankAnswer.leftView = view;
        blankAnswer.leftViewMode = UITextFieldViewModeAlways;
        blankAnswer.backgroundColor = [UIColor whiteColor];
        blankAnswer.placeholder = [NSString stringWithFormat:@"  %d:请填写答案", i + 1];
        blankAnswer.frame = CGRectMake(0, 40 * i , SCREEN_WIDTH - 70, 40 -1);
        [self.scrollView addSubview:blankAnswer];
    }
}
- (IBAction)nextWorkBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doingView:nextWorkBtnIsClick:)]) {
        [self.delegate doingView:self nextWorkBtnIsClick:sender];
    }
}

@end
