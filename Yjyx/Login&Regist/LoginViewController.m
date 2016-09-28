//
//  LoginViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "RegistOneViewController.h"
#import "StudentEntity.h"
#import "StuClassEntity.h"
#import "StuGroupEntity.h"
#import "StuDataBase.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ForgetOneViewController.h"
#import "ForgetTwoViewController.h"
#import "OneStudentEntity.h"

@interface LoginViewController ()
{
    UIView *serverView;
    UITextField *serverTextField;
}

@property (nonatomic, strong) NSMutableArray *stuListArr;


@end

@implementation LoginViewController

- (NSMutableArray *)stuListArr {

    if (!_stuListArr) {
        self.stuListArr = [NSMutableArray array];
    }
    return _stuListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    if(self.roleType == 1){
        ((AppDelegate*)SYS_DELEGATE).role = @"teacher";
        [_parentsBtn setSelected:NO];
        [_teacherBtn setSelected:YES];
        [_stuBtn setSelected:NO];
    }else if (self.roleType == 2){
        ((AppDelegate*)SYS_DELEGATE).role = @"student";
        [_parentsBtn setSelected:NO];
        [_teacherBtn setSelected:NO];
        [_stuBtn setSelected:YES];
    }else{
    // 身份选择默认是家长
    ((AppDelegate*)SYS_DELEGATE).role = @"parents";
    [_parentsBtn setSelected:YES];
    [_teacherBtn setSelected:NO];
    [_stuBtn setSelected:NO];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _uesrNameTF.delegate = self;
    _passWordTF.delegate = self;
    [_uesrNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_passWordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    if (IS_INCH_3_5) {
        CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat ty = - rect.size.height+40;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 +ty);
        }];
    }
    else
    {
        CGFloat ty = - 100;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 +ty);
            
        }];
    }
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    if (IS_INCH_3_5) {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 );
        }];
    }
    else
    {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 );
        }];
    }
}
#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == serverTextField) {
        [YjyxOverallData sharedInstance].baseUrl = textField.text;
        [serverView removeFromSuperview];
        serverView = nil;
    }
    [textField resignFirstResponder];
    return YES;
}
// 限制输入的长度
- (void)textFieldDidChange:(UITextField *)textField
{
    
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    
}

-(void)clicked:(id)sender
{
    [self.view hideKeyboard];
}

// 点击老师按钮
- (IBAction)teacherBtnClicked:(id)sender {

    [SYS_CACHE removeObjectForKey:@"AutoLogoin"];
    [_teacherBtn setSelected:YES];
    _uesrNameTF.placeholder = @"用户名";
    ((AppDelegate*)SYS_DELEGATE).role = @"teacher";

    [_parentsBtn setSelected:NO];
    [_stuBtn setSelected:NO];

    
}

- (IBAction)parentsBtnClicked:(id)sender {

    [SYS_CACHE removeObjectForKey:@"AutoLogoin"];
    [_parentsBtn setSelected:YES];
    _uesrNameTF.placeholder = @"用户名";
    ((AppDelegate*)SYS_DELEGATE).role = @"parents";
    [_teacherBtn setSelected:NO];
    [_stuBtn setSelected:NO];

}

- (IBAction)stuBtnClicked:(id)sender {

    [SYS_CACHE removeObjectForKey:@"AutoLogoin"];
    [_stuBtn setSelected:YES];
    _uesrNameTF.placeholder = @"用户名";
    ((AppDelegate*)SYS_DELEGATE).role = @"student";
    [_parentsBtn setSelected:NO];
    [_teacherBtn setSelected:NO];

    
}


-(IBAction)loginBtnClicked:(id)sender
{
    if ([((AppDelegate*)SYS_DELEGATE).role isEqualToString:@"none"]) {
        [self.view makeToast:@"请选择身份" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
        if (_uesrNameTF.text.length == 0||_passWordTF.text.length == 0) {
            [self.view makeToast:@"请输入用户名或者密码" duration:1.0 position:SHOW_CENTER complete:nil];
        }else{
            [self.view makeToastActivity:SHOW_CENTER];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_uesrNameTF.text,@"username",_passWordTF.text,@"password",@"1",@"ostype",((AppDelegate*)SYS_DELEGATE).deviceToken,@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
            
            // 调用登录接口
            if ([((AppDelegate*)SYS_DELEGATE).role isEqualToString:@"parents"]) {
                // 家长
                [[YjxService sharedInstance] parentsLogin:dic autoLogin:NO withBlock:^(id result,NSError *error){
                    [self.view hideToastActivity];
                    NSLog(@"%@, %@, %@--login1", result, result[@"msg"], result[@"reason"]);
                    if (result != nil) {
                        if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                           
                            [YjyxOverallData sharedInstance].parentInfo = [ParentEntity wrapParentWithdic:result];
                            [YjyxOverallData sharedInstance].parentInfo.phone = _uesrNameTF.text;
                            
                            [self asyncGetChildrenStatistic];
                            // 在此处存储用户信息
                            
                            NSString *desPassWord = [_passWordTF.text des3:kCCEncrypt withPass:@"12345678asdf"];
                            
                            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:((AppDelegate*)SYS_DELEGATE).role, @"role", _uesrNameTF.text,@"username",desPassWord,@"password", nil];
                            [SYS_CACHE setObject:dic forKey:@"AutoLogoin"];
                            [SYS_CACHE synchronize];
                             [(AppDelegate *)SYS_DELEGATE fillViews];
                        }else{
                            if ([result[@"msg"] length] > 20) {
                                [self.view makeToast:@"您的网络可能不太好,请重试!" duration:1.0 position:SHOW_CENTER complete:nil];

                            }else {
                                
                                [self.view makeToast:result[@"msg"]duration:1.0 position:SHOW_CENTER complete:nil];
                            
                            }
                        }
                    }else{
                        if (error.code == -1009) {
                            [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                            return;
                        }
                        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];
                    }
                }];
                
            }else if ([((AppDelegate*)SYS_DELEGATE).role isEqualToString:@"teacher"]){
                // 老师
                // 参数字典
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_uesrNameTF.text,@"username",_passWordTF.text,@"password",@"1",@"ostype",((AppDelegate*)SYS_DELEGATE).deviceToken,@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
                
                [[YjxService sharedInstance] teacherLogin:dic autoLogin:NO withBlock:^(id result, NSError *error) {
                    

                    NSLog(@"%@, %@, %@--login2", result, result[@"msg"], result[@"reason"]);
                    [self.view hideToastActivity];
                    if (result != nil) {
                        
                        if ([result[@"retcode"] integerValue] == 0) {
                            
                            
                            [YjyxOverallData sharedInstance].teacherInfo = [TeacherEntity wrapTeacherWithDic:result];
                            
//                            [YjyxOverallData sharedInstance].teacherInfo.name = _uesrNameTF.text;
                            NSString *desPassWord = [_passWordTF.text des3:kCCEncrypt withPass:@"12345678asdf"];
                            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:((AppDelegate*)SYS_DELEGATE).role, @"role", _uesrNameTF.text,@"username",desPassWord,@"password", nil];
                            
                            [SYS_CACHE setObject:dic forKey:@"AutoLogoin"];
                            [SYS_CACHE synchronize];
                            [(AppDelegate *)SYS_DELEGATE fillViews];
                             // GCD写定时器启动
//                            dispatch_resume(((AppDelegate*)SYS_DELEGATE).timer);
//
                        }else {
                            
                            if ([result[@"msg"] length] > 20) {
                                [self.view makeToast:@"您的网络可能不太好,请重试!" duration:1.0 position:SHOW_CENTER complete:nil];
                                
                            }else {
                                
                                [self.view makeToast:result[@"msg"]duration:1.0 position:SHOW_CENTER complete:nil];
                                
                            }

                        }
                    }else {
                        
                        if (error.code == -1009) {
                            [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                            return;
                        }
                        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];
                    }
                    
                    
                }];
                
            }else if ([((AppDelegate*)SYS_DELEGATE).role isEqualToString:@"student"]){
                // 学生
//                [self.view makeToast:@"正在建设中,敬请期待" duration:1.0 position:SHOW_CENTER complete:nil];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_uesrNameTF.text,@"username",_passWordTF.text,@"password",@"1",@"ostype",((AppDelegate*)SYS_DELEGATE).deviceToken,@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
               
                [[YjxService sharedInstance] studentLogin:dic autoLogin:NO withBlock:^(id result, NSError *error){
                     [self.view hideToastActivity];
                    NSLog(@"%@, %@, %@--login3", result, result[@"msg"], result[@"reason"]);
                    if (result != nil) {
                        
                        if ([result[@"retcode"] integerValue] == 0) {
                           
                            
                            [YjyxOverallData sharedInstance].studentInfo = [OneStudentEntity studentEntityWithDict:result];
                            NSLog(@"%@--", [YjyxOverallData sharedInstance].studentInfo.avatar_url);
                            //                            [YjyxOverallData sharedInstance].teacherInfo.name = _uesrNameTF.text;
                            NSString *desPassWord = [_passWordTF.text des3:kCCEncrypt withPass:@"12345678asdf"];
                            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:((AppDelegate*)SYS_DELEGATE).role, @"role", _uesrNameTF.text,@"username",desPassWord,@"password", nil];
                            
                            [SYS_CACHE setObject:dic forKey:@"AutoLogoin"];
                            [SYS_CACHE synchronize];
                             [(AppDelegate *)SYS_DELEGATE fillViews];
                            
                            // GCD写定时器启动
                            //                            dispatch_resume(((AppDelegate*)SYS_DELEGATE).timer);
                            //
                        }else {
                            
                            if ([result[@"msg"] length] > 20) {
                                [self.view makeToast:@"您的网络可能不太好,请重试!" duration:1.0 position:SHOW_CENTER complete:nil];
                                
                            }else {
                                
                                [self.view makeToast:result[@"msg"]duration:1.0 position:SHOW_CENTER complete:nil];
                                
                            }
                            
                        }
                    }else {
                        
                        if (error.code == -1009) {
                            [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                            return;
                        }
                        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];
                    }

                }];
            }
            
        }
        
    }
}

-(IBAction)registBtnClicked:(id)sender
{
    RegistOneViewController *registView = [[RegistOneViewController alloc] init];
    [self.navigationController pushViewController:registView animated:YES];
    
}



-(IBAction)forgetPassWord:(UIButton *)sender
{
//    ForgetOneViewController *vc = [[ForgetOneViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    sender.enabled = NO;
   
    [SVProgressHUD showWithStatus:@"加载中..."];
    if([_uesrNameTF.text isEqualToString:@""]){
        ForgetOneViewController *vc = [[ForgetOneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [SVProgressHUD dismiss];
        sender.enabled = YES;
        return;
    }
    NSString *str = _uesrNameTF.text;
    if (self.parentsBtn.selected) {
        str = [NSString stringWithFormat:@"4*#*_%@", _uesrNameTF.text];
    }
    NSLog(@"%@", str);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:str,@"username",nil];
    [[YjxService sharedInstance] getUserPhone:dic withBlock:^(id result, NSError *error){//验证验证码
//        [self.view hideToastActivity];
        
        if (result) {
//            NSLog(@"%@", result);
//            NSLog(@"%@", result[@"reason"]);
//            
//            if([result[@"msg"] isEqualToString:@"操作过快, 稍后再试"]){
//                [SVProgressHUD dismiss];
//                [self.view makeToast:@"操作过快, 稍后再试" duration:1.0 position:SHOW_CENTER complete:nil];
//                sender.enabled = YES;
//                return ;
//            }
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
             
                ForgetTwoViewController *vc = [[ForgetTwoViewController alloc] init];
                vc.phoneStr = [result objectForKey:@"phone"];
                vc.accountText.text = [result objectForKey:@"phone"];
                vc.userName = str;
                vc.roleType = _parentsBtn.selected ? 1 : 0;
                [self.navigationController pushViewController:vc animated:YES];
                sender.enabled = YES;
                [SVProgressHUD dismiss];
            }else{
//                [self.view makeToast:@"请输入正确的账号" duration:1.0 position:SHOW_CENTER complete:nil];
                [SVProgressHUD showWithStatus:@"帐号不存在"];
                [SVProgressHUD dismiss];
                ForgetOneViewController *vc = [[ForgetOneViewController alloc] init];
                sender.enabled = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            if (error.code == -1009) {
                [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                [SVProgressHUD dismiss];
                sender.enabled = YES;
                return;
            }
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];
            sender.enabled = YES;
            [SVProgressHUD dismiss];
        }
    }];
    
}

- (void)asyncGetChildrenStatistic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        //,@"20",@"count"
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
