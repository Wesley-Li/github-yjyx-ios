//
//  AppDelegate.h
//  Yjyx
//
//  Created by zjbpha on 16/2/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login&Regist/LoginViewController.h"
#import "CustomTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *deviceToken;

@property (strong, nonatomic) NavRootViewController *navigation;

@property (strong, nonatomic) UITabBarController *tabBar;

@property (strong, nonatomic) CustomTabBarViewController *cusTBViewController;

@property (strong, nonatomic) NSString *role;// 用户身份

//@property (nonatomic, strong) dispatch_source_t timer;// 定时器
@property (nonatomic, strong) NSMutableArray *stuListArr;



- (void)fillViews;
- (void)getStuList;

@end

