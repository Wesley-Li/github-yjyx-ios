//
//  YjyxKnowledgeCardView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxKnowledgeCardView.h"

@interface YjyxKnowledgeCardView()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic) CGFloat height;
@end
@implementation YjyxKnowledgeCardView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.webView.delegate = self;
//    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}

+ (instancetype)knowledgeCardView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)setKnowledgeContent:(NSString *)knowledgeContent andHeight:(CGFloat)high
{
    _knowledgeContent = knowledgeContent;
    self.height = high;
    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    knowledgeContent = [knowledgeContent  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", knowledgeContent];
    NSLog(@"%@", jsString);
    [self.webView loadHTMLString:jsString baseURL:nil];
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
    js = [NSString stringWithFormat:js, SCREEN_WIDTH , SCREEN_WIDTH ];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    NSLog(@"%@", NSStringFromCGSize(webView.scrollView.contentSize));
    frame.size.height = webView.scrollView.contentSize.height;
    //    webView.frame = frame;
    CGFloat height = frame.size.height;
    if (height != self.height) {
        // 用通知发送加载完成后的高度
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT3" object:self userInfo:@{@"hight" : @(height)}];
    }
    NSLog(@"%f", height);
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.height > SCREEN_HEIGHT - 64){
        self.webView.height = SCREEN_HEIGHT - 64;
    }else{
        self.webView.height = self.height;
    }
    
}
@end
