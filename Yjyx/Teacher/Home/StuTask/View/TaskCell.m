//
//  TaskCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskCell.h"
#import "RCLabel.h"

@interface TaskCell ()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *dificultyLabel;

@property (nonatomic, strong) UIWebView *web;



@end

@implementation TaskCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithDictionary:(NSDictionary *)dic {
    

    if (dic == nil) {
        return;
    }
    self.dificultyLabel.text = [NSString stringWithFormat:@"难度:%@级", [dic[@"question"] objectForKey:@"level"]];
    
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 500)];
    self.web.delegate = self;
    _web.scrollView.bounces = NO;
    _web.scrollView.scrollEnabled = NO;
    _web.scrollView.showsVerticalScrollIndicator = NO;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.userInteractionEnabled = NO;
    [_web sizeToFit];

    NSString *htmlString = [dic[@"question"] objectForKey:@"content"];
    NSString *htmlContent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
    [_web loadHTMLString:htmlContent baseURL:nil];
    [self.contentView addSubview:_web];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    // 获取页面高度
    NSString *clientHeight_str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    float clientHeight = [clientHeight_str floatValue];
    
    // 设置到webView上
   
    webView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, clientHeight);
    // 获取最佳尺寸
    CGSize frameB = [webView sizeThatFits:webView.frame.size];
    
    // 获取实际高度
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    
    //内容实际高度（像素）* 点和像素的比
    height = height * frameB.height / clientHeight;
    
    //再次设置WebView高度（点）
    webView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, height);
    
    
    self.height = height + 5 + 40;

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
