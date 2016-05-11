//
//  SolutionCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SolutionCell.h"

@interface SolutionCell ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *web;


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
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 500)];
    self.web.delegate = self;
    _web.scrollView.bounces = NO;
    _web.scrollView.scrollEnabled = NO;
    _web.scrollView.showsVerticalScrollIndicator = NO;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.userInteractionEnabled = NO;
    [_web sizeToFit];
    
    
    NSString *htmlString = [dic[@"question"] objectForKey:@"explanation"];
    NSString *htmlContent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
    [_web loadHTMLString:htmlContent baseURL:nil];
    [self.contentView addSubview:_web];
    /*
    //    NSLog(@"%@", htmlString);
    [self.web loadHTMLString:htmlString baseURL:nil];
    CGRect frame = _web.frame;
    frame.size.width = SCREEN_WIDTH - 20;
    frame.size.height = _web.scrollView.contentSize.height;
    _web.frame = frame;
    
    
    
    NSLog(@"%.f", _web.scrollView.contentSize.height);
    self.height = _web.frame.size.height + 30 + 30;
     */
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    // 获取页面高度
    NSString *clientHeight_str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    float clientHeight = [clientHeight_str floatValue];
    
    // 设置到webView上
//    CGRect frame = webView.frame;
//    frame.size.width = SCREEN_WIDTH - 20;
//    frame.size.height = clientHeight;
//    webView.frame = frame;
    webView.frame = CGRectMake(10, 40, SCREEN_WIDTH - 20, clientHeight);
    // 获取最佳尺寸
    CGSize frameB = [webView sizeThatFits:webView.frame.size];
    
    // 获取实际高度
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    
    //内容实际高度（像素）* 点和像素的比
    height = height * frameB.height / clientHeight;
    
    //再次设置WebView高度（点）
    webView.frame = CGRectMake(10, 40, SCREEN_WIDTH - 20, height);
   
    
    self.height = height + 40 + 40;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
