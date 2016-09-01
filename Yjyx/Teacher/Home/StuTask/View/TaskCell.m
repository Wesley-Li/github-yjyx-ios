//
//  TaskCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskCell.h"


@interface TaskCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *webBGVIEW;

@property (weak, nonatomic) IBOutlet UILabel *dificultyLabel;

@property (weak, nonatomic) IBOutlet UIView *bg_view;



@end

@implementation TaskCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setValueWithDictionary:(NSDictionary *)dic {
    
    _dic = dic;
    for (UIView *view in [self.webBGVIEW subviews]) {
        [view removeFromSuperview];
    }
    
    NSString *htmlString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"content"]];
    NSLog(@"%@", htmlString);
    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    htmlString = [htmlString  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\"><meta name = \"format-detection\" content = \"telephone=no\">%@</p>", htmlString];
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    web.delegate = self;

    [web loadHTMLString:jsString baseURL:nil];
    [self.webBGVIEW addSubview:web];


    NSInteger level;
    if ([dic[@"question"][@"level"] isEqual:[NSNull null]]) {
         level = 1;
         self.dificultyLabel.hidden = YES;
    }else{
     level = [[dic[@"question"] objectForKey:@"level"] integerValue];
    }
    switch (level) {
        case 1:
            self.dificultyLabel.text = @"难度:简单";
            break;
        case 2:
            self.dificultyLabel.text = @"难度:中等";
            break;
        case 3:
            self.dificultyLabel.text = @"难度:较难";
            break;
        default:
            break;

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
    
    self.height = frame.size.height + 15 + 30;
    NSLog(@"%.f", self.height);
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeightChange" object:self userInfo:nil];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
