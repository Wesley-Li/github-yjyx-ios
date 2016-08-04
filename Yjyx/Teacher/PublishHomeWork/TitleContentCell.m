//
//  TitleContentCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TitleContentCell.h"

#import "OneSubjectModel.h"
@interface TitleContentCell()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@end
@implementation TitleContentCell

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
    web.scrollView.scrollEnabled = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;
    web.userInteractionEnabled = NO;

    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\"><meta name = \"format-detection\" content = \"telephone=no\">%@</p>", model.content];
    [web loadHTMLString:jsString baseURL:nil];
    [self.bgview addSubview:web];

    NSString *str = @"简单";
    if (model.level == 2) {
        str = @"中等";
    }else if (model.level == 3){
        str = @"较难";
    }
    self.levelLabel.text =  str;
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
    self.height = frame.size.height + 60;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webHeight" object:self userInfo:nil];
    
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame:frame];
}
@end
