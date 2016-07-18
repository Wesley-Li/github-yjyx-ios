//
//  ChildrenResultCell.m
//  Yjyx
//
//  Created by liushaochang on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenResultCell.h"
#import "ChildrenResultModel.h"
#import "ResultModel.h"
#import "YjyxStuAnswerModel.h"
#import "YjyxWorkDetailModel.h"
@interface ChildrenResultCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *BGVIEW;// 大背景
@property (weak, nonatomic) IBOutlet UIView *bg_view;// 背景
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAnswerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RWimageView;

@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UIButton *stuAnswer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightAnswerBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myAnswerBottomConstraint;


@end

@implementation ChildrenResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.correctLabel.textColor = RGBACOLOR(22, 156, 111, 1);
    self.stuAnswer.backgroundColor = [UIColor whiteColor];
    [self.stuAnswer setTitleColor:RGBACOLOR(22, 156, 111, 1) forState:UIControlStateNormal];
    
    self.BGVIEW.layer.borderWidth = 1;
    self.BGVIEW.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    self.lineView.backgroundColor = RGBACOLOR(140.0, 140.0, 140.0, 1);
    self.rightAnswerLabel.textColor = RGBACOLOR(100, 174, 99, 1);
    
    self.solutionBtn.layer.cornerRadius = 5;
    self.solutionBtn.layer.borderWidth = 1;
    self.solutionBtn.layer.masksToBounds = YES;
    self.solutionBtn.layer.borderColor = RGBACOLOR(22, 156, 111, 1).CGColor;
    [self.solutionBtn setTitleColor:RGBACOLOR(22, 156, 111, 1) forState:UIControlStateNormal];
    
    
    self.annotationBtn.hidden = YES;
    self.annotationBtn.layer.cornerRadius = 5;
    self.annotationBtn.layer.borderWidth = 1;
    self.solutionBtn.layer.masksToBounds = YES;
    self.annotationBtn.layer.borderColor = RGBACOLOR(22, 156, 111, 1).CGColor;
    [self.annotationBtn setTitleColor:RGBACOLOR(22, 156, 111, 1) forState:UIControlStateNormal];
    
   
    
    
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
    
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    
    [web loadHTMLString:jsString baseURL:nil];
    

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
        
        self.rightAnswerLabel.text = [NSString stringWithFormat:@"  %@", tureAnswer];
        
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
        
        // 展开按钮的显示
        self.expandBtn.hidden = [model.answerCount integerValue] > 1 ? NO : YES;
        
        NSLog(@"------%@", self.expandBtn.selected ? @"yes" : @"no");
        
        // 填空的显示
        NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
        NSArray *answerArr = [model.answer JSONValue];
        if (!self.expandBtn.selected) {
            self.rightAnswerLabel.text = [NSString stringWithFormat:@"%@%@", cornerAry[0], answerArr.firstObject];
            self.myAnswerLabel.text = [NSString stringWithFormat:@"%@%@", cornerAry[0], resultModel.myAnswer.firstObject];
        }else {
            // 正确答案显示
            NSString *tempString1 = @"";
            for (int i = 0; i < answerArr.count; i++) {
                tempString1 = [tempString1 stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], answerArr[i]]];
            }
            
            self.rightAnswerLabel.text = tempString1;
            
            // 学生答案的展示
            NSString *tempString2 = @"";
            for (int i = 0; i < resultModel.myAnswer.count; i++) {
                tempString2 = [tempString2 stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], resultModel.myAnswer[i]]];
            }
            
            self.myAnswerLabel.text = tempString2;
            
        }
    
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
- (void)setSubviewsWithWorkDetailModel:(YjyxWorkDetailModel *)model andStuResultModel:(YjyxStuAnswerModel *)resultModel {
    
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    self.solutionBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    [self.solutionBtn setTitleColor:STUDENTCOLOR forState:UIControlStateNormal];
    self.annotationBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    [self.annotationBtn setTitleColor:STUDENTCOLOR forState:UIControlStateNormal];
    // 题目内容赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.delegate = self;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    
    [web loadHTMLString:jsString baseURL:nil];
    
    
    // 正确答案赋值
    // 选择题还是填空题,选择题是否多选
    if ( [resultModel.subject_type isEqual:@1 ]) {
        
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
        
        self.rightAnswerLabel.text = [NSString stringWithFormat:@"  %@", tureAnswer];
        
        // 学生答案显示
        
        NSString *myanswer = [NSString stringWithFormat:@""];
        for (int i = 0; i < resultModel.stuAnswerArr.count; i++) {
            NSInteger num = [resultModel.stuAnswerArr[i] integerValue];
            myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@" %@",[letterAry objectAtIndex:num]]];
        }
        
        if (myanswer.length == 0) {
            self.myAnswerLabel.text = @"无作答";
        }else {
            
            self.myAnswerLabel.text = myanswer;
            
        }
        
        
    }else {
        // 填空题
        
        // 展开按钮的显示
        self.expandBtn.hidden = resultModel.stuAnswerArr.count  > 1 ? NO : YES;
        
        NSLog(@"------%@", self.expandBtn.selected ? @"yes" : @"no");
        
        // 填空的显示
        NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
        NSArray *answerArr = [model.answer JSONValue];
        if (!self.expandBtn.selected) {
            self.rightAnswerLabel.text = [NSString stringWithFormat:@"%@%@", cornerAry[0], answerArr.firstObject];
            self.myAnswerLabel.text = [NSString stringWithFormat:@"%@%@", cornerAry[0], resultModel.stuAnswerArr.firstObject];
        }else {
            // 正确答案显示
            NSString *tempString1 = @"";
            for (int i = 0; i < answerArr.count; i++) {
                tempString1 = [tempString1 stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], answerArr[i]]];
            }
            
            self.rightAnswerLabel.text = tempString1;
            
            // 学生答案的展示
            NSString *tempString2 = @"";
            for (int i = 0; i < resultModel.stuAnswerArr.count; i++) {
                tempString2 = [tempString2 stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], resultModel.stuAnswerArr[i]]];
            }
            
            self.myAnswerLabel.text = tempString2;
            
        }
        
    }
    
    // 解题方法按钮是否显示
    if ([model.showview isEqual:@0]) {
        self.solutionBtn.hidden = YES;
        
    }else {
        
        self.solutionBtn.hidden = NO;
    }
    
    
    // 对错按钮显示
    if ([resultModel.isRight isEqual:@0]) {
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
    
    
    
    // 正确答案文本高度
    CGFloat rightAnswerHeight = [self.rightAnswerLabel.text boundingRectWithSize:CGSizeMake(self.rightAnswerLabel.width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.rightAnswerLabel.font, NSFontAttributeName, nil] context:nil].size.height;
    
    CGFloat myAnswerHeight = [self.myAnswerLabel.text boundingRectWithSize:CGSizeMake(self.myAnswerLabel.width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.myAnswerLabel.font, NSFontAttributeName, nil] context:nil].size.height;
    
    CGFloat customHeight = rightAnswerHeight > myAnswerHeight ? rightAnswerHeight : myAnswerHeight;
    
    if (rightAnswerHeight > myAnswerHeight) {
        self.myAnswerBottomConstraint.constant = rightAnswerHeight - myAnswerHeight + 7;
    }else if (rightAnswerHeight == myAnswerHeight){
        
        self.rightAnswerBottomConstraint.constant = 10;
        self.myAnswerBottomConstraint.constant = 10;
    
    }else {
    
        self.rightAnswerBottomConstraint.constant = myAnswerHeight - rightAnswerHeight + 7;
    }
    
    
    self.height = frame.size.height + 10 + 25 + 10 + 10 + customHeight + 30;
    
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:nil];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
