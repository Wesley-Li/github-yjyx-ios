//
//  ForgetThreeViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ForgetThreeViewController.h"

@interface ForgetThreeViewController ()<UITextFieldDelegate>

@end

@implementation ForgetThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
    titleLb.text = [NSString stringWithFormat:@"请为您的账号%@设置密码，以保证下次正常登录",_phoneStr];
    [codeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [newPassWord addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [confrimPassWord addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   
}
- (void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    if ([textField.text containsString:@" "]){
        [self.view makeToast:@"密码不能含有空格,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
        textField.text = nil;
    }else if ([textField isEqual:codeText]) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }else if([textField isEqual:newPassWord] || [textField isEqual:confrimPassWord]){
        if (textField.text.length > 20){
            textField.text = [textField.text substringToIndex:20];
            [self.view makeToast:@"密码的长度不能大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }
}


- (void)timerRestart {

    
    // 获取验证码
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_userName,@"username",nil];
    [SVProgressHUD showWithStatus:@"正在发送验证..."];
    [[YjxService sharedInstance] getRestpasswordSms:dic withBlock:^(id result, NSError *error){//验证验证码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                
                [_timer invalidate];
                _timer = nil;
                
                _second = 60;
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];

                [SVProgressHUD dismiss];
                
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                [SVProgressHUD dismiss];
                
            }
        }else{
            if (error.code == -1009) {
                [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                [SVProgressHUD dismiss];
                return;
            }
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];
            [SVProgressHUD dismiss];
        }
    }];


}

-(void)checkCodeTimeout
{
    codeLb.text = [NSString stringWithFormat:@"重新获取验证码(%ds)",_second--];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timerRestart)];
    [codeLb addGestureRecognizer:tap];

    if (_second < 0) {
        [self resetTimer];
    }
}

-(void)resetTimer
{
    _second = 60;
    codeLb.text = @"重新获取验证码(60s)";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timerRestart)];
    [codeLb addGestureRecognizer:tap];
    [_timer invalidate];
    _timer = nil;

}

- (IBAction)restPassWord:(id)sender
{
    if (codeText.text.length == 0||confrimPassWord.text.length == 0||newPassWord.text.length == 0) {
        [self.view makeToast:@"请输入完整的信息" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    
    if (![newPassWord.text isEqualToString:confrimPassWord.text]) {
        [self.view makeToast:@"两次密码必须一致" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if ([newPassWord.text containsString:@" "]) {
        [self.view makeToast:@"密码不能含有空格" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if (newPassWord.text.length < 6 || confrimPassWord.text.length < 6){
        [self.view makeToast:@"密码长度不能小于6位" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_userName,@"username",codeText.text,@"smscode",confrimPassWord.text,@"password",nil];
    [[YjxService sharedInstance] restPassWord:dic withBlock:^(id result, NSError *error){//重置密码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
