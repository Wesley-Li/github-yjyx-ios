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
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"修改手机号";
    [self loadBackBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [sureBtn addTarget:self action:@selector(goSure) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setImage:[UIImage imageNamed:@"comm_sure"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;

    
    // Do any additional setup after loading the view from its nib.
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

-(void)goSure
{
    [self.view hideKeyboard];
    NSString *nickName = [_phoneTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickName.length == 0&&[nickName isPhone]) {
        [self.view makeToast:@"请输入正确手机号"
                    duration:1.0
                    position:SHOW_BOTTOM
                    complete:nil];
        return;
    }
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"modify",@"action",@"phone",@"type",_phoneTextfield.text,@"value",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [YjyxOverallData sharedInstance].parentInfo.phone = _phoneTextfield.text;
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    
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
