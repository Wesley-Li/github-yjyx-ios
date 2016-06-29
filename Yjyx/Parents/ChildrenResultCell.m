//
//  ChildrenResultCell.m
//  Yjyx
//
//  Created by liushaochang on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenResultCell.h"
#import "RCLabel.h"
#import "ChildrenResultModel.h"
#import "ResultModel.h"

@interface ChildrenResultCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *BGVIEW;// 大背景
@property (weak, nonatomic) IBOutlet UIView *bg_view;// RCLabel背景
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAnswerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RWimageView;




@end

@implementation ChildrenResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.BGVIEW.layer.borderWidth = 1;
    self.BGVIEW.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    self.lineView.backgroundColor = RGBACOLOR(140.0, 140.0, 140.0, 1);
    self.rightAnswerLabel.textColor = RGBACOLOR(100, 174, 99, 1);
    self.solutionBtn.backgroundColor = RGBACOLOR(22, 156, 111, 1);
    [self.solutionBtn setCornerRadius:5];
    
    
}


- (void)setSubviewsWithChildrenResultModel:(ChildrenResultModel *)model andResultModel:(ResultModel *)resultModel {
    
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    // 题目内容赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.delegate = self;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    [web loadHTMLString:model.content baseURL:nil];
    

    // 正确答案赋值
    // 选择题还是填空题,选择题是否多选
    if ([model.questionType isEqualToString:@"choice"] && [resultModel.questionType isEqualToString:@"choice"]) {
        
        // 隐藏展开按钮
        self.expandBtn.hidden = YES;
        
        NSArray *letterAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"M", nil];
        NSString *tureAnswer = nil;
        
        // 正确答案显示
        if ([model.answer containsString:@"|"]) {
            // 多选
            NSArray *answerArr = [model.answer componentsSeparatedByString:@"|"];
            for (NSString *str in answerArr) {
                NSString *tempStr = [letterAry objectAtIndex:[str integerValue]];
                
                if (tureAnswer == nil) {
                    tureAnswer = [NSString stringWithFormat:@"%@", tempStr];
                }else{
                    
                    tureAnswer = [NSString stringWithFormat:@"%@%@", tureAnswer,tempStr];
                }
            }
            
            
        }else {
            // 单选
            tureAnswer = [letterAry objectAtIndex:[model.answer integerValue]];
            
        }
        
        self.rightAnswerLabel.text = [NSString stringWithFormat:@"正确答案:%@", tureAnswer];
        
        // 学生答案显示
        
        NSString *myanswer = [NSString stringWithFormat:@""];
        for (int i = 0; i < resultModel.myAnswer.count; i++) {
            NSInteger num = [resultModel.myAnswer[i] integerValue];
            myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@" %@",[letterAry objectAtIndex:num]]];
        }

        if (myanswer.length == 0) {
            self.myAnswerLabel.text = @"无作答";
        }else {
        
            self.myAnswerLabel.text = myanswer;

        }
        

    }else {
        // 填空题
        
    
    }
    
    // 解题方法按钮是否显示
    if ([model.showview isEqual:@0]) {
        self.solutionBtn.hidden = YES;
        
    }else {
    
        self.solutionBtn.hidden = NO;
    }
    

    // 对错按钮显示
    if ([resultModel.rightOrWrong isEqual:@0]) {
        self.RWimageView.image = [UIImage imageNamed:@"list_btn_wrong"];
        self.myAnswerLabel.textColor = [UIColor redColor];
        
    }else {
    
        self.RWimageView.image = [UIImage imageNamed:@"list_btn_right"];
        self.myAnswerLabel.textColor = RGBACOLOR(100, 174, 99, 1);
    }
    
    
    [self.bg_view addSubview:web];

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
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 40, SCREEN_WIDTH - 40];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    self.height = frame.size.height + 70;
    
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:nil];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
