//
//  CommonWebViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController ()

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.title = @"作业结果";
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"sessionid" forKey:NSHTTPCookieName];
    [cookieProperties setObject:SESSIONID forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"api.skyfox.org" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"api.skyfox.org" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:[NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]] forHTTPHeaderField:@"Cookie"];
    
    [copyright loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activity setHidden:NO];
    [activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activity stopAnimating];
    [activity setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activity stopAnimating];
    [activity setHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
