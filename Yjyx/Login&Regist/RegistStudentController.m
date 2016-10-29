//
//  RegistStudentController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/30.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "RegistStudentController.h"
#import "OneStudentEntity.h"
#import "YjyxOverallData.h"
#import "AutoLoginViewController.h"
@interface RegistStudentController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *loginNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UITextField *conFirmpswTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *recvCodeBtn;

@property (assign, nonatomic) NSInteger flag;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger second;

@property (assign, nonatomic) NSInteger isExistFlag;
@end
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@implementation RegistStudentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.view.backgroundColor = COMMONCOLOR;
    self.sureBtn.layer.cornerRadius = 20;
    _second = 60;
    self.navigationItem.title = @"学生注册";
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@邀请码", self.attrArr[0], self.attrArr[1], self.attrArr[2]];
    
    // 设置导航栏属性
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(28.0, 222.0, 182.0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = barItem;
    
    //  键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // 设置textField属性
    [_loginNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_pswTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_conFirmpswTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_realNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _conFirmpswTextField.delegate = self;
    _pswTextField.delegate = self;
    _loginNameTextField.delegate = self;
}
-  (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", self.navigationController.childViewControllers);
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 私有方法
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
// 限制输入的长度
- (void)textFieldDidChange:(UITextField *)textField
{
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag)
    {
        [self.view makeToast:@"不能添加表情符号" duration:1.0 position:SHOW_CENTER complete:nil];
        textField.text = [textField.text substringToIndex:textField.text.length -2];
        
    }
       if ([textField isEqual:_loginNameTextField]){
    
           if (textField.text.length > 15) {
                textField.text = [textField.text substringToIndex:15];
               [self.view makeToast:@"登录名最多只能15位" duration:1.0 position:SHOW_CENTER complete:nil];
          }
     }
    if ([textField isEqual:_pswTextField]){
        if (textField.text.length > 20){
            textField.text = [textField.text substringToIndex:20];
            [self.view makeToast:@"密码的长度不能大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }

    if([textField isEqual:_pswTextField] || [textField isEqual:_conFirmpswTextField] || [textField isEqual:_loginNameTextField] || [textField isEqual:_realNameTextField]){
        if([textField.text containsString:@" "] && ![textField isEqual:_realNameTextField]){
        [self.view makeToast:@"不能含有空格,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
        if ([textField isEqual:_realNameTextField] ) {
            NSString *toBeString = textField.text;
            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
            if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [textField markedTextRange];
                //获取高亮部分
                UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (!position) {
                    if (toBeString.length > 10) {
                        textField.text = [toBeString substringToIndex:10];
                        [self.view makeToast:@"真实姓名的长度不能大于10位" duration:1.0 position:SHOW_CENTER complete:nil];


                    }
                    
                }
            }else{
                if (textField.text.length > 10) {
                    
                    textField.text = [textField.text substringToIndex:10];
                    [self.view makeToast:@"真实姓名的长度不能大于10位" duration:1.0 position:SHOW_CENTER complete:nil];
                }
                


            }
        }

    }else if ([textField isEqual:_phoneTextField]) {
        
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            
        }
            
        
    }
}

// 获取验证码
-(IBAction)getRegisterCode:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (_phoneTextField.text.length == 0 || _phoneTextField.text.length < 11) {
        [self.view makeToast:@"请输入正确的手机号码" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if(_isExistFlag == 1000){
        [self.view makeToast:@"用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
        _isExistFlag = 0;
    }else if(_isExistFlag == 500){
        //发送注册码按钮失效，防止频繁请求
        [_recvCodeBtn setEnabled:false];
        [self checkCodeTimeout];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        
        NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",_phoneTextField.text];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneTextField.text,@"target",[sign md5],@"sign",@"MREGISTER",@"stype",nil];
        [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    //                _timeLabel.backgroundColor = RGBACOLOR(229.0, 230.0, 231.0, 1);
                    
                    
                }else{
                    
                    if ([result[@"msg"] isEqualToString:@"ratelimitted"]) {
                        [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                    }else {
                        [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                    }
                }
            }else{
                [self.view makeToast:@"电话号码不存在" duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];

    }else{
        //发送注册码按钮失效，防止频繁请求
        [_recvCodeBtn setEnabled:false];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
        pamar[@"action"] = @"checkuserexist";
        pamar[@"username"] =  _loginNameTextField.text;
        
        [mgr GET:[BaseURL stringByAppendingString:USERNAME_ISEXIST_CONNECT_GET] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if([responseObject[@"retcode"] isEqual: @0]){
                if ([responseObject[@"exist"] isEqual: @1]) {
                    [self.view makeToast:@"此用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
                   
                }else{
                    //发送注册码按钮失效，防止频繁请求
                    [_recvCodeBtn setEnabled:false];
                    [self checkCodeTimeout];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                    
                    
                    NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",_phoneTextField.text];
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneTextField.text,@"target",[sign md5],@"sign",@"MREGISTER",@"stype",nil];
                    [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
                        [self.view hideToastActivity];
                        if (result) {
                            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                                //                _timeLabel.backgroundColor = RGBACOLOR(229.0, 230.0, 231.0, 1);
                                
                                
                            }else{
                                
                                if ([result[@"msg"] isEqualToString:@"ratelimitted"]) {
                                    [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                                }else {
                                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                                }
                            }
                        }else{
                            [self.view makeToast:@"电话号码不存在" duration:1.0 position:SHOW_CENTER complete:nil];
                        }
                    }];

                }
            }else{
                [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
        }];

    }
    
}
- (void)checkCodeTimeout
{
    _timeLabel.text = [NSString stringWithFormat:@"%ld",(long)_second--];
    if (_second < 0) {
        [self resetTimer];
    }
}
// 重置定时器
-(void)resetTimer
{
    _second = 60;
   
    [_recvCodeBtn setEnabled:YES];
    
    _timeLabel.text = @"获取验证码";
//    timeLb.backgroundColor = RGBACOLOR(19.0, 141.0, 101.0, 1);
    
    [_timer invalidate];
    _timer = nil;
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    if([_loginNameTextField isFirstResponder] || [_pswTextField isFirstResponder] || [_conFirmpswTextField isFirstResponder] || [_realNameTextField isFirstResponder]){
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
        return;
    }
    
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

- (IBAction)goSureBtnClick:(UIButton *)sender {
    
    if (_loginNameTextField.text.length == 0||_pswTextField.text.length == 0||_conFirmpswTextField.text.length == 0||_realNameTextField.text.length == 0||_codeTextField.text.length == 0 || _phoneTextField.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }else if(_pswTextField.text.length < 6 || _pswTextField.text.length > 20 || _conFirmpswTextField.text.length < 6 || _conFirmpswTextField.text.length > 20){
        [self.view makeToast:@"密码长度不能小于6位或大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }else if(_loginNameTextField.text.length < 2){
        [self.view makeToast:@"登录名太短" duration:0.5 position:SHOW_CENTER complete:nil];
        return;
    }else if(![_pswTextField.text isEqualToString:_conFirmpswTextField.text]){
        [self.view makeToast:@"两次输入的密码不一样" duration:0.5 position:SHOW_CENTER complete:nil];
        return;
    }else{
        [SVProgressHUD showWithStatus:@"正在注册"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneTextField.text,@"target",_codeTextField.text,@"code",@"MREGISTER",@"stype",nil];
        [[YjxService sharedInstance] checkOutVerfirycode:dic withBlock:^(id result, NSError *error){//验证验证码
            [self.view hideToastActivity];
            [SVProgressHUD dismiss];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [self regist];//注册
                }else{
                    NSString *showStr = result[@"msg"];
                    if(result[@"reason"] != nil){
                        showStr = result[@"reason"];
                    }
                    [self.view makeToast:showStr duration:1.0 position:SHOW_CENTER complete:nil];
//                    [self resetTimer];
                }
            }else{
                 [SVProgressHUD dismiss];
                if (error.code == -1009) {
                    [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                    return;
                }
                [self.view makeToast:error.localizedDescription duration:3.0 position:SHOW_CENTER complete:nil];
            }
//            [self resetTimer];
        }];
        
    }


}
- (void)regist
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"submit";
    pamar[@"code"] = _attrArr[3];
    pamar[@"username"] = self.loginNameTextField.text;
    pamar[@"realname"] = self.realNameTextField.text;
    pamar[@"phonenumber"] = self.phoneTextField.text;
    pamar[@"password"] = self.pswTextField.text;
    pamar[@"passwordConfirm"] = self.conFirmpswTextField.text;
    pamar[@"smscode"] = self.codeTextField.text;
    pamar[@"ostype"] = @1;
    pamar[@"devicetoken"] = ((AppDelegate*)SYS_DELEGATE).deviceToken;
    pamar[@"description"] = [[UIDevice currentDevice] model];
    
    [mgr POST:[BaseURL stringByAppendingString:@"/api/student/mobile/register/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if([responseObject[@"retcode"] isEqual:@0]){
            NSString *stusession = responseObject[@"sessionid"];
            [SYS_CACHE setObject:stusession forKey:@"NSSessionID"];
            OneStudentEntity *oneStudent = [OneStudentEntity studentEntityWithDict:responseObject];
            [YjyxOverallData sharedInstance].studentInfo = oneStudent;
            NSString *desPassWord = [_pswTextField.text des3:kCCEncrypt withPass:@"12345678asdf"];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"student", @"role", _loginNameTextField.text,@"username",desPassWord,@"password", nil];
            [SYS_CACHE setObject:dic forKey:@"AutoLogoin"];
            
            //  在此处储存用户名
            NSMutableDictionary *dic1 = (NSMutableDictionary *)[SYS_CACHE objectForKey:@"LoginUserName"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic1];
            [dict setValue:_loginNameTextField.text forKey:@"student"];
            NSLog(@"%@", dic1);
            [SYS_CACHE setObject:dict forKey:@"LoginUserName"];
            
            
            AutoLoginViewController *autolog = [[AutoLoginViewController alloc] init];
            [autolog autoLoginWithRole:dic[@"role"] username:dic[@"username"] password:pamar[@"password"]];
            
        }else if ([responseObject[@"retcode"] isEqual:@6]){
            [self.view makeToast:@"此班级人数已达到上限" duration:0.5 position:SHOW_CENTER complete:nil];
        }else if ([responseObject[@"retcode"] isEqual:@7]){
            [self.view makeToast:@"此手机号已被注册" duration:0.5 position:SHOW_CENTER complete:nil];
        }else{
            NSString *showStr = responseObject[@"msg"];
            if(responseObject[@"reason"] != nil){
                showStr = responseObject[@"reason"];
            }
            [self.view makeToast:showStr duration:0.5 position:SHOW_CENTER complete:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}
#pragma mark - UITextField的代理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_loginNameTextField]){
        if (textField.text.length < 2) {
            [self.view makeToast:@"登录名过短" duration:0.5 position:SHOW_CENTER complete:nil];
        }else{
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
            pamar[@"action"] = @"checkuserexist";
            pamar[@"username"] =  _loginNameTextField.text;
            
            [mgr GET:[BaseURL stringByAppendingString:USERNAME_ISEXIST_CONNECT_GET] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if([responseObject[@"retcode"] isEqual: @0]){
                    if ([responseObject[@"exist"] isEqual: @1]) {
                        [self.view makeToast:@"此用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
//                        sender.enabled = YES;
                        _isExistFlag = 1000;
                    }else{
                        _isExistFlag = 500;
                    }
                }else{
                    _isExistFlag = 0;
                    [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                _isExistFlag = 0;
                [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
            }];
        }
        return;
    }else{
        if(_conFirmpswTextField.text.length == 0 || _pswTextField.text.length == 0){
            return;
        }
        if(textField.text.length < 6){
            [self.view makeToast:@"密码长度不能小于6位" duration:0.5 position:SHOW_CENTER complete:nil];
            return;
   }
   if(![self.pswTextField.text isEqualToString:self.conFirmpswTextField.text]){
        [self.view makeToast:@"两次密码输入不一样" duration:0.5 position:SHOW_CENTER complete:nil];
    }
}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.loginNameTextField]){
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            [self.view makeToast:@"用户名不能输入中文" duration:1.0 position:SHOW_CENTER complete:nil];
        }
        return  canChange;
    }
    return YES;
    
}

@end
