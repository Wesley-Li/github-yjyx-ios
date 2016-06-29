//
//  MicroCell.m
//  Yjyx
//
//  Created by liushaochang on 16/6/29.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroCell.h"
#import "PMicroPreviewModel.h"

@implementation MicroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    self.bgView.layer.borderWidth = 1;

}

- (void)setValuesWithModel:(PMicroPreviewModel *)model {

    for (UIView *view in self.bgView.subviews) {
        [view removeFromSuperview];
    }
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10, 20)];
    web.scrollView.scrollEnabled = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;
    web.delegate = self;
    
    [web loadHTMLString:model.content baseURL:nil];
    
    [self.bgView addSubview:web];

    
}

#pragma mark - webviewDelegate
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
    
    self.height = frame.size.height + 4;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellHeighChange" object:self userInfo:nil];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
