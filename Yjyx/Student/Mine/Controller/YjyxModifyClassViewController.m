//
//  YjyxModifyClassViewController.m
//  Yjyx
//
//  Created by yjyx on 16/9/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxModifyClassViewController.h"

@interface YjyxModifyClassViewController ()

@property (weak, nonatomic) IBOutlet UITextField *
   InvitationCodeTextFeid;

@end

@implementation YjyxModifyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更改班级";
    [self setBackButtonItem];
}

//设置返回按钮
- (void)setBackButtonItem{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    backBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"comm_back"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
       
}

//返回操作
- (void)goBack:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)finishAction:(id)sender {
    
     NSString *messageStr = @"（注意：修改班级后，您将不能收到以前班级老师分配的任务！）";
    NSString * cancelStr = @"取消";
    NSString * okStr = @"确定" ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定加入新班级吗？" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
     /*message*/
    NSMutableAttributedString *messageAttr = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [messageAttr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f30000"] range:NSMakeRange(0, messageStr.length)];
    [messageAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, messageStr.length)];
        [alertController setValue:messageAttr forKey:@"attributedMessage"];
   /*cancelAction*/
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    /*okAction*/
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *invitationCodeStr = self.InvitationCodeTextFeid.text;
        if (invitationCodeStr.length == 0) {
            [self.view makeToast:@"邀请码为空,请重新输入" duration:1.0 position:SHOW_CENTER complete:nil];;
            return ;
        }
        [self sendRequest:invitationCodeStr];
        
        
    }];
    /*取消按钮的字体颜色*/
    [cancelAction setValue:[UIColor colorWithHexString:@"f30000"] forKey:@"_titleTextColor"];
    
    /*确定按钮字体*/
    [okAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
 //发送新邀请码的请求
- (void)sendRequest:(NSString *)str{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"changemyclass", @"action", str, @"invitecode", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[BaseURL stringByAppendingString:STUDENT_MODIFYClASS_PUT] parameters:dic  success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        OneStudentEntity *studentInfo =[YjyxOverallData sharedInstance].studentInfo;
        if ([responseObject[@"retcode"] integerValue] ==0) {
            NSString *className = responseObject[@"classname"];
            NSString *gradename = responseObject[@"gradename"];
            NSString *schoolName = responseObject[@"schoolname"];
            studentInfo.classname = className;
            studentInfo.gradename = gradename;
            studentInfo.schoolname = schoolName;
            [self.view makeToast:@"修改班级成功" duration:0.5 position:SHOW_CENTER complete:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSString *reason = responseObject[@"reason"];
            [self.view makeToast:reason duration:0.5 position:SHOW_CENTER complete:nil];
        }
        NSLog(@"responseObject==%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
    }];

  


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
