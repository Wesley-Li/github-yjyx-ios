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

@interface PrivateCenterViewController ()<soundSelectDelegate>

{
    BOOL isNeednotifySet;
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
            YjyxSoundViewController *sound = [[YjyxSoundViewController alloc] init];
            [sound setAudio:cell.detailTextLabel.text];
            sound.delegate = self;
            [sound setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:sound animated:YES];
        
        }
        
    }
    
}

#pragma mark - event

- (void)notifiChange:(id)sender {

    UISwitch *switchView =  (UISwitch *)sender;
    if (switchView.tag == 100) {
        [YjyxOverallData sharedInstance].parentInfo.receive_notify = switchView.isOn?@"1":@"0";
        [self.tableView reloadData];
    }else{
        [YjyxOverallData sharedInstance].parentInfo.notify_with_sound = switchView.isOn?@"1":@"0";
    }

}

// 上报消息通知设置
-(void)notifySetting
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"notify_setting",@"action",[YjyxOverallData sharedInstance].teacherInfo.receive_notify,@"receive_notify",[YjyxOverallData sharedInstance].teacherInfo.notify_with_sound,@"with_sound",[YjyxOverallData sharedInstance].teacherInfo.notify_sound,@"sound",[YjyxOverallData sharedInstance].teacherInfo.notify_shake,@"vibrate", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:T_SESSIONID forHTTPHeaderField:@"sessionid"];
    
    [manager POST:[BaseURL stringByAppendingString:TEACHER_UPLOAD_SOUND_SETTING_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
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

#pragma mark - soundSelectDelegate
-(void)selectSoundWith:(NSString *)soundName {
    
    [YjyxOverallData sharedInstance].teacherInfo.notify_sound = soundName;
    [self.tableView reloadData];
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
