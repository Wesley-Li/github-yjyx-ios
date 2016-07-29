//
//  YjyxChangePhoneController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxChangePhoneController.h"

@interface YjyxChangePhoneController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UILabel *getCodeBtn;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger second;
@end

@implementation YjyxChangePhoneController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _second = 60;
    
    [self configureNavBar];
    [_phoneTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if(textField.text.length > 11){
        textField.text = [textField.text substringToIndex:11];
    }
    textField.text = textField.text;
    NSLog(@"%@", textField.text);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}
#pragma mark - 配置导航栏
- (void)configureNavBar {
    
    self.title = @"修改手机号";
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setTitle:@"取消" forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goBackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sureBtn addTarget:self action:@selector(goSure) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确定
- (void)goSure {
    [self resetTimer];
    if (_phoneTextfield.text.length == 0||_codeTextField.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
    }else{
        [self.view makeToastActivity:SHOW_CENTER];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneTextfield.text,@"target",_codeTextField.text,@"code",@"MPASSWDCHG",@"stype",nil];
        [[YjxService sharedInstance] checkOutVerfirycode:dic withBlock:^(id result, NSError *error){//验证验证码
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [self changePhone];
                }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }else{
                [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];
        
    }
    
    
    
}

#pragma mark - 更改手机号
- (void)changePhone {
    
    
    NSString *nickName = [_phoneTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickName.length == 0&&[nickName isPhone]) {
        [self.view makeToast:@"请输入正确手机号"
                    duration:1.0
                    position:SHOW_BOTTOM
                    complete:nil];
        return;
    }
    
    NSString *value = [NSString stringWithFormat:@"%@", _phoneTextfield.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"modify", @"action", @"phone", @"type", value, @"value", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[BaseURL stringByAppendingString:STUDENT_NAME_AND_PHONE_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"retcode"] integerValue] == 0) {
            // 刷新列表
            [YjyxOverallData sharedInstance].studentInfo.phonenumber = _phoneTextfield.text;
            [self.view makeToast:@"修改成功" duration:0.5 position:SHOW_CENTER complete:nil];
            [self.navigationController popViewControllerAnimated:YES];
         
        }else {
            
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        
    }];
    
    
}

#pragma mark - 获取验证码
- (IBAction)getCodeBtn:(UIButton *)sender {
    
    if (![_phoneTextfield.text isPhone]) {
        [self.view makeToast:@"请输入正确的账号" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",_phoneTextfield.text];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneTextfield.text,@"target",[sign md5],@"sign",@"MPASSWDCHG",@"stype",nil];
    [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
//                _timeLabel.backgroundColor = [UIColor grayColor];
                //发送注册码按钮失效，防止频繁请求
                self.timeLabel.text = [NSString stringWithFormat:@"%lds",(long)_second--];
                [self.getCodeBtn setEnabled:false];
            }else{
                [self.view makeToast:@"获取验证码失败，请稍后重试" duration:1.0 position:SHOW_CENTER complete:nil];
                
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    
    
}

#pragma mark - 倒计时时间走完
-(void)checkCodeTimeout
{
    _timeLabel.text = [NSString stringWithFormat:@"%lds",(long)_second--];
    if (_second < 0) {
        [self resetTimer];
    }
}

#pragma mark - 重置时间器
-(void)resetTimer
{
//    _timeLabel.backgroundColor = RGBACOLOR(11.0, 102.0, 254.0, 1);
    _second = 60;
    _timeLabel.text = @"获取验证码";
    [_timer invalidate];
    [_getCodeBtn setEnabled:true];
    _timer = nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
