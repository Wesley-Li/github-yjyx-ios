//
//  AutoLoginViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "AutoLoginViewController.h"
#import "LoginViewController.h"
#import "TeacherEntity.h"
#import "OneStudentEntity.h"
@interface AutoLoginViewController ()

@end

@implementation AutoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)autoLoginWithRole:(NSString *)role username:(NSString *)username password:(NSString *)password {

    [self.view makeToastActivity:SHOW_CENTER];
    NSString *devicetoken = ((AppDelegate*)SYS_DELEGATE).deviceToken;
    NSString *model = [[UIDevice currentDevice] model];
    
    
    // 判断身份
    if ([role isEqualToString:@"parents"]) {
        // 家长的自动登录实现
        NSString *npSessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"NPSessionID"];
        NSDictionary *dic;
        if ([npSessionID length]) {
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",password,@"password",@"1",@"ostype",model,@"description",devicetoken,@"devicetoken",  npSessionID, @"sessionid", nil];
        }else {
        
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",password,@"password",@"1",@"ostype",model,@"description",devicetoken,@"devicetoken",nil];
        }
        
        [[YjxService sharedInstance] parentsLogin:dic autoLogin:YES withBlock:^(id result,NSError *error){
            [self.view hideToastActivity];
            if (result != nil) {
                NSLog(@"%@, %@, %@ - atuologin", result, result[@"msg"], result[@"reason"]);
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [(AppDelegate *)SYS_DELEGATE fillViews];
                    [YjyxOverallData sharedInstance].parentInfo = [ParentEntity wrapParentWithdic:result];
                    [YjyxOverallData sharedInstance].parentInfo.phone = username;
                    [self asyncGetChildrenStatistic];
                }else{
                    NSLog(@"%@", result[@"msg"]);
                    LoginViewController *loginView = [[LoginViewController alloc] init];
                    UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                    navigation.navigationBar.hidden = YES;
                    [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }else{
                LoginViewController *loginView = [[LoginViewController alloc] init];
                UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                navigation.navigationBar.hidden = YES;
                [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];

        
    }else if ([role isEqualToString:@"teacher"]) {
        // 老师的自动登录实现
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",@"1",@"ostype",model,@"description",devicetoken,@"devicetoken", nil];
        [[YjxService sharedInstance] teacherLogin:dic autoLogin:YES withBlock:^(id result, NSError *error) {
            [self.view hideToastActivity];
            if (result != nil) {
                NSLog(@"%@, %@, %@- atuologin", result, result[@"msg"], result[@"reason"]);
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [(AppDelegate *)SYS_DELEGATE fillViews];
                    
                    // 开启GCD
//                    dispatch_resume(((AppDelegate*)SYS_DELEGATE).timer);
                    
                    [YjyxOverallData sharedInstance].teacherInfo = [TeacherEntity wrapTeacherWithDic:result];
                    
                }else {
                    LoginViewController *loginView = [[LoginViewController alloc] init];
                    UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                    navigation.navigationBar.hidden = YES;
                    [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                    NSLog(@"未登录------,%@", result[@"msg"]);
                    
                }
            }else {
                
                LoginViewController *loginView = [[LoginViewController alloc] init];
                UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                navigation.navigationBar.hidden = YES;
                [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                NSLog(@"未登录+++++++++++");
            
            }
        }];
    }else {
        // 学生的自动登录实现,此处保留
        NSString *nsSessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"NSSessionID"];
        NSDictionary *dic;
        if ([nsSessionID length]) {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",@"1",@"ostype",model,@"description",devicetoken,@"devicetoken", nsSessionID,@"sessionid", nil];
        }else {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",@"1",@"ostype",model,@"description",devicetoken,@"devicetoken", nil];
        }
        
        [[YjxService sharedInstance] studentLogin:dic autoLogin:YES withBlock:^(id result, NSError *error) {
            [self.view hideToastActivity];
            if (result != nil) {
                NSLog(@"%@, %@, %@- atuologin", result, result[@"msg"], result[@"reason"]);
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [YjyxOverallData sharedInstance].studentInfo = [OneStudentEntity studentEntityWithDict:result];
                    [(AppDelegate *)SYS_DELEGATE fillViews];
                    
                    // 开启GCD
                    //                    dispatch_resume(((AppDelegate*)SYS_DELEGATE).timer);
                    
                    
                    
                }else {
                    LoginViewController *loginView = [[LoginViewController alloc] init];
                    UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                    navigation.navigationBar.hidden = YES;
                    [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                    
                }
            }else {
                
                LoginViewController *loginView = [[LoginViewController alloc] init];
                UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                navigation.navigationBar.hidden = YES;
                [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                
            }
        }];
    
    }
}


- (void)asyncGetChildrenStatistic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        for (ChildrenEntity *entity in [YjyxOverallData sharedInstance].parentInfo.childrens) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"question",@"action",entity.cid,@"cid",nil];
            [[YjxService sharedInstance] asyncGetChildrenachievement:dic withBlock:^(id result, NSError *error){
            }];
        }
        
        for (ChildrenEntity *entity in [YjyxOverallData sharedInstance].parentInfo.childrens) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"task",@"action",entity.cid,@"cid",nil];
            [[YjxService sharedInstance] asyncGetChildrenachievement:dic withBlock:^(id result, NSError *error){
            }];
        }
        
        for (ChildrenEntity *entity in [YjyxOverallData sharedInstance].parentInfo.childrens) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"yjlesson",@"action",entity.cid,@"cid",nil];
            [[YjxService sharedInstance] asyncGetChildrenachievement:dic withBlock:^(id result, NSError *error){
            }];
        }
    });
}


/*

- (void)autoLogin:(NSString *)username password:(NSString *)password
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSString *devicetoken = ((AppDelegate*)SYS_DELEGATE).deviceToken;
    NSString *model = [[UIDevice currentDevice] model];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",[password md5],@"password",@"1",@"ostype",model,@"description",devicetoken,@"devicetoken",nil];
    
    [[YjxService sharedInstance] parentsLogin:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [(AppDelegate *)SYS_DELEGATE fillViews];
                [YjyxOverallData sharedInstance].parentInfo = [ParentEntity wrapParentWithdic:result];
                [YjyxOverallData sharedInstance].parentInfo.phone = username;
            }else{
                LoginViewController *loginView = [[LoginViewController alloc] init];
                UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
                navigation.navigationBar.hidden = YES;
                [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            LoginViewController *loginView = [[LoginViewController alloc] init];
            UINavigationController* navigation = [[NavRootViewController alloc] initWithRootViewController:loginView];
            navigation.navigationBar.hidden = YES;
            [(AppDelegate *)SYS_DELEGATE window].rootViewController =navigation;
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
