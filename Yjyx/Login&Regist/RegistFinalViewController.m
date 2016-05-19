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
    phoneText.placeholder = @"手机号码";
    codeText.placeholder = @"4位验证码";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)getRegisterCode:(id)sender
{
    if (phoneText.text.length == 0) {
        [self.view makeToast:@"请输入正确的账号" duration:1.0 position:SHOW_BOTTOM complete:nil];
        return;
    }
    NSString *sign = [NSString stringWithFormat:@"yjyx_%@_smssign",phoneText.text];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneText.text,@"target",[sign md5],@"sign",@"MREGISTER",@"stype",nil];
    [[YjxService sharedInstance] getSMSsendcode:dic withBlock:^(id result, NSError *error){//验证验证码
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeTimeout) userInfo:nil repeats:YES];
                //发送注册码按钮失效，防止频繁请求
                [verifyBtn setEnabled:false];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

-(void)checkCodeTimeout
{
    timeLb.text = [NSString stringWithFormat:@"%ds",_second--];
    if (_second < 0) {
        [self resetTimer];
    }
}

-(void)resetTimer
{
    _second = 60;
    codeText.text = @"";
    timeLb.text = @"获取验证码";
    [_timer invalidate];
    _timer = nil;
}

-(IBAction)gosure:(id)sender
{
    
    if (parentNameText.text.length == 0||parentPasswordText.text.length == 0||relationText.text.length == 0||phoneText.text.length == 0||codeText.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
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
                [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];

    }
}

-(void)regist
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_verifyCode,@"code",parentNameText.text,@"name",[parentPasswordText.text md5],@"password",phoneText.text,@"phone",relationText.text,@"relation",_childrenEntity.cid,@"cid",@"",@"sessionid",@"1",@"ostype",@"123456734",@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
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
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
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
