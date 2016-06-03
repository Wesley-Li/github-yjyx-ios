//
//  NameChageViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "NameChageViewController.h"
#import "PrivateCenterViewController.h"
#import "TeacherHomeViewController.h"

@interface NameChageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation NameChageViewController

- (void)viewWillAppear:(BOOL)animated {

    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nameTF.layer.cornerRadius = 20;
    _doneBtn.layer.cornerRadius = 20;
    _doneBtn.backgroundColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    _doneBtn.tintColor = [UIColor whiteColor];
    
}

// 点击屏幕回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [_nameTF endEditing:YES];
}

// 点击完成按钮
- (IBAction)handleDoneBtn:(UIButton *)sender {
    
    
    NSString *value = [NSString stringWithFormat:@"%@", _nameTF.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"modify", @"action", @"name", @"type", value, @"value", nil];
    
    if (_nameTF.text.length == 0) {
        [self.view makeToast:@"姓名为空,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager POST:[BaseURL stringByAppendingString:TEACHER_NAME_AND_PHONE_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
            if ([responseObject[@"retcode"] integerValue] == 0) {
            
                [self.view makeToast:@"修改成功" duration:0.5 position:SHOW_CENTER complete:^{
                    // 更新
                    [YjyxOverallData sharedInstance].teacherInfo.name = _nameTF.text;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else {
            
                [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        
        }];
    }
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
