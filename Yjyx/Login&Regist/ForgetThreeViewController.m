//
//  ForgetThreeViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ForgetThreeViewController.h"

@interface ForgetThreeViewController ()

@end

@implementation ForgetThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 60;
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
    titleLb.text = [NSString stringWithFormat:@"请为您的账号%@设置密码，以保证下次正常登录",_phoneStr];
}

-(void)checkCodeTimeout
{
    codeLb.text = [NSString stringWithFormat:@"重新获取验证码(%ds)",_second--];
    if (_second < 0) {
        [self resetTimer];
    }
}

-(void)resetTimer
{
    _second = 60;
    codeLb.text = @"重新获取验证码(60s)";
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
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_userName,@"username",codeText.text,@"smscode",confrimPassWord.text,@"password",nil];
    [[YjxService sharedInstance] restPassWord:dic withBlock:^(id result, NSError *error){//重置密码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
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
