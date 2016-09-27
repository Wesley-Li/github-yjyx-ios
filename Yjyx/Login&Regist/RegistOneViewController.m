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
#import "RegistStudentController.h"
@interface RegistOneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *CodeTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property (weak, nonatomic) IBOutlet UIButton *parentBtn;
@property (strong, nonatomic) UIButton *preSelBtn;
@property (weak, nonatomic) IBOutlet UILabel *alertMsgLabel;
@end

@implementation RegistOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(IBAction)checkCode:(id)sender
{
    if (codeTextField.text.length == 0) {
        [self.view makeToast:@"请输入邀请码" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    [self.view makeToastActivity:SHOW_CENTER];
    if([self.preSelBtn isEqual:_parentBtn]){
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
    }else{
        [self.view hideToastActivity];
        //  学生注册
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
        pamar[@"action"] = @"checkcode";
        pamar[@"code"] = codeTextField.text;
        [mgr POST:[BaseURL stringByAppendingString:@"/api/student/mobile/register/"] parameters:pamar  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if ([responseObject[@"retcode"] isEqual:@0]) {
                RegistStudentController *vc = [[RegistStudentController alloc] init];
                NSMutableArray *tempArr = [NSMutableArray array];
                [tempArr addObject:responseObject[@"schoolname"]];
                [tempArr addObject:responseObject[@"gradename"]];
                [tempArr addObject:responseObject[@"classname"]];
                [tempArr addObject:codeTextField.text];
                vc.attrArr = tempArr;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectRoleRegist:(UIButton *)sender
{
    self.preSelBtn.selected = NO;
    self.preSelBtn = sender;
    sender.selected = YES;
    codeTextField.text = nil;
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        partentRegistView.hidden = NO;
        self.CodeTypeLabel.text = @"请输入您班级的邀请码";
        self.alertMsgLabel.hidden = YES;
    }else{
        self.CodeTypeLabel.text = @"请输入家长注册码";
        self.alertMsgLabel.hidden = NO;
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
