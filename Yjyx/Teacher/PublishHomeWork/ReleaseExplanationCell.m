//
//  ReleaseExplanationCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseExplanationCell.h"
#import "OneSubjectModel.h"

@interface ReleaseExplanationCell()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@end
@implementation ReleaseExplanationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(OneSubjectModel *)model
{
    _model = model;
    
    for (UIView *view in [self.bgview subviews]) {
        [view removeFromSuperview];
    }
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.delegate = self;
    web.detectsPhoneNumbers = NO;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;
    web.userInteractionEnabled = NO;

    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    [web loadHTMLString:jsString baseURL:nil];
    [self.bgview addSubview:web];

    
    if([model.content isEqualToString:@""]){
        self.explanationLabel.hidden = YES;
        self.answerLabel.hidden = YES;
    }else{
        self.explanationLabel.hidden = NO;
        self.answerLabel.hidden = NO;
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
    self.height = frame.size.height + 80;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webHeight" object:self userInfo:nil];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
