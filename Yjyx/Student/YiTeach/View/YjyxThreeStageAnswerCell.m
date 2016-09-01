//
//  YjyxThreeStageAnswerCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxThreeStageAnswerCell.h"
#import "YjyxThreeStageModel.h"
#import "YjyxHomeWorkButton.h"
@interface YjyxThreeStageAnswerCell()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *analysisBtn;
@property (weak, nonatomic) IBOutlet UIImageView *isRightImageView;
@property (weak, nonatomic) IBOutlet UILabel *stuAnswerLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *righttextLabel;

@end
@implementation YjyxThreeStageAnswerCell
static CGFloat btnWH = 24;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.analysisBtn.layer.cornerRadius = 5;
    self.analysisBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    self.analysisBtn.layer.borderWidth = 1;
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}
- (void)setupAnswerView
{
    NSArray *choiceAnswer = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
    
    for (UIView *view in self.answerView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *answerArr = [_model.stuAnswer componentsSeparatedByString:@"|"];
    CGFloat margin = (169 - 6 * btnWH) / 7;
    NSInteger choiceTotalNum = [_model.choicecount integerValue];
    CGFloat beginX = (5 - (choiceTotalNum - 1) % 6) * (margin + btnWH);
    for (int i = 0; i < choiceTotalNum; i++) {
        YjyxHomeWorkButton *btn = [YjyxHomeWorkButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:choiceAnswer[i] forState:UIControlStateNormal];
        btn.width = btnWH;
        btn.height = btnWH;
        if(choiceTotalNum <= 6){
            btn.x = margin + beginX + i * (margin + btnWH);
            btn.centerY = 30;
        }else{
            btn.x = margin + beginX * (i / 6) + (i % 6) * (margin + btnWH);
            btn.centerY = i / 6  * (30 ) + 30;
        }
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
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
        
//        [btn addTarget:self action:@selector(answerBtnNumClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:btn];
    }
    
}

- (void)setModel:(YjyxThreeStageModel *)model
{
    NSArray *choiceAnswer = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
    _model = model;
    [self setupAnswerView];
    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    model.content = [model.content  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    [self.webView loadHTMLString:jsString baseURL:nil];
    
    if ([model.choicecount integerValue] > 6) {
        self.bottomConst.constant = 90;
    }else{
        self.bottomConst.constant = 60;
    }
    // 正确答案
    NSArray *arr = [model.answer componentsSeparatedByString:@"|"];
    NSString *rightAnswer = @"";
    for (NSString *str in arr) {
        NSInteger num = [str integerValue];
//         [rightAnswer stringByAppendingString:choiceAnswer[num]];
        rightAnswer = [NSString stringWithFormat:@"%@%@", rightAnswer, choiceAnswer[num]];
        NSLog(@"%@", rightAnswer);
    }
    self.stuAnswerLabel.text = rightAnswer;
    
    NSArray *stuArr = [model.stuAnswer componentsSeparatedByString:@"|"];
    if([arr isEqualToArray:stuArr]){
        self.isRightImageView.image = [UIImage imageNamed:@"YI_right"];
        self.righttextLabel.textColor = [UIColor colorWithHexString:@"#2ecc71"];
        self.stuAnswerLabel.textColor = [UIColor colorWithHexString:@"#2ecc71"];
    }else{
        self.isRightImageView.image = [UIImage imageNamed:@"YI_wrong"];
        self.righttextLabel.textColor = [UIColor colorWithHexString:@"#e74c3c"];
        self.stuAnswerLabel.textColor = [UIColor colorWithHexString:@"#e74c3c"];
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGRect frame = webView.frame;
    
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if (img.width > %f) {\
    img.style.maxWidth = %f; \
    }\
    } \
    }";
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 55, SCREEN_WIDTH - 55];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    frame.size.height = webView.scrollView.contentSize.height;
    //    webView.frame = frame;
    CGFloat bottomHeight = 60;
    if([_model.choicecount integerValue] > 6){
        bottomHeight = 90;
    }
   
    self.height = frame.size.height + bottomHeight + 60;
 
    NSLog(@"%f", self.height);
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT2" object:self userInfo:nil];
    
}
- (IBAction)analysisBtnClick:(UIButton *)sender {
    if ([self.deleagte respondsToSelector:@selector(threeStageAnswerCell:analysisBtnClick:)]) {
        [self.deleagte threeStageAnswerCell:self analysisBtnClick:sender];
    }
}


@end
