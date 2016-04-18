//
//  CommonWebViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebViewController : BaseViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *copyright;
    IBOutlet UIActivityIndicatorView *activity;
}

@property (strong,nonatomic) NSString *urlStr;

@end
