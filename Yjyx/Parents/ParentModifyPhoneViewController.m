//
//  ParentModifyPhoneViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentModifyPhoneViewController.h"

@interface ParentModifyPhoneViewController ()<UITextFieldDelegate>

@property (assign, nonatomic) NSInteger flag;
@property (strong, nonatomic) NSString *phoneNumStr;
@property (weak, nonatomic) IBOutlet UILabel *promptInfoLabel;
@end

@implementation ParentModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.promptInfoLabel.width = SCREEN_WIDTH - 32;

    self.promptInfoLabel.numberOfLines = 0;
    self.promptInfoLabel.text = @"*温馨提醒:\n修改手机号成功后，您的登录账号也会一起改变哦。";
    [self.promptInfoLabel sizeToFit];
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
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)textField
{
    self.phoneTextfield.textColor = [UIColor blackColor];
    verifyBtn.userInteractionEnabled = YES;
    if(textField.text.length >= 11){
        textField.text = [textField.text substringToIndex:11];
        if([textField.text isEqualToString:self.phoneNumStr]){
            if(_flag == 1){
                self.phoneTextfield.textColor = [UIColor redColor];
                verifyBtn.userInteractionEnabled = NO;
                [self.view makeToast:@"此用户名已经存在" duration:1.0 position:SHOW_CENTER complete:nil];
                return;
            }
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
                    verifyBtn.userInteractionEnabled = NO;
                    self.phoneTextfield.textColor = [UIColor redColor];
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
    [self.phoneTextfield resignFirstResponder];
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
               [self.view makeToast:@"该手机已经有家长在使用，请更换手机号码" duration:1.0 position:SHOW_CENTER complete:nil];
                    return ;
               
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




@end
