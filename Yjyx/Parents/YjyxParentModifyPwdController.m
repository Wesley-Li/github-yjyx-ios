//
//  YjyxParentModifyPwdController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxParentModifyPwdController.h"

@interface YjyxParentModifyPwdController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originalPwdField;
@property (weak, nonatomic) IBOutlet UITextField *newlyPwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;


@property (strong, nonatomic) NSString *originPwd;
@property (strong, nonatomic) NSString *newlyPwd;
@property (strong, nonatomic) NSString *confirmPwd;
@end

@implementation YjyxParentModifyPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setupBarButtonItem];
    [self.originalPwdField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.newlyPwdField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmPwdField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)setupBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(textField.text.length > 20){
        textField.text = [textField.text substringToIndex:20];
        [self.view makeToast:@"密码长度不能超过20位" duration:0.5 position:SHOW_CENTER complete:nil];
    }else if([textField.text containsString:@" "]){
        [self.view makeToast:@"密码中不能含有空格" duration:0.5 position:SHOW_CENTER complete:nil];
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
}
// 确认修改
- (void)confirm
{
    [self.view endEditing:YES];
    if(self.originalPwdField.text.length < 6){
        [self.view makeToast:@"原始密码输入的位数小于6位" duration:0.5 position:SHOW_TOP complete:nil];
    }else if (self.newlyPwdField.text.length < 6 || self.confirmPwdField.text.length < 6){
        [self.view makeToast:@"重置的新密码位数小于6位" duration:0.5 position:SHOW_TOP complete:nil];
    }else if (![self.newlyPwdField.text isEqualToString:self.confirmPwdField.text]){
        [self.view makeToast:@"新设置的密码和确认密码不一致" duration:0.5 position:SHOW_TOP complete:nil];
    }else{
        NSInteger index = [self.roleType integerValue];
        NSString *appendUrl = @"/api/parents/setting/";
        switch (index) {
            case 2:
                appendUrl = @"/api/teacher/mobile/yj_teachers/";
                break;
            case 3:
                appendUrl = @"/api/student/mobile/yj_students/";
                break;
            default:
                break;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.alpha = 0.1;
        [self.view addSubview:view];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"action"] = @"changeuserpassword";
        param[@"oldpassword"] = self.originalPwdField.text;
        param[@"newpassword"] = self.newlyPwdField.text;
        [view makeToastActivity:SHOW_CENTER];
        [mgr PUT:[BaseURL stringByAppendingString:appendUrl] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [view removeFromSuperview];
            if ([responseObject[@"retcode"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                NSDictionary *dic = (NSDictionary *)[SYS_CACHE objectForKey:@"AutoLogoin"];
                 NSString *desPassWord = [_newlyPwdField.text des3:kCCEncrypt withPass:@"12345678asdf"];
                NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:((AppDelegate*)SYS_DELEGATE).role, @"role", dic[@"username"],@"username",desPassWord,@"password", nil];
                [SYS_CACHE setObject:newDict forKey:@"AutoLogoin"];
                [SYS_CACHE synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:responseObject[@"reason"] duration:0.5 position:SHOW_TOP complete:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [view removeFromSuperview];
             [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_TOP complete:nil];
        }];
    }
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.originalPwdField]){
        
        if([self.originPwd isEqualToString:textField.text] || textField.text.length == 0){
            return;
        }
        if(textField.text.length < 6){
            [self.view makeToast:@"您的初始密码位数输入不正确" duration:0.5 position:SHOW_CENTER complete:nil];
            self.originPwd = textField.text;
        }
    }else{
        if(_confirmPwdField.text.length == 0 || _newlyPwdField.text.length == 0){
            return;
        }
        
        if(textField.text.length < 6 || self.newlyPwdField.text.length < 6 || self.confirmPwdField.text.length < 6){
            [self.view makeToast:@"密码长度不能小于6位" duration:0.5 position:SHOW_CENTER complete:nil];
            return;
        }
        
        if([self.newlyPwd isEqualToString:self.newlyPwdField.text] && [self.confirmPwd isEqualToString:self.confirmPwdField.text]){
            return;
        }
        if(![self.newlyPwdField.text isEqualToString:self.confirmPwdField.text]){
            self.newlyPwd = self.newlyPwdField.text;
            self.confirmPwd = self.confirmPwdField.text;
            [self.view makeToast:@"两次密码输入不一致" duration:0.5 position:SHOW_CENTER complete:nil];
        }
    }
}
@end
