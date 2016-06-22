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

#import "TeacherHomeViewController.h"
#import "MessageViewController.h"
#import "MyClassViewController.h"
#import "PrivateCenterViewController.h"
#import "PublishHomeworkViewController.h"

#import "ChildrenResultViewController.h"
#import "YjyxMicroClassViewController.h"
#import "YjyxWorkPreviewViewController.h"

#import "AutoLoginViewController.h"
#import "UMessage.h"
#import "YjyxPMemberCenterViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#import "StudentEntity.h"
#import "StuDataBase.h"
#import "StuClassEntity.h"
#import "StuGroupEntity.h"

#import "QuestionDataBase.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()
{
    AutoLoginViewController *autologin;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ((AppDelegate*)SYS_DELEGATE).role = @"parents";
    ((AppDelegate*)SYS_DELEGATE).stuListArr = [NSMutableArray array];
    
    // 创建定时器,并行,24小时执行一次
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    ((AppDelegate*)SYS_DELEGATE).timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 24*60*60 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(_timer, ^{
//        NSLog(@"我被调用了");
//        [(AppDelegate *)SYS_DELEGATE getStuList];
//    });

    [self initUmeng:launchOptions];
    // Override point for customization after application launch.
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
    
    // 自动登录,从本地取值
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
        _deviceToken = @"1231231312da1231sqwc1213";
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
        
        NSString *desPassword = [dic[@"password"] des3:kCCDecrypt withPass:@"12345678asdf"];
        
        [autologin autoLoginWithRole:dic[@"role"] username:dic[@"username"] password:desPassword];
        
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
        if ([userInfo[@"type"] isEqualToString:@"childstats"]) {//统计数据更新处理
            NSString *cachePath = [USER_IMGCACHE stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"cid"]]];

            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachePath error:nil];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *fileName;
            while (fileName = [e nextObject]) {
                [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName] error:NULL];
            }
        }
        
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
    [self.window endEditing:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

// 进入激活状态
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // 判断版本更新
    [self judgeAndUpdate];
    
    
    
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
    NSDictionary *dic = (NSDictionary *)[SYS_CACHE objectForKey:@"AutoLogoin"];
    // 添加判断
    if ([dic[@"username"] length] > 0) {
        ((AppDelegate *)SYS_DELEGATE).role = dic[@"role"];
    }
    
    if ([((AppDelegate *)SYS_DELEGATE).role isEqualToString:@"parents"]) {
       
        if (!_tabBar) {
            _tabBar = [[UITabBarController alloc] init];
        }
        
        NavRootViewController *home = [[NavRootViewController alloc] initWithRootViewController:[[ParentHomeViewController alloc] initWithNibName:@"ParentHomeViewController" bundle:nil]];
        home.tabBarItem = [UITabBarItem itemWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home"] selectedImage:[UIImage imageNamed:@"tab_homes"]];
        home.navigationBarHidden = YES;
        
        NavRootViewController *personal = [[NavRootViewController alloc] initWithRootViewController:[[ParentPersonalViewController alloc] initWithNibName:@"ParentPersonalViewController" bundle:nil]];
        personal.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab_personal"] selectedImage:[UIImage imageNamed:@"tab_personals"]];
        
        NavRootViewController *memberCenter = [[NavRootViewController alloc] initWithRootViewController:[[YjyxPMemberCenterViewController alloc] initWithNibName:@"YjyxPMemberCenterViewController" bundle:nil]];
        memberCenter.tabBarItem = [UITabBarItem itemWithTitle:@"会员中心" image:[UIImage imageNamed:@"tab_memberCenter"] selectedImage:[UIImage imageNamed:@"tab_memberCenters"]];
        
        [_tabBar setViewControllers:@[home,memberCenter,personal]];
        
        [_tabBar setSelectedIndex:0];
        [self.window setRootViewController:_tabBar];
        
        // 判断版本更新
        [self judgeAndUpdate];

        
    }else if ([((AppDelegate *)SYS_DELEGATE).role isEqualToString:@"teacher"]) {
        
        if (!_cusTBViewController) {
            _cusTBViewController = [[CustomTabBarViewController alloc] init];
        }
        
        // 首页
        NavRootViewController *teacherHome = [[NavRootViewController alloc] initWithRootViewController:[[TeacherHomeViewController alloc] initWithNibName:@"TeacherHomeViewController" bundle:nil]];
        teacherHome.tabBarItem = [UITabBarItem itemWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home"] selectedImage:[UIImage imageNamed:@"tab_home_click"]];
//        teacherHome.navigationBar.hidden = YES;
        
        // 消息
        NavRootViewController *message = [[NavRootViewController alloc] initWithRootViewController:[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil]];
        message.tabBarItem = [UITabBarItem itemWithTitle:@"消息" image:[UIImage imageNamed:@"message"] selectedImage:[UIImage imageNamed:@"message_click"]];
        
        // 发布作业
        NavRootViewController *publishHomework = [[NavRootViewController alloc] initWithRootViewController:[[PublishHomeworkViewController alloc] initWithNibName:@"PublishHomeworkViewController" bundle:nil]];
        publishHomework.tabBarItem = [UITabBarItem itemWithTitle:@"发布作业" image:nil selectedImage:nil];
        //    publishHomework.tabBarItem = [UITabBarItem itemWithTitle:@"发布作业" image:[UIImage imageNamed:@"publishhw"] selectedImage:[UIImage imageNamed:@"publishhw_click"]];
        
        // 班级
        NavRootViewController *myClass = [[NavRootViewController alloc] initWithRootViewController:[[MyClassViewController alloc] initWithNibName:@"MyClassViewController" bundle:nil]];
        myClass.tabBarItem = [UITabBarItem itemWithTitle:@"班级" image:[UIImage imageNamed:@"myclass"] selectedImage:[UIImage imageNamed:@"myclass_click"]];
        
        // 个人中心
        NavRootViewController *privateCenter = [[NavRootViewController alloc] initWithRootViewController:[[PrivateCenterViewController alloc] initWithNibName:@"PrivateCenterViewController" bundle:nil]];
        privateCenter.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"privatecenter"] selectedImage:[UIImage imageNamed:@"privatecenter_click"]];
        
        _cusTBViewController.viewControllers = @[teacherHome, message, publishHomework, myClass, privateCenter];
        
        //    _cusTBViewController.tabBar.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_cusTBViewController.tabBar setBackgroundImage:img];
        [_cusTBViewController.tabBar setShadowImage:img];
        _cusTBViewController.selectedIndex = 0;
        self.window.rootViewController = _cusTBViewController;
        
        // 判断日期获取学生列表
        [self judgeGetStuListDate];
        
        // 判断版本更新并获取学生列表
        [self judgeAndUpdate];
        
        
    
    }else if ([((AppDelegate *)SYS_DELEGATE).role isEqualToString:@"student"]) {
        
        // 学生登录
    
    }
    
    

    
}

// 判断日期获取学生列表
- (void)judgeGetStuListDate {

    NSDate *currentDate = [NSDate date];
    NSDate *oldDate = [SYS_CACHE objectForKey:@"getDate"];
    if (oldDate == nil) {
        
        [self getStuList];
        
    }else {
    
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:oldDate];
        
        if (timeInterval > 60*60*24) {
            [self getStuList];
            
        }else {
            
            return;
        }

        
    }

}





// 判断日期并更新
- (void)judgeAndUpdate {
    
    NSDate *currentDate = [NSDate date];
    
    NSString *force = [SYS_CACHE objectForKey:@"force"];
    NSDate *pastDate = [SYS_CACHE objectForKey:@"date"];
    
    
    
    if (force == nil) {
        
        if (pastDate == nil) {
            
            [self judgeAppVersionAndUploadWithRole:((AppDelegate *)SYS_DELEGATE).role andCurrentVersion:APP_VERSION];
            
            
        }else {
            
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:pastDate];
            
            if (timeInterval > 60*60*24) {
                
                [self judgeAppVersionAndUploadWithRole:((AppDelegate *)SYS_DELEGATE).role andCurrentVersion:APP_VERSION];
            }else {
                
                return;
            }
            
        }

        
    }else {
        
        
        [self judgeAppVersionAndUploadWithRole:((AppDelegate *)SYS_DELEGATE).role andCurrentVersion:APP_VERSION];
    
    
    }
        
    
    

}




#pragma mark - 版本更新

- (void)judgeAppVersionAndUploadWithRole:(NSString *)role andCurrentVersion:(NSString *)currentVerdion{
    
    NSLog(@"%@", currentVerdion);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"checkupgrade", @"action", @1, @"ostype", currentVerdion, @"currver", nil];
    
    [manager GET:[BaseURL stringByAppendingString:[NSString stringWithFormat:@"/api/%@/version/", role]] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            
            if ([responseObject[@"version"] isEqualToString:@""] && [responseObject[@"version"] isEqual:[NSNull null]]) {
                

                // 如果是空不做处理
                return;
                
            }else {
                // 版本不同
                if (![responseObject[@"version"] isEqualToString:APP_VERSION]) {

                    
                    if ([responseObject[@"force"] isEqual:@0]) {
                        
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"版本更新提示" message:[NSString stringWithFormat:@"发现新版本:%@,是否升级?", responseObject[@"version"]] preferredStyle:UIAlertControllerStyleAlert];
                        [alertVC addAction:[UIAlertAction actionWithTitle:@"不了" style:UIAlertActionStyleCancel handler:nil]];
                        
                        [SYS_CACHE setObject:[NSDate date] forKey:@"date"];
                        
                        [alertVC addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            // 前往更新
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseObject[@"url"]]];
                        
                            
                        }]];
                        
                        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
                        
                    }else {
                    
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"版本更新提示" message:[NSString stringWithFormat:@"发现新版本:%@,该版本有重要升级,请您升级,否则可能会导致程序某些功能无法正常使用!", responseObject[@"version"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alertVC addAction:[UIAlertAction actionWithTitle:@"不了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                            [SYS_CACHE removeObjectForKey:@"date"];
                            [SYS_CACHE setObject:@"yes" forKey:@"force"];
                            
                            // 在此杀掉程序
                            int i = 0;
                            exit(i);
                            
                            
                        }]];
                        
                        [alertVC addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            // 前往更新
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseObject[@"url"]]];
                            
                            [SYS_CACHE removeObjectForKey:@"date"];
                            [SYS_CACHE removeObjectForKey:@"force"];
                            
                        }]];
                        
                        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
                        

                    
                    }
                    
                }
                
            
            }

        
        }else {
        
            NSLog(@"%@", responseObject[@"msg"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}




//友盟相关内容统计
-(void)initUmeng:(NSDictionary *)launchOptions
{
    //1.注册APNS推送通知
    if (SYS_VERSION >= 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert categories:nil]];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
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
    [UMessage setLogEnabled:YES];
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"56c2e28167e58ef1b1002dad";
    UMConfigInstance.secret = @"lfs5co6sanr4atqymxthof271dross34";
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark - 获取所有学生列表
// 获取所有学生列表
- (void)getStuList {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getstudents", @"action", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_GETALLSTULIST_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        // 创建数据表
        [[StuDataBase shareStuDataBase] deleteStuTable];
        
        if ([responseObject[@"retcode"] integerValue] == 0) {
            
            for (NSDictionary *dic in responseObject[@"allstudents"]) {
                StudentEntity *model = [[StudentEntity alloc] init];
                [model initStudentWithDic:dic];
                [((AppDelegate*)SYS_DELEGATE).stuListArr addObject:model];
                // 插入学生数据
                [[StuDataBase shareStuDataBase] insertStudent:model];
            }
            
            for (NSDictionary *dic in responseObject[@"classes"]) {
                StuClassEntity *model = [[StuClassEntity alloc] init];
                [model initStuClassWithDic:dic];
                [[StuDataBase shareStuDataBase] insertStuClass:model];
            }
            
            for (NSDictionary *dic in responseObject[@"groups"]) {
                StuGroupEntity *model = [[StuGroupEntity alloc] init];
                [model initStuGroupWithDic:dic];
                [[StuDataBase shareStuDataBase] insertStuGroup:model];
            }
            
            [SYS_CACHE setObject:[NSDate date] forKey:@"getDate"];
            
        }else {
        
            NSLog(@"%@", responseObject[@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark -UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_tabBar != nil) {
            [self pushSwitch:_tabBar.selectedIndex];
        }
    }
}

-(void)pushSwitch:(NSInteger)index
{
    UINavigationController * vc = [_tabBar.viewControllers objectAtIndex:index];
    switch ([YjyxOverallData sharedInstance].pushType) {
        case 1:{
            YjyxWorkPreviewViewController *result = [[YjyxWorkPreviewViewController alloc] init];
            result.previewRid = [YjyxOverallData sharedInstance].previewRid;
            result.title = @"作业预览";
            [result setHidesBottomBarWhenPushed:YES];
            [vc pushViewController:result animated:YES];
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
        }
            break;
        case 2:{
            YjyxMicroClassViewController *result = [[YjyxMicroClassViewController alloc] init];
            result.previewRid = [YjyxOverallData sharedInstance].previewRid;
            result.title = @"微课预览";
            [result setHidesBottomBarWhenPushed:YES];
            [vc pushViewController:result animated:YES];
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
        }
            break;
        case 3:{
            ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
            result.taskResultId = [YjyxOverallData sharedInstance].historyId;
            result.title = @"结果详情";
            [result setHidesBottomBarWhenPushed:YES];
            [vc pushViewController:result animated:YES];
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
            break;
            
        }
            break;
        case 4:{
            ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
            result.taskResultId = [YjyxOverallData sharedInstance].historyId;
            [result setHidesBottomBarWhenPushed:YES];
            result.title = @"结果详情";
            [vc pushViewController:result animated:YES];
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
            break;
        }
            break;
        default:
            break;
    }
    
}



@end
