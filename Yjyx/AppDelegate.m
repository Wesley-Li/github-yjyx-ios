//
//  AppDelegate.m
//  Yjyx
//
//  Created by zjbpha on 16/2/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "AppDelegate.h"
#import "ParentHomeViewController.h"
#import "ParentCommunityViewController.h"
#import "ParentPersonalViewController.h"
#import "AutoLoginViewController.h"
#import "UMessage.h"
#import "YjyxPMemberCenterViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()
{
    AutoLoginViewController *autologin;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        //1.注册APNS推送通知
    if (SYS_VERSION >= 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert categories:nil]];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    // Override point for customization after application launch.

    [UMessage startWithAppkey:@"56c2e28167e58ef1b1002dad" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
    [UMessage setLogEnabled:YES];
    
    
    //是否推送跳转到指定页面标记
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification != nil) {
        if ([remoteNotification[@"type"] isEqualToString:@"childactivity"]) {
            if ([remoteNotification[@"finished"] integerValue] == 0 ) {
                if ([remoteNotification[@"tasktype"] integerValue] ==1) {
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
                }else{
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
                }
            }else{
                if ([remoteNotification[@"tasktype"] integerValue] ==1) {
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTHOMEWORK;
                }else{
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTMICRO;
                }
         }
       }
        [YjyxOverallData sharedInstance].historyId = remoteNotification[@"id"];
        [YjyxOverallData sharedInstance].previewRid = remoteNotification[@"rid"];
    }
    
    NSDictionary *dic = (NSDictionary *)[SYS_CACHE objectForKey:@"AutoLogoin"];
    if ([[dic objectForKey:@"username"] length] > 0) {
        autologin = [[AutoLoginViewController alloc] init];
        _navigation = [[NavRootViewController alloc] initWithRootViewController:autologin];
        _navigation.navigationBar.hidden = YES;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = _navigation;
        [self.window makeKeyAndVisible];
    }else{
//        _deviceToken = @"1231231312da1231sqwc1213";
        LoginViewController *loginView = [[LoginViewController alloc] init];
        _navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
        _navigation.navigationBar.hidden = YES;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = _navigation;
        [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    _deviceToken = [[[NSString stringWithFormat:@"%@",deviceToken] substringWithRange:NSMakeRange(1, 71)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UMessage registerDeviceToken:deviceToken];
    if (autologin) {//获取到devicetoken后自动登录
        NSDictionary *dic = (NSDictionary *)[SYS_CACHE objectForKey:@"AutoLogoin"];
        [autologin autoLogin:[dic objectForKey:@"username"] password:[dic objectForKey:@"password"]];
        autologin = nil;
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"前台 ＝ %@",userInfo);
        if ([userInfo[@"type"] isEqualToString:@"childactivity"]) {
            
            if ([userInfo[@"finished"] integerValue] == 0 ) {
                if ([userInfo[@"tasktype"] integerValue] ==1) {
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
                }else{
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
                }
            }else{
                if ([userInfo[@"tasktype"] integerValue] ==1) {
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTHOMEWORK;
                }else{
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTMICRO;
                }
            }
            [YjyxOverallData sharedInstance].historyId = userInfo[@"id"];
            [YjyxOverallData sharedInstance].previewRid = userInfo[@"rid"];
            
            NSString *contentStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:contentStr delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看详情",nil];
            [alertView show];
        }else if ([userInfo[@"type"] isEqualToString:@"childstats"]){
            
        }else{
            
        }
    }else{
        NSLog(@"后台 ＝ %@",userInfo);
        if ([userInfo[@"type"] isEqualToString:@"childactivity"]) {
            if ([userInfo[@"finished"] integerValue] == 0 ) {
                if ([userInfo[@"tasktype"] integerValue] ==1) {
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
                }else{
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
                }
            }else{
                if ([userInfo[@"tasktype"] integerValue] ==1) {
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTHOMEWORK;
                }else{
                    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTMICRO;
                }
            }
            [YjyxOverallData sharedInstance].historyId = userInfo[@"id"];
            [YjyxOverallData sharedInstance].previewRid = userInfo[@"rid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildActivityNotification" object:nil];
        }else if ([userInfo[@"type"] isEqualToString:@"childstats"]){
            
        }else{
            
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"application result = %@",resultDic);
        }];
    }
    return YES;
}


#pragma mark 登录成功根界面
- (void)fillViews
{
    if (!_tabBar) {
        _tabBar = [[UITabBarController alloc] init];
    }
    
    NavRootViewController *home = [[NavRootViewController alloc] initWithRootViewController:[[ParentHomeViewController alloc] initWithNibName:@"ParentHomeViewController" bundle:nil]];
    home.tabBarItem = [UITabBarItem itemWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home"] selectedImage:[UIImage imageNamed:@"tab_homes"]];
    home.navigationBarHidden = YES;
    
//    NavRootViewController *community = [[NavRootViewController alloc] initWithRootViewController:[[ParentCommunityViewController alloc] initWithNibName:@"ParentCommunityViewController" bundle:nil]];
//    community.tabBarItem = [UITabBarItem itemWithTitle:@"社区" image:[UIImage imageNamed:@"tab_community"] selectedImage:[UIImage imageNamed:@"tab_communitys"]];
//    community.navigationBarHidden = YES;
    
    NavRootViewController *memberCenter = [[NavRootViewController alloc] initWithRootViewController:[[YjyxPMemberCenterViewController alloc] initWithNibName:@"YjyxPMemberCenterViewController" bundle:nil]];
    memberCenter.tabBarItem = [UITabBarItem itemWithTitle:@"会员中心" image:[UIImage imageNamed:@"tab_memberCenter"] selectedImage:[UIImage imageNamed:@"tab_memberCenters"]];
    
    NavRootViewController *personal = [[NavRootViewController alloc] initWithRootViewController:[[ParentPersonalViewController alloc] initWithNibName:@"ParentPersonalViewController" bundle:nil]];
    personal.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab_personal"] selectedImage:[UIImage imageNamed:@"tab_personals"]];
    
    [_tabBar setViewControllers:@[home,memberCenter,personal]];
    
    [_tabBar setSelectedIndex:0];
    [self.window setRootViewController:_tabBar];
}

#pragma mark -UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [_tabBar setSelectedIndex:0];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildActivityNotification" object:nil];
    }
}

@end
