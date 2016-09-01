//
//  SolutionCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SolutionCell.h"


@interface SolutionCell ()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) UIWebView *web;

@end

@implementation SolutionCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}


- (void)setSolutionValueWithDiction:(NSDictionary *)dic {

    if (dic == nil) {
        return;
    }
    
    // 清空上次添加的所有子视图
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    NSString *htmlString = [dic[@"question"] objectForKey:@"explanation"];
    NSLog(@"%@", htmlString);
    if (htmlString != nil && htmlString.length != 0) {
        NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
        
        htmlString = [htmlString  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
        NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\"><meta name = \"format-detection\" content = \"telephone=no\">%@</p>", htmlString];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        web.scrollView.showsHorizontalScrollIndicator = NO;
        web.scrollView.scrollEnabled = NO;
        web.scrollView.bounces = NO;
        web.detectsPhoneNumbers = NO;
        web.delegate = self;
        [self.bg_view addSubview:web];
        [web loadHTMLString:jsString baseURL:nil];
        
        
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
    
    NSLog(@"%@", NSStringFromCGSize(webView.scrollView.contentSize));
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    
    self.height = frame.size.height + 40;
    NSLog(@"+++++++%.f", self.height);
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeightChange" object:self];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
