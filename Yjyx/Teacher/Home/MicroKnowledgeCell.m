//
//  MicroKnowledgeCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroKnowledgeCell.h"
#import "MicroDetailModel.h"
#import "YjyxMicroWorkModel.h"
@interface MicroKnowledgeCell()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *knowLedgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *knowLabel;

@property (weak, nonatomic) UIWebView *web;
@end
@implementation MicroKnowledgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // web赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(6, 32, SCREEN_WIDTH - 22, 10)];
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;
    web.scrollView.scrollEnabled = NO;
    web.userInteractionEnabled = NO;
    web.detectsPhoneNumbers = NO;
    web.delegate = self;
    self.web = web;
    [self.contentView addSubview:web];
}

- (void)setModel:(MicroDetailModel *)model
{
    _model = model;
    self.knowLedgeLabel.text = model.knowledgedesc;
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.knowledgedesc];
    [_web loadHTMLString:jsString baseURL:nil];
    NSLog(@"--%@", NSStringFromCGSize(_web.scrollView.contentSize));
    
}

- (void)setWorkModel:(YjyxMicroWorkModel *)workModel
{
    _workModel = workModel;
    self.knowLedgeLabel.text = workModel.knowledgedesc;
    if (workModel.knowledgedesc == nil) {
        self.knowLabel.hidden = YES;
        return;
    }else{
        self.knowLabel.hidden = NO;
    }
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", workModel.knowledgedesc];
    [_web loadHTMLString:jsString baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGRect frame = webView.frame;
    
//    NSLog(@"%@", webView.request);
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if (img.width > %f) {\
    img.style.maxWidth = %f; \
    }\
    } \
    }";
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 30, SCREEN_WIDTH - 30];
    
   
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:js];
   
    NSString *str1 =[webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
     NSLog(@"%@,  %@", str, str1);
    NSLog(@"%@", NSStringFromCGSize(webView.scrollView.contentSize));
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    self.height = frame.size.height + 37;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KnowlegewebviewHeight" object:self userInfo:nil];
    
}

@end
