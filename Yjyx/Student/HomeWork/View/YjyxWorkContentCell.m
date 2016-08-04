//
//  YjyxWorkContentCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkContentCell.h"

#import "YjyxWorkDetailModel.h"
#import "YjyxStuAnswerModel.h"
@interface YjyxWorkContentCell()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *teacherExpBtn;
@property (weak, nonatomic) IBOutlet UIButton *yiTeachExpBtn;

@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAnswerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isRightImageV;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) UIWebView *web;
@property (assign, nonatomic) CGRect webFrame;
@end
@implementation YjyxWorkContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.teacherExpBtn.layer.borderWidth = 1;
    self.teacherExpBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    
    self.yiTeachExpBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    self.yiTeachExpBtn.layer.borderWidth = 1;
    
    // 题目内容赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    _web = web;
    web.delegate = self;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    [self.bgView addSubview:web];
}
- (void)setFinishModel:(YjyxWorkDetailModel *)finishModel
{
    _finishModel = finishModel;
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\"><meta name = \"format-detection\" content = \"telephone=no\">%@</p>", finishModel.content];
    
    [_web loadHTMLString:jsString baseURL:nil];
}
- (void)setStuAsnwerModel:(YjyxStuAnswerModel *)stuAsnwerModel
{
    _stuAsnwerModel = stuAsnwerModel;
    if ([stuAsnwerModel.isRight isEqual:@0]) {
        self.isRightImageV.image = [UIImage imageNamed:@"list_btn_wrong"];
    }else{
        self.isRightImageV.image = [UIImage imageNamed:@"list_btn_right"];
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
    self.webFrame = frame;
    self.height = frame.size.height + 120;
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:nil];
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}
- (IBAction)showMoreBtn:(id)sender {
}

@end
