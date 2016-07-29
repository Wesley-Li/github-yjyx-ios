//
//  YjyxChangeNameController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxChangeNameController.h"
#import "OneStudentEntity.h"
@interface YjyxChangeNameController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation YjyxChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nameTextField.layer.cornerRadius = 20;
    _nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _nameTextField.layer.borderWidth = 1;
    _doneBtn.layer.cornerRadius = 20;
    _doneBtn.backgroundColor = RGBACOLOR(0, 229.0, 199.0, 1);
    _doneBtn.tintColor = [UIColor whiteColor];
    
    [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        textField.text = [textField.text substringToIndex:10];
        [self.view makeToast:@"输入的长度不能大于10位" duration:1.0 position:SHOW_CENTER complete:nil];
    }
    
}
// 点击屏幕回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_nameTextField endEditing:YES];
}

// 点击完成按钮
- (IBAction)handleDoneBtn:(UIButton *)sender {
    
    
    NSString *value = [NSString stringWithFormat:@"%@", _nameTextField.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"modify", @"action", @"name", @"type", value, @"value", nil];
    NSString *nameStr = [_nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_nameTextField.text.length == 0 || nameStr.length == 0) {
        [self.view makeToast:@"姓名为空,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:[BaseURL stringByAppendingString:STUDENT_NAME_AND_PHONE_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"retcode"] integerValue] == 0) {
                [YjyxOverallData sharedInstance].studentInfo.realname = _nameTextField.text;
                [self.view makeToast:@"修改成功" duration:0.5 position:SHOW_CENTER complete:nil];
                    // 更新
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



@end
