//
//  SolutionCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SolutionCell.h"
#import "RCLabel.h"

@interface SolutionCell ()


@property (weak, nonatomic) IBOutlet UILabel *title_label;


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
    
    
    /*
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH - 20, 20)];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    [webView sizeToFit];
    // 加载富文本
    [webView loadHTMLString:htmlString baseURL:nil];
    [self.contentView addSubview:webView];
    
    self.height = 50;
    */
    NSString *htmlString = [dic[@"question"] objectForKey:@"explanation"];
    if ([htmlString isEqualToString:@""]) {
        self.title_label.text = @"";
    }
    NSString *content = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *contentLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 500)];

    contentLabel.userInteractionEnabled = NO;

    contentLabel.font = [UIFont systemFontOfSize:12];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    contentLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [contentLabel optimumSize];
    self.height = optimalSize.height + 40 + 40;
    [self.contentView addSubview:contentLabel];
  
    
}

/*
// 在此代理方法中获取高度
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    
    frame.size.height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 10;
    frame.size.width = SCREEN_WIDTH - 20;
    
    webView.frame = frame;
    
    self.height = frame.size.height + 30 + 20;
    
}
 
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
