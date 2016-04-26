//
//  PrivateCenterViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "PrivateCenterViewController.h"

#import "LoginViewController.h"

@interface PrivateCenterViewController ()

@end

@implementation PrivateCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"个人中心";
    
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"teacher";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓名：";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else if (indexPath.row ==1)
        {
            cell.textLabel.text = @"手机号码：";
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"接收新消息通知";
            UISwitch * switchView =  [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
            [switchView addTarget:self action:@selector(notifiChange:) forControlEvents:UIControlEventValueChanged];
            switchView.tag = 100;
            
            cell.accessoryView = switchView;
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"声音";
            UISwitch * switchView =  [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
            [switchView addTarget:self action:@selector(notifiChange:) forControlEvents:UIControlEventValueChanged];
            switchView.tag =101;
            
            cell.accessoryView = switchView;
        }else{
            cell.textLabel.text = @"消息提示音";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    else{
        UIButton *loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        loginOutBtn.backgroundColor = [UIColor redColor];
        [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:loginOutBtn];
    }
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改姓名
        }else if (indexPath.row == 1) {
        
            // 修改手机号
        }
    }else if (indexPath.section == 1) {
    
        if (indexPath.row == 2) {
            // 修改提示音
        }
        
    }
    
}

#pragma mark - event

- (void)notifiChange:(id)sender {

    NSLog(@"状态改变");
}

- (void)loginOut {

    NSLog(@"退出登录");
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [self.view makeToastActivity:SHOW_CENTER];
    
    [[YjxService sharedInstance] teacherLogout:dic withBlock:^(id result, NSError *error) {
        [self.view hideToastActivity];
        
        if (result != nil) {
            
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [SYS_CACHE removeObjectForKey:@"AutoLogoin"];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                AppDelegate *mydelegate = (AppDelegate*)SYS_DELEGATE;
                nav.navigationBarHidden = YES;
                [mydelegate.window setRootViewController:nav];
            }
        }else {
        
            [self.view makeToast:[error description] duration:2.0 position:SHOW_CENTER complete:nil];
        }
        
        
    }];
    

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
