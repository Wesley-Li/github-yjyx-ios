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
    titleLb.text = [NSString stringWithFormat:@"请为你的账号%@设置密码，以保证下次正常登陆",_phoneStr];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)restPassWord:(id)sender
{
    
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
