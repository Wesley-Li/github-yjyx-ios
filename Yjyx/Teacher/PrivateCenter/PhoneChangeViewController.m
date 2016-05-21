//
//  PhoneChangeViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "PhoneChangeViewController.h"


@interface PhoneChangeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation PhoneChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _doneBtn.layer.cornerRadius = 8;
}

// 点击完成按钮
- (IBAction)handleDoneBtn:(UIButton *)sender {
    
    NSString *value = [NSString stringWithFormat:@"%@", _phoneTF.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"modify", @"action", @"phone", @"type", value, @"value", nil];
    
    if (_phoneTF.text.length == 0) {
        [self.view makeToast:@"号码为空,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[BaseURL stringByAppendingString:TEACHER_NAME_AND_PHONE_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"retcode"] integerValue] == 0) {
                
                [self.view makeToast:@"修改成功" duration:0.5 position:SHOW_CENTER complete:^{
                    // 刷新列表
                    [YjyxOverallData sharedInstance].parentInfo.phone = _phoneTF.text;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else {
                
                [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
            
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
