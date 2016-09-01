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
#import "YjyxCommonTabController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *deviceToken;

@property (strong, nonatomic) NavRootViewController *navigation;

@property (strong, nonatomic) UITabBarController *tabBar;// 家长端底部标签控制器

@property (strong, nonatomic) CustomTabBarViewController *cusTBViewController;// 老师端底部标签控制器

@property (strong, nonatomic) YjyxCommonTabController *tabBarVc;

@property (strong, nonatomic) NSString *role;// 用户身份

//@property (nonatomic, strong) dispatch_source_t timer;// 定时器
@property (nonatomic, strong) NSMutableArray *stuListArr;
@property (nonatomic, assign) BOOL isComeFromNoti;
@property (nonatomic, strong) NSDictionary *remoteNoti;// 推送消息


- (void)fillViews;
- (void)getStuList;
- (void)getStuListComplete:(void(^)(void))compeletion;
@end

