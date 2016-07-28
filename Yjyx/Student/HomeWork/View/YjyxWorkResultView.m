//
//  YjyxWorkResultView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkResultView.h"
#import "YjyxDoingWorkModel.h"
#import "Masonry.h"

@interface YjyxWorkResultView()
@property (weak, nonatomic) UIButton *submitBtn;

@property (weak, nonatomic) UIView *bgView;
@end
@implementation YjyxWorkResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
      
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitBtn = submitBtn;
        [submitBtn setTitle:@"提交作业" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.height = 45;
        submitBtn.width = SCREEN_WIDTH - 20;
        submitBtn.layer.cornerRadius = 5;
        submitBtn.centerX = SCREEN_WIDTH / 2;
        submitBtn.backgroundColor = STUDENTCOLOR;
        submitBtn.y =  65;
        [bgView addSubview:submitBtn];
        
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(64);
            make.right.equalTo(self).with.offset(0);
            make.bottom.equalTo(self.submitBtn).with.offset(50);
        }];
        
     
    }
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    return self;
}
- (void)setWorkType:(NSMutableArray *)workType andArr:(NSMutableArray *)arr
{
    CGFloat margin = (SCREEN_WIDTH - 45 * 6) / 7;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((margin + 45) * (i % 6) + margin, margin + (margin + 45) * (i / 6), 45, 45);
        [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(workNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        if([workType[i] questiontype] == 1){ // 选择题
        if ([arr[i] count] != 0) {
            btn.backgroundColor = STUDENTCOLOR;
            self.layer.borderWidth = 0;
            btn.layer.cornerRadius = btn.height / 2;
        }else{
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.cornerRadius = btn.height / 2;
        }
        }else{ // 填空题
            NSInteger flag = 0;
            for (NSString *str in arr[i]) {
                if(str.length != 0){
                    flag = 1;
                    break;
                }
            }
            if(flag == 1){
                btn.backgroundColor = STUDENTCOLOR;
                self.layer.borderWidth = 0;
                btn.layer.cornerRadius = btn.height / 2;
            }else{
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btn.layer.cornerRadius = btn.height / 2;
            }
        }
        [self.bgView addSubview:btn];
    }
    
     self.submitBtn.y = (margin + 45) * ( 1 + (arr.count - 1) / 6) + 65;

}

- (void)workNumBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(workResultView:workNumBtnClick:)]) {
        [self.delegate workResultView:self workNumBtnClick:btn];
    }
}
- (void)submitBtnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(workResultView:sumbitBtnClick:)]){
        [self.delegate workResultView:self sumbitBtnClick:btn];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    if([self.delegate respondsToSelector:@selector(workResultView:)]){
        [self.delegate workResultView:self];
    }
}
@end
