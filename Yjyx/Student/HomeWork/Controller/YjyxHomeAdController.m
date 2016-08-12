//
//  YjyxHomeAdController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/10.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeAdController.h"
#import <WebKit/WebKit.h>

@interface YjyxHomeAdController ()

@property (strong, nonatomic) WKWebView *webView;
@end

@implementation YjyxHomeAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化webview
    [self setupWebView];
}
- (void)setupWebView
{
    WKWebView *webView = [[WKWebView alloc] init];
    
    self.webView = webView;
    [self.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.page_detail]];
    [webView loadRequest:request];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
