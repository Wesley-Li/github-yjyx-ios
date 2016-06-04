//
//  ParentMoifyNameViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentMoifyNameViewController.h"

@interface ParentMoifyNameViewController ()

@end

@implementation ParentMoifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
    
    [self.nickeNameTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nickeNameTextfield.delegate = self;
    self.title = @"修改姓名";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    
    
        NSString *toBeString = textField.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 10) {
                    textField.text = [toBeString substringToIndex:10];
                }
                
            }
        }else{
            if(textField.text.length > 10){
                textField.text = [toBeString substringToIndex:10];
            }
        }
    
}
-(void)goSure
{
    [self.view hideKeyboard];
    NSString *nickName = [_nickeNameTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickName.length == 0 ) {
        [self.view makeToast:@"请输入姓名"
                    duration:1.0
                    position:SHOW_TOP
                    complete:nil];
        return;
    }
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"modify",@"action",@"name",@"type",_nickeNameTextfield.text,@"value",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [YjyxOverallData sharedInstance].parentInfo.name = _nickeNameTextfield.text;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *nickName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickName.length == 0) {
        [self.view makeToast:NSLocalizedString(@"PersonNicknameAlert0", @"")
                    duration:1.0
                    position:SHOW_TOP
                    complete:nil];
        return YES;
    }
    [self goSure];
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
