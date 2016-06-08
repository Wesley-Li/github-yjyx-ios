//
//  RegistOneViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "RegistOneViewController.h"
#import "RegistViewController.h"
#import "RegistFinalViewController.h"

@interface RegistOneViewController ()

@end

@implementation RegistOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)checkCode:(id)sender
{
    if (codeTextField.text.length == 0) {
        [self.view makeToast:@"请输入邀请码" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:codeTextField.text,@"code",nil];
    [[YjxService sharedInstance] registcheckcode:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                childrenEntity = [[ChildrenEntity alloc] init];
                childrenEntity.name = [result objectForKey:@"childname"];
                childrenEntity.cid = [result objectForKey:@"cid"];
                childrenEntity.childavatar = @"";
                RegistFinalViewController *vc = [[RegistFinalViewController alloc] init];
                vc.childrenEntity = childrenEntity;
                vc.school = [result objectForKey:@"school"];
                vc.verifyCode = codeTextField.text;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
           
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectRoleRegist:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        partentRegistView.hidden = YES;
    }else{
        partentRegistView.hidden = NO;
    }
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clicked:(id)sender
{
    [self.view hideKeyboard];
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
