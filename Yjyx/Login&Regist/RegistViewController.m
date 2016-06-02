//
//  RegistViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _parentCodeView.hidden = YES;
    _parentRegistView.hidden = YES;
    
    codeTextField.delegate = self;
    textField1.delegate = self;
    textField2.delegate = self;
    textField3.delegate = self;
    textField4.delegate = self;

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    if (IS_INCH_3_5) {
        CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat ty = - rect.size.height+40;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 +ty);
        }];
    }
    else
    {
        CGFloat ty = - 100;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 +ty);
            
        }];
    }
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    if (IS_INCH_3_5) {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 );
        }];
    }
    else
    {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.center = CGPointMake(SCREEN_WIDTH/2, [UIScreen mainScreen].bounds.size.height/2 );
        }];
    }
}
#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)clicked:(id)sender
{
    [self.view hideKeyboard];
}


#pragma mark -BtnClicked

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)roleSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            _parentCodeView.hidden = YES;
            _parentRegistView.hidden = YES;
            break;
        case 101:
            _parentCodeView.hidden = NO;
            _parentRegistView.hidden = YES;
            break;
        case 102:
            _parentCodeView.hidden = YES;
            _parentRegistView.hidden = YES;
            break;
        default:
            break;
    }
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
                _parentRegistView.hidden = NO;
                _parentCodeView.hidden = YES;
                textField1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                textField1.layer.borderWidth = 0.5;
                
                textField2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                textField2.layer.borderWidth = 0.5;
                
                textField3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                textField3.layer.borderWidth = 0.5;
                
                textField4.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                textField4.layer.borderWidth = 0.5;
                
                childrenLb.text = [result objectForKey:@"school"];
                relationshipLb.text =[NSString stringWithFormat:@"是%@的",[result objectForKey:@"childname"]];
                childrenCid = [result objectForKey:@"cid"];
                
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
            
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

-(IBAction)registBtn:(id)sender
{
    if (textField1.text.length == 0||textField2.text.length == 0||textField3.text.length == 0||textField4.text.length == 0) {
        [self.view makeToast:@"请输入完整信息" duration:1.0 position:SHOW_CENTER complete:nil];
    }else{
        [self.view makeToastActivity:SHOW_CENTER];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:codeTextField.text,@"code",textField1.text,@"name",textField2.text,@"password",textField3.text,@"phone",textField4.text,@"relation",childrenCid,@"cid",@"",@"sessionid",@"1",@"ostype",@"123456734",@"devicetoken",[[UIDevice currentDevice] model],@"description",nil];
        [[YjxService sharedInstance] parentsRegist:dic withBlock:^(id result, NSError *error){
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    childrenEntity.relation = textField4.text;
                    ParentEntity *parentEntity = [[ParentEntity alloc] init];
                    parentEntity.name = textField1.text;
                    parentEntity.phone = textField3.text;
                    parentEntity.avatar = @"";
                    parentEntity.pid = [NSString stringWithFormat:@"%@",[result objectForKey:@"pid"]];
                    parentEntity.childrens = [NSMutableArray arrayWithObjects:childrenEntity, nil];
                    parentEntity.notify_sound =@"default";
                    parentEntity.receive_notify = @"1";
                    parentEntity.notify_with_sound = @"1";
                    [YjyxOverallData sharedInstance].parentInfo = parentEntity;
                    [(AppDelegate *)SYS_DELEGATE fillViews];
                }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }else{
                if (error.code == -1009) {
                    [self.view makeToast:@"您的网络可能不太好,请重试!" duration:3.0 position:SHOW_CENTER complete:nil];
                    return;
                }
                [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:3.0 position:SHOW_CENTER complete:nil];
            }
        }];
    }
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
