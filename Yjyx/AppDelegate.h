//
//  AppDelegate.h
//  Yjyx
//
//  Created by zjbpha on 16/2/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login&Regist/LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *deviceToken;

@property (strong, nonatomic) NavRootViewController *navigation;

@property (strong, nonatomic) UITabBarController *tabBar;

- (void)fillViews;

@end

