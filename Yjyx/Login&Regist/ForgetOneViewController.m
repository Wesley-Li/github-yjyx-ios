//
//  ForgetOneViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ForgetOneViewController.h"
#import "ForgetTwoViewController.h"

@interface ForgetOneViewController ()

@end

@implementation ForgetOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goSure:(id)sender
{
//    if (![accountText.text isPhone]) {
//        [self.view makeToast:@"请输入正确的账号" duration:1.0 position:SHOW_CENTER complete:nil];
//        return;
//    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:accountText.text,@"username",nil];
    [[YjxService sharedInstance] getUserPhone:dic withBlock:^(id result, NSError *error){//验证验证码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                
                ForgetTwoViewController *vc = [[ForgetTwoViewController alloc] init];
                vc.phoneStr = [result objectForKey:@"phone"];
                vc.userName = accountText.text;
                [self.navigationController pushViewController:vc animated:YES];

            }else{
                [self.view makeToast:@"请输入正确的账号" duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            if (error.code == -1009) {
                [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                return;
            }
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];        }
    }];
    
  }

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
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
