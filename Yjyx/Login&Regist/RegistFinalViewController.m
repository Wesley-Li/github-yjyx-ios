//
//  RegistFinalViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "RegistFinalViewController.h"
#import "AutoLoginViewController.h"

@interface RegistFinalViewController ()

@property (assign, nonatomic) NSInteger flag;
@property (strong, nonatomic) NSString *phoneNumStr;
@end

@implementation RegistFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 60;
    _flag = 1000;
    titleLb.text = [NSString stringWithFormat:@"%@%@的邀请码",_school,_childrenEntity.name];
    parentNameText.placeholder = @"家长真实姓名";
    parentPasswordText.placeholder = @"登录密码";
    relationText.placeholder = [NSString stringWithFormat:@"是%@的(称谓,譬如父亲,母亲...)",_childrenEntity.name];
    phoneText.placeholder = @"手机号码(作为登录账户)";
    codeText.placeholder = @"4位验证码";
    phoneText.delegate  = self;
    parentPasswordText.delegate  = self;
    confirmpwdField.delegate  = self;
    [parentNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [relationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [parentPasswordText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [confirmpwdField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
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
    if([textField.text containsString:@" "]){
        [self.view makeToast:@"不能含有空格,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
        textField.text = nil;
    }else if ([textField isEqual:phoneText]) {

        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        
    }else if ([textField isEqual:parentNameText] || [textField isEqual:relationText]) {
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
                    [self.view makeToast:@"输入的长度不能大于10位" duration:1.0 position:SHOW_CENTER complete:nil];
                }
                
            }
            
        }else{
            if(textField.text.length > 10){
            textField.text = [textField.text substringToIndex:10];
            [self.view makeToast:@"输入的长度不能大于10位" duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }

    }else if ([textField isEqual:parentPasswordText] || [textField isEqual:confirmpwdField]){
        if (textField.text.length > 20){
            textField.text = [textField.text substringToIndex:20];
            [self.view makeToast:@"密码的长度不能大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:phoneText]){
        if([textField.text isEqualToString:self.phoneNumStr]){
            return;
        }
        self.phoneNumStr = textField.text;
       AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
       NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
       pamar[@"action"] = @"checkuserexist";
       pamar[@"username"] = [NSString stringWithFormat:@"4*#*_%@", textField.text];
        
        [mgr GET:[BaseURL stringByAppendingString:USERNAME_ISEXIST_CONNECT_GET] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if([responseObject[@"retcode"] isEqual: @0]){
                NSLog(@"%@", responseObject);
                if ([responseObject[@"exist"] isEqual: @1]) {
                    [self.view makeToast:@"此用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
                    _flag = 1;
                }else if([responseObject[@"exist"] isEqual: @0]){
                _flag = 0;
            }
            }else{
                if ([responseObject[@"msg"] isEqualToString:@"ratelimitted"]) {
                [self.view makeToast:@"操作过快" duration:0.5 position:SHOW_CENTER complete:nil];
            }else {
                
                [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
                
            }
            }
         
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];

        }];
    }else{
        if(parentPasswordText.text.length == 0 && confirmpwdField.text.length == 0){
            return;
        }
        if(textField.text.length < 6){
            
            [self.view makeToast:@"密码长度不能小于6位" duration:0.5 position:SHOW_CENTER complete:nil];
            return;
        }
        if(parentPasswordText.text.length == 0 || confirmpwdField.text.length == 0){
            return;
        }
        if(![parentPasswordText.text isEqualToString:confirmpwdField.text]){
            [self.view makeToast:@"两次密码输入不一样" duration:0.5 position:SHOW_CENTER complete:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 获取验证码
-(IBAction)getRegisterCode:(UIButton *)sender
{
//    [self textFieldDidEndEditing:phoneText];
    
    if(_flag == 1000){
        if (phoneText.text.length != 11) {
            [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:SHOW_CENTER complete:nil];
            return;
        }
        //发送注册码按钮失效，防止频繁请求
        [verifyBtn setEnabled:false];
        [self checkCodeTimeout];
        timeLb.backgroundColor = RGBACOLOR(229.0, 230.0, 231.0, 1);
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
       
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
        pamar[@"action"] = @"checkuserexist";
        pamar[@"username"] =  phoneText.text;
        
        
        [mgr GET:[BaseURL stringByAppendingString:USERNAME_ISEXIST_CONNECT_GET] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            
            if([responseObject[@"retcode"] isEqual: @0]){
                if ([responseObject[@"exist"] isEqual: @1]) {
                    [self.view makeToast:@"此用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
                    sender.enabled = YES;
                    _flag = 1000;
                    return;
                }else if([responseObject[@"exist"] isEqual: @0]){
                    NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",phoneText.text];
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneText.text,@"target",[sign md5],@"sign",@"MREGISTER",@"stype",nil];
                    [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
                        sender.enabled = YES;
                        [self.view hideToastActivity];
                        if (result) {
                            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                           
                            }else{
                                NSLog(@"%@", result);
                                if ([result[@"msg"] isEqualToString:@"ratelimitted"]) {
                                    [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                                }else {
                                    
                                    [self.view makeToast:@"此号码不存在" duration:1.0 position:SHOW_CENTER complete:nil];
                                    
                                }
                                
                            }
                        }else{
                            
                            [self.view makeToast:@"电话号码不存在" duration:1.0 position:SHOW_CENTER complete:nil];
                        }
                    }];

                }
               
            }else{
                [verifyBtn setEnabled:true];
                if ([responseObject[@"msg"] isEqualToString:@"ratelimitted"]) {
                    [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                }else{
                [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            sender.enabled = YES;
            [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
           
        }];

    }else{
    
        if (phoneText.text.length != 11) {
            [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:SHOW_CENTER complete:nil];
            return;
        }
        if(_flag == 1){
            [self.view makeToast:@"此用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
            _flag = 1000;
            return;
        }
        //发送注册码按钮失效，防止频繁请求
        [verifyBtn setEnabled:false];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        timeLb.backgroundColor = RGBACOLOR(229.0, 230.0, 231.0, 1);
        
        NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",phoneText.text];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneText.text,@"target",[sign md5],@"sign",@"MREGISTER",@"stype",nil];
        [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                   
                    
                   
                }else{
                    sender.enabled = YES;
                    NSLog(@"%@", result);
                    if ([result[@"msg"] isEqualToString:@"ratelimitted"]) {
                        [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                    }else {
                        
                        [self.view makeToast:@"此号码不存在" duration:1.0 position:SHOW_CENTER complete:nil];
                        
                    }
                    
                }
                
            }else{
               sender.enabled = YES;
                [self.view makeToast:@"电话号码不存在" duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];

    }
}

#pragma mark - 倒计时走完
-(void)checkCodeTimeout
{
    timeLb.text = [NSString stringWithFormat:@"%ds",_second--];
    if (_second < 0) {
        [self resetTimer];
    }
}
#pragma mark - 重置定时器
-(void)resetTimer
{
    _second = 60;

    [verifyBtn setEnabled:YES];

    timeLb.text = @"获取验证码";
    timeLb.backgroundColor = RGBACOLOR(19.0, 141.0, 101.0, 1);
   
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 确定
-(IBAction)gosure:(id)sender
{
    
    if (parentNameText.text.length == 0||parentPasswordText.text.length == 0||relationText.text.length == 0||phoneText.text.length == 0||codeText.text.length == 0 || confirmpwdField.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
    }else if(parentPasswordText.text.length < 6 || parentPasswordText.text.length > 20 || confirmpwdField.text.length < 6 || confirmpwdField.text.length > 20){
        [self.view makeToast:@"密码长度不能小于6位或大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
    }else if(phoneText.text.length != 11){
        [self.view makeToast:@"电话号码输入有误" duration:1.0 position:SHOW_CENTER complete:nil];
    }else if(![parentPasswordText.text isEqualToString:confirmpwdField.text]){
        [self.view makeToast:@"两次输入的密码不一样" duration:0.5 position:SHOW_CENTER complete:nil];
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneText.text,@"target",codeText.text,@"code",@"MREGISTER",@"stype",nil];
        [[YjxService sharedInstance] checkOutVerfirycode:dic withBlock:^(id result, NSError *error){//验证验证码
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [self regist];//注册
                }else{
                    if ([result[@"msg"] isEqualToString:@"ratelimitted"]) {
                        [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                    }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
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

    }
}

#pragma mark - 注册
-(void)regist
{
    [self resetTimer];
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_verifyCode,@"code",parentNameText.text,@"name",parentPasswordText.text,@"password",phoneText.text,@"phone",relationText.text,@"relation",_childrenEntity.cid,@"cid",@"",@"sessionid",@"1",@"ostype",((AppDelegate *)SYS_DELEGATE).deviceToken,@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
    [[YjxService sharedInstance] parentsRegist:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
//                ParentEntity *parentEntity = [[ParentEntity alloc] init];
//                parentEntity.name = parentNameText.text;
//                parentEntity.phone = phoneText.text;
//                parentEntity.avatar = @"";
//                parentEntity.pid = [NSString stringWithFormat:@"%@",[result objectForKey:@"pid"]];
//                parentEntity.childrens = [NSMutableArray arrayWithObjects:_childrenEntity, nil];
//                parentEntity.notify_sound =@"default";
//                parentEntity.receive_notify = @"1";
//                parentEntity.notify_with_sound = @"1";
//                [YjyxOverallData sharedInstance].parentInfo = parentEntity;
                NSString *desPassWord = [parentPasswordText.text des3:kCCEncrypt withPass:@"12345678asdf"];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"parents", @"role", phoneText.text,@"username",desPassWord,@"password", nil];
                [SYS_CACHE setObject:dic forKey:@"AutoLogoin"];
                
                //  在此处储存用户名
                NSMutableDictionary *dic1 = (NSMutableDictionary *)[SYS_CACHE objectForKey:@"LoginUserName"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic1];
                [dict setValue:phoneText.text forKey:@"parents"];
                [SYS_CACHE setObject:dict forKey:@"LoginUserName"];
                
                
                AutoLoginViewController *autolog = [[AutoLoginViewController alloc] init];
                [autolog autoLoginWithRole:dic[@"role"] username:dic[@"username"] password:parentPasswordText.text];
                

            }else{
                if ([result[@"msg"] isEqualToString:@"ratelimitted"]) {
                    [self.view makeToast:@"操作过快" duration:1.0 position:SHOW_CENTER complete:nil];
                }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];

}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
