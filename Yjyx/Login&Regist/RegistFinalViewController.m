//
//  RegistFinalViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "RegistFinalViewController.h"

@interface RegistFinalViewController ()

@end

@implementation RegistFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 60;
    
    titleLb.text = [NSString stringWithFormat:@"%@%@的邀请码",_school,_childrenEntity.name];
    parentNameText.placeholder = @"家长姓名";
    parentPasswordText.placeholder = @"家长密码";
    relationText.placeholder = [NSString stringWithFormat:@"是%@的(称谓,譬如父亲,母亲...)",_childrenEntity.name];
    phoneText.placeholder = @"手机号码(作为登录账户)";
    codeText.placeholder = @"4位验证码";
    
    [parentNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [relationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [parentPasswordText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}
// 限制输入的长度
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if ([textField isEqual:phoneText]) {

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
                }
                
            }
            
        }
    }else if ([textField isEqual:parentPasswordText]){
        if (textField.text.length > 20){
            textField.text = [textField.text substringToIndex:20];
            [self.view makeToast:@"密码的长度不能大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
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
    if (phoneText.text.length == 0 || phoneText.text.length < 11) {
        [self.view makeToast:@"请输入正确的账号" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if (parentPasswordText.text.length < 6){
        [self.view makeToast:@"密码长度不能小于6位" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if ([parentPasswordText.text containsString:@" "]){
        [self.view makeToast:@"密码不能包含空格" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",phoneText.text];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneText.text,@"target",[sign md5],@"sign",@"MREGISTER",@"stype",nil];
    [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                timeLb.backgroundColor = RGBACOLOR(229.0, 230.0, 231.0, 1);
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                //发送注册码按钮失效，防止频繁请求
                [verifyBtn setEnabled:false];
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
    codeText.text = @"";
    [verifyBtn setEnabled:YES];

    timeLb.text = @"获取验证码";
    timeLb.backgroundColor = RGBACOLOR(19.0, 141.0, 101.0, 1);
   
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 确定
-(IBAction)gosure:(id)sender
{
    
    if (parentNameText.text.length == 0||parentPasswordText.text.length == 0||relationText.text.length == 0||phoneText.text.length == 0||codeText.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
    }else if([parentPasswordText.text containsString:@" "] || [parentNameText.text containsString:@" "]){
        [self.view makeToast:@"用户名或密码不能含有空格" duration:1.0 position:SHOW_CENTER complete:nil];
    }else if(parentPasswordText.text.length < 6 || parentPasswordText.text.length > 20){
        [self.view makeToast:@"密码长度不能小于6位或大于20位" duration:1.0 position:SHOW_CENTER complete:nil];
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneText.text,@"target",codeText.text,@"code",@"MREGISTER",@"stype",nil];
        [[YjxService sharedInstance] checkOutVerfirycode:dic withBlock:^(id result, NSError *error){//验证验证码
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [self regist];//注册
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
}

#pragma mark - 注册
-(void)regist
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_verifyCode,@"code",parentNameText.text,@"name",parentPasswordText.text,@"password",phoneText.text,@"phone",relationText.text,@"relation",_childrenEntity.cid,@"cid",@"",@"sessionid",@"1",@"ostype",@"123456734",@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
    [[YjxService sharedInstance] parentsRegist:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                ParentEntity *parentEntity = [[ParentEntity alloc] init];
                parentEntity.name = parentNameText.text;
                parentEntity.phone = phoneText.text;
                parentEntity.avatar = @"";
                parentEntity.pid = [NSString stringWithFormat:@"%@",[result objectForKey:@"pid"]];
                parentEntity.childrens = [NSMutableArray arrayWithObjects:_childrenEntity, nil];
                parentEntity.notify_sound =@"default";
                parentEntity.receive_notify = @"1";
                parentEntity.notify_with_sound = @"1";
                [YjyxOverallData sharedInstance].parentInfo = parentEntity;
                [(AppDelegate *)SYS_DELEGATE fillViews];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
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
