//
//  ForgetTwoViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ForgetTwoViewController.h"
#import "ForgetThreeViewController.h"

@interface ForgetTwoViewController ()

@end

@implementation ForgetTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = [_phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    titleLb.text = [NSString stringWithFormat:@"您的账号已绑定手机%@,您可以通过短信验证码找回",str];
}

-(IBAction)getCode:(id)sender
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_userName,@"username",nil];
    [[YjxService sharedInstance] getRestpasswordSms:dic withBlock:^(id result, NSError *error){//验证验证码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                ForgetThreeViewController *vc = [[ForgetThreeViewController alloc] init];
                vc.phoneStr = self.phoneStr;
                vc.userName = self.userName;
                [self.navigationController pushViewController:vc animated:YES];
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

-(void)restPassWord
{
    ForgetThreeViewController *vc = [[ForgetThreeViewController alloc] init];
    vc.phoneStr = self.phoneStr;
    [self.navigationController pushViewController:vc animated:YES];

}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
