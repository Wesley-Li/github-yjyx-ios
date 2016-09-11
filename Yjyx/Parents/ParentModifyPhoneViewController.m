//
//  ParentModifyPhoneViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentModifyPhoneViewController.h"

@interface ParentModifyPhoneViewController ()

@end

@implementation ParentModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 60;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
    
    [_phoneTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if(textField.text.length > 11){
        textField.text = [textField.text substringToIndex:11];
    }
}
#pragma mark - 确定
-(void)goSure
{
    
    if (_phoneTextfield.text.length == 0||codeText.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
    }else{
        [self.view makeToastActivity:SHOW_CENTER];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneTextfield.text,@"target",codeText.text,@"code",@"MPASSWDCHG",@"stype",nil];
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
-(void)changePhone
{
    NSString *nickName = [_phoneTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickName.length == 0&&[nickName isPhone]) {
        [self.view makeToast:@"请输入正确手机号"
                    duration:1.0
                    position:SHOW_BOTTOM
                    complete:nil];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"modify",@"action",@"phone",@"type",_phoneTextfield.text,@"value",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [YjyxOverallData sharedInstance].parentInfo.phone = _phoneTextfield.text;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if([result[@"retcode"] integerValue] == 10){
                    [self.view makeToast:@"该手机已经有老师在使用，请更换手机号码" duration:1.0 position:SHOW_CENTER complete:nil];
                    return ;
                }
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];

}

#pragma mark - 获取验证码
-(IBAction)getChangeCode:(id)sender
{
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
//                timeLb.backgroundColor = [UIColor grayColor];
                //发送注册码按钮失效，防止频繁请求
                timeLb.text = [NSString stringWithFormat:@"%ds",_second--];
                [verifyBtn setEnabled:false];
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
    timeLb.text = [NSString stringWithFormat:@"%ds",_second--];
    if (_second < 0) {
        [self resetTimer];
    }
}

#pragma mark - 重置定时器
-(void)resetTimer
{
    timeLb.backgroundColor = RGBACOLOR(24, 142, 127, 1);
    _second = 60;
    timeLb.text = @"获取验证码";
    [_timer invalidate];
    [verifyBtn setEnabled:true];
    _timer = nil;
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
