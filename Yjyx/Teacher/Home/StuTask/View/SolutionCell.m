//
//  SolutionCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SolutionCell.h"
#import "RCLabel.h"

@interface SolutionCell ()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@end

@implementation SolutionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    if (htmlString != nil && htmlString.length != 0) {
        NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", htmlString];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        web.scrollView.showsHorizontalScrollIndicator = NO;
        web.scrollView.scrollEnabled = NO;
        web.scrollView.bounces = NO;
        web.delegate = self;
        [web loadHTMLString:jsString baseURL:nil];
        [self.bg_view addSubview:web];
        
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
    
    self.height = frame.size.height + 40 + 40;
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeight" object:self];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
