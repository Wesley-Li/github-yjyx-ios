//
//  ChildrenVideoViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildrenVideoViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, retain)NSString * URLString;
@property (copy , nonatomic) NSString *explantionStr;
@end
