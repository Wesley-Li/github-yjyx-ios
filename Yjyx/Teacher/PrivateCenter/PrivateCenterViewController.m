//
//  PrivateCenterViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "PrivateCenterViewController.h"

#import "LoginViewController.h"
#import "NameChageViewController.h"
#import "PhoneChangeViewController.h"
#import "YjyxSoundViewController.h"
#import "FeedBackViewController.h"
#import "SoundChangeViewController.h"

@interface PrivateCenterViewController ()

{
    BOOL isRecieveSound;
    BOOL soundIsOn;
    NSString *notify_sound;
    
    NSString *notify_with_sound;
    NSString *receive_notify;
}

@end

@implementation PrivateCenterViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"个人中心";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    
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
            return 4;
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
            cell.textLabel.text = [NSString stringWithFormat:@"姓名:  %@", [YjyxOverallData sharedInstance].teacherInfo.name];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        }else if (indexPath.row ==1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"手机号码:  %@", [YjyxOverallData sharedInstance].teacherInfo.phone];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"接收新消息通知";
            UISwitch * switchView =  [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
            [switchView addTarget:self action:@selector(isRecieveSound:) forControlEvents:UIControlEventValueChanged];
            if ([[YjyxOverallData sharedInstance].teacherInfo.receive_notify isEqualToString:@"1"]) {
                // 打开状态
                [switchView setOn:YES animated:YES];
            }
            
            cell.accessoryView = switchView;
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"声音";
            UISwitch * switchView =  [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
            [switchView addTarget:self action:@selector(soundIsOn:) forControlEvents:UIControlEventValueChanged];
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_with_sound isEqualToString:@"1"]) {
                // 打开状态
                [switchView setOn:YES animated:YES];
            }
            
            cell.accessoryView = switchView;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"消息提示音";
            
            cell.textLabel.text = @"消息提示音";
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"default"]) {
                [cell.detailTextLabel setText:@"默认"];
            }
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"push1.caf"]) {
                [cell.detailTextLabel setText:@"三全音"];
            }
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"push2.caf"]) {
                [cell.detailTextLabel setText:@"管钟琴"];
            }
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"push3.caf"]) {
                [cell.detailTextLabel setText:@"玻璃"];
            }
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"push4.caf"]) {
                [cell.detailTextLabel setText:@"圆号"];
            }
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"push5.caf"]) {
                [cell.detailTextLabel setText:@"铃声"];
            }
            if ([[YjyxOverallData sharedInstance].teacherInfo.notify_sound isEqualToString:@"push6.caf"]) {
                [cell.detailTextLabel setText:@"电子乐"];
            }

            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else {
        
            cell.textLabel.text = @"我要吐槽";
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

    //    isNeednotifySet = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改姓名
            NameChageViewController *nameChangeVC = [[NameChageViewController alloc] initWithNibName:@"NameChageViewController" bundle:nil];
            nameChangeVC.title = @"修改姓名";
            [self.navigationController pushViewController:nameChangeVC animated:YES];
            
        }else if (indexPath.row == 1) {
        
            // 修改手机号
            PhoneChangeViewController *phoneVC = [[PhoneChangeViewController alloc] initWithNibName:@"PhoneChangeViewController" bundle:nil];
            phoneVC.title = @"修改手机号";
            [self.navigationController pushViewController:phoneVC animated:YES];
        }
    }else if (indexPath.section == 1) {
    
        if (indexPath.row == 2) {
            // 修改提示音
            SoundChangeViewController *soundVC = [[SoundChangeViewController alloc] init];
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            [self.navigationController pushViewController:soundVC animated:YES];
            /*
            YjyxSoundViewController *soundVC = [[YjyxSoundViewController alloc] init];
            [soundVC setAudio:cell.detailTextLabel.text];
            soundVC.delegate = self;
            [soundVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:soundVC animated:YES];
             */
        
        }else if (indexPath.row == 3) {
            
            // 我要吐槽
            FeedBackViewController *feedBackVC = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
        
    }
    
}

#pragma mark - event

- (void)isRecieveSound:(UISwitch *)sender {

    [YjyxOverallData sharedInstance].teacherInfo.receive_notify = sender.isOn ? @"1":@"0";
}

- (void)soundIsOn:(UISwitch *)sender {

    [YjyxOverallData sharedInstance].parentInfo.notify_with_sound = sender.isOn?@"1":@"0";

}




- (void)loginOut {

    NSLog(@"退出登录");
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [self.view makeToastActivity:SHOW_CENTER];
    
    [[YjxService sharedInstance] teacherLogout:dic withBlock:^(id result, NSError *error) {
        [self.view hideToastActivity];
        
        if (result != nil) {
            
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                // 退出时关闭定时器,并清除用户名密码等信息
                [SYS_CACHE removeObjectForKey:@"AutoLogoin"];
                // 定时器挂起
                dispatch_suspend(((AppDelegate*)SYS_DELEGATE).timer);
                
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
