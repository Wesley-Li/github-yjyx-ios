//
//  QuestionPreviewCell.m
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "QuestionPreviewCell.h"
#import "ChaperContentItem.h"
#import "YjyxWrongSubModel.h"

@interface QuestionPreviewCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *subject_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *BGVIEW;

@property (weak, nonatomic) IBOutlet UIButton *requireProBtn;

@end

@implementation QuestionPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.upButton.layer.cornerRadius = 5;
    self.upButton.layer.masksToBounds = YES;
    self.upButton.layer.borderWidth = 1;
    self.upButton.layer.borderColor = RGBACOLOR(3, 138, 228, 1).CGColor;
    
    self.downButton.layer.cornerRadius = 5;
    self.downButton.layer.masksToBounds = YES;
    self.downButton.layer.borderWidth = 1;
    self.downButton.layer.borderColor = RGBACOLOR(3, 138, 228, 1).CGColor;
    
    self.requireProBtn.layer.cornerRadius = 5;
    self.requireProBtn.layer.masksToBounds = YES;
    self.requireProBtn.layer.borderWidth = 1;
    self.requireProBtn.layer.borderColor = TEACHERCOLOR.CGColor;
    
}

- (void)setValueWithModel:(ChaperContentItem *)model {
    
    for (UIView *view in [self.BGVIEW subviews]) {
        [view removeFromSuperview];
    }
    self.questionNumberLabel.layer.cornerRadius = 5;
    self.questionNumberLabel.layer.masksToBounds = YES;
    self.questionNumberLabel.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    self.levelLabel.textColor = RGBACOLOR(204, 204, 153, 1);
    
    self.subject_typeLabel.text = model.subject_type;
    
    if ([model.subject_type isEqualToString:@"1"]) {
        self.subject_typeLabel.text = @"选择题";
    }else if ([model.subject_type isEqualToString:@"2"]) {
    
        self.subject_typeLabel.text = @"填空题";
    }
    
    switch (model.level) {
        case 1:
            self.levelLabel.text = @"难度:简单";
            break;
        case 2:
            self.levelLabel.text = @"难度:中等";
            break;
        case 3:
            self.levelLabel.text = @"难度:较难";
            break;
        default:
            break;
            
    }
    
    self.bg_view.layer.borderWidth = 1;
    self.bg_view.layer.cornerRadius = 8;
    self.bg_view.layer.masksToBounds = YES;
    self.bg_view.layer.borderColor = [UIColor colorWithHexString:@"#e4e4e6"].CGColor;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.userInteractionEnabled = NO;
    web.delegate = self;
    web.detectsPhoneNumbers = NO;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    model.content_text = [model.content_text  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content_text];
    
    [web loadHTMLString:jsString baseURL:nil];
    
    
    [self.BGVIEW addSubview:web];
    self.requireProBtn.selected = model.isRequireProcess;
    if (self.requireProBtn.selected) {
        self.requireProBtn.backgroundColor = TEACHERCOLOR;
    }else {
        self.requireProBtn.backgroundColor = [UIColor whiteColor];
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
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 40, SCREEN_WIDTH - 40];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    self.height = frame.size.height + 50 + 40;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionPreviewCellHeight" object:self userInfo:nil];

}

- (IBAction)requireProcessBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(questionPreviewCell:isRequireProBtnClicked:)]) {
        [self.delegate questionPreviewCell:self isRequireProBtnClicked:sender];
    }
    if(sender.selected == YES){
        self.requireProBtn.backgroundColor = TEACHERCOLOR;
        if(_chaperItem == nil){
            NSLog(@"%@", _wrongModel);
            _wrongModel.isRequireProcess = YES;
        }else{
            _chaperItem.isRequireProcess = YES;
        }
    }else{
        self.requireProBtn.backgroundColor = [UIColor whiteColor];
        if(_chaperItem == nil){
            _wrongModel.isRequireProcess = NO;
        }else{
            _chaperItem.isRequireProcess = NO;
        }
    }
   
}


- (void)setWrongWithModel:(YjyxWrongSubModel *)model
{
    for (UIView *view in [self.BGVIEW subviews]) {
        [view removeFromSuperview];
    }
    
    NSLog(@"%@, %d", model, model.isRequireProcess);
    self.requireProBtn.selected = model.isRequireProcess;
    
    self.questionNumberLabel.layer.cornerRadius = 5;
    self.questionNumberLabel.layer.masksToBounds = YES;
    self.questionNumberLabel.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    self.levelLabel.textColor = RGBACOLOR(204, 204, 153, 1);
    
//    self.subject_typeLabel.text = [NSString stringWithFormat:@"%ld", model.questiontype ];
    
    if (model.questiontype == 1) {
        self.subject_typeLabel.text = @"选择题";
    }else if (model.questiontype == 2) {
        
        self.subject_typeLabel.text = @"填空题";
    }
    
    switch (model.level) {
        case 1:
            self.levelLabel.text = @"难度:简单";
            break;
        case 2:
            self.levelLabel.text = @"难度:中等";
            break;
        case 3:
            self.levelLabel.text = @"难度:较难";
            break;
        default:
            break;
            
    }
    
    self.bg_view.layer.borderWidth = 1;
    self.bg_view.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    
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
  
    [self.BGVIEW addSubview:web];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
