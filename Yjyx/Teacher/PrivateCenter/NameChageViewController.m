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
    
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
            [self.view makeToast:@"输入的长度不能大于10位" duration:1.0 position:SHOW_CENTER complete:nil];
        }
       
    }
    
}
// 点击屏幕回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [_nameTF endEditing:YES];
}

// 点击完成按钮
- (IBAction)handleDoneBtn:(UIButton *)sender {
    
    
    NSString *value = [NSString stringWithFormat:@"%@", _nameTF.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"modify", @"action", @"name", @"type", value, @"value", nil];
    NSString *nameStr = [_nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_nameTF.text.length == 0 || nameStr.length == 0) {
        [self.view makeToast:@"姓名为空,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager POST:[BaseURL stringByAppendingString:TEACHER_NAME_AND_PHONE_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
            if ([responseObject[@"retcode"] integerValue] == 0) {
                // 更新
                [YjyxOverallData sharedInstance].teacherInfo.name = _nameTF.text;
                [self.view makeToast:@"修改成功" duration:0.01 position:SHOW_CENTER complete:nil];
               
                    
                [self.navigationController popViewControllerAnimated:YES];
              
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
