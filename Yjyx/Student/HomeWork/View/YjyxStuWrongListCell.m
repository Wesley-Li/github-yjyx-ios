//
//  YjyxStuWrongListCell.m
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuWrongListCell.h"
#import "YjyxStuWrongListModel.h"


@interface YjyxStuWrongListCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *BGVIEW;
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageview;
@property (weak, nonatomic) IBOutlet UILabel *myAnswer;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswer;

@property (weak, nonatomic) IBOutlet UILabel *stuAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stuAnswerBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightAnswerBottom;

@end

@implementation YjyxStuWrongListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.correctAnswer.textColor = RGBACOLOR(22, 156, 111, 1);
    
    self.BGVIEW.layer.borderWidth = 1;
    self.BGVIEW.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    self.lineImageview.backgroundColor = RGBACOLOR(140.0, 140.0, 140.0, 1);
    self.rightAnswerLabel.textColor = RGBACOLOR(22, 156, 111, 1);
    
    self.solutionBtn.layer.cornerRadius = 5;
    self.solutionBtn.layer.borderWidth = 1;
    self.solutionBtn.layer.masksToBounds = YES;
    self.solutionBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    [self.solutionBtn setTitleColor:STUDENTCOLOR forState:UIControlStateNormal];

    
    
    
}

- (void)setSubviewsWithModel:(YjyxStuWrongListModel *)model {

    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    // 题目内容赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.delegate = self;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;

    web.detectsPhoneNumbers = NO;

    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    model.content = [model.content  stringByReplacingOccurrencesOfString:@"<p>" withString:str];

    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    
    [web loadHTMLString:jsString baseURL:nil];
    
    
    // 选择/填空
    if ([model.q_type isEqual:@1]) {// 选择
        
        // 隐藏展开按钮
        self.expandBtn.hidden = YES;
        
        NSArray *letterAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"M", nil];
        NSString *tureAnswer = nil;
        
        // 学生答案
        if (model.stuAnswer) {
            
            NSString *myanswer = [NSString stringWithFormat:@""];
            for (int i = 0; i < model.stuAnswer.count; i++) {
                NSInteger num = [model.stuAnswer[i] integerValue];
                myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@"%@",[letterAry objectAtIndex:num]]];
            }

            self.stuAnswerLabel.text = myanswer;
            
        }else {
        
            self.stuAnswerLabel.text = @"无做答";
        }
        
        
        // 正确答案显示
        if ([model.correctAnswer containsString:@"|"]) {
            // 多选
            NSArray *answerArr = [model.correctAnswer componentsSeparatedByString:@"|"];
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
            tureAnswer = [letterAry objectAtIndex:[model.correctAnswer integerValue]];
            
        }
        
        self.rightAnswerLabel.text = [NSString stringWithFormat:@"%@", tureAnswer];

        
        
        
    }else {
        // 填空
        // 展开按钮的显示
        self.expandBtn.hidden = [[model.correctAnswer JSONValue] count] > 1 ? NO : YES;
        
        // 填空的显示
        NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
        NSArray *answerArr = [model.correctAnswer JSONValue];
        if (!self.expandBtn.selected) {
            self.rightAnswerLabel.text = [NSString stringWithFormat:@"%@%@", cornerAry[0], answerArr.firstObject];
            self.stuAnswerLabel.text = [NSString stringWithFormat:@"%@%@", cornerAry[0], model.stuAnswer.firstObject];
        }else {
            // 正确答案显示
            NSString *tempString1 = @"";
            for (int i = 0; i < answerArr.count; i++) {
                tempString1 = [tempString1 stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], answerArr[i]]];
            }
            
            self.rightAnswerLabel.text = tempString1;
            
            // 学生答案的展示
            NSString *tempString2 = @"";
            for (int i = 0; i < model.stuAnswer.count; i++) {
                tempString2 = [tempString2 stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], model.stuAnswer[i]]];
            }
            
            self.stuAnswerLabel.text = tempString2;
            
        }

        
    }
    
    // 解题方法按钮是否显示
    if ([model.showView isEqual:@0]) {
        self.solutionBtn.hidden = YES;
        
    }else {
        
        self.solutionBtn.hidden = NO;
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
    
    
    
    // 正确答案文本高度
    CGFloat rightAnswerHeight = [self.rightAnswerLabel.text boundingRectWithSize:CGSizeMake(self.rightAnswerLabel.width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.rightAnswerLabel.font, NSFontAttributeName, nil] context:nil].size.height;
    
    CGFloat myAnswerHeight = [self.stuAnswerLabel.text boundingRectWithSize:CGSizeMake(self.stuAnswerLabel.width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.stuAnswerLabel.font, NSFontAttributeName, nil] context:nil].size.height;
    
    CGFloat customHeight = rightAnswerHeight > myAnswerHeight ? rightAnswerHeight : myAnswerHeight;
    
    if (rightAnswerHeight > myAnswerHeight) {
        self.stuAnswerBottom.constant = rightAnswerHeight - myAnswerHeight + 7;
        
    }else if (rightAnswerHeight == myAnswerHeight){
        
        self.stuAnswerBottom.constant = 10;
        self.rightAnswerBottom.constant = 10;
    }else {
        
        self.rightAnswerBottom.constant = myAnswerHeight - rightAnswerHeight + 7;
    }
    
    
    self.height = frame.size.height + 10 + 25 + 10 + 10 + customHeight;
    
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:nil];
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
