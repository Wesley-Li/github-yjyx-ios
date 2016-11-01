//
//  ParentPersonalViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentPersonalViewController.h"
#import "LoginViewController.h"
#import "ParentMoifyNameViewController.h"
#import "ParentModifyPhoneViewController.h"
#import "ParentChildrensViewController.h"
#import "YjyxSoundViewController.h"
#import "YjyxFeedBackViewController.h"
#import "YjyxOrderViewController.h"
#import "YjyxParentModifyPwdController.h"



@interface ParentPersonalViewController ()<soundSelectDelegate>
{
    BOOL isNeednotifySet;
    NSString *notify_sound;
    NSString *notify_with_sound;
    NSString *receive_notify;
}

@end

@implementation ParentPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    notify_sound = [YjyxOverallData sharedInstance].parentInfo.notify_sound;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSwitch) name:@"ChildActivityNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    notify_with_sound = [YjyxOverallData sharedInstance].parentInfo.notify_with_sound;
    receive_notify = [YjyxOverallData sharedInstance].parentInfo.receive_notify;
    
    isNeednotifySet = YES;
    [_personalTab reloadData];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (isNeednotifySet) {
        if (![notify_sound isEqualToString:[YjyxOverallData sharedInstance].parentInfo.notify_sound]||
            ![notify_with_sound isEqualToString:[YjyxOverallData sharedInstance].parentInfo.notify_with_sound]||
            ![receive_notify isEqualToString:[YjyxOverallData sharedInstance].parentInfo.receive_notify])//只有值发生改变时，才进行请求
        {
            [self notifySetting];

        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simplecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓名：";
            cell.detailTextLabel.text = [YjyxOverallData sharedInstance].parentInfo.name;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else if (indexPath.row ==1)
        {
            cell.textLabel.text = @"手机号码：";
            cell.detailTextLabel.text = [YjyxOverallData sharedInstance].parentInfo.phone;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"我的孩子";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        }else if (indexPath.row == 3){

            cell.textLabel.text = @"我的订单";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        }else{
            cell.textLabel.text = @"修改密码";
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
            [switchView setOn:[[YjyxOverallData sharedInstance].parentInfo.receive_notify integerValue]];
            cell.accessoryView = switchView;
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"声音";
            UISwitch * switchView =  [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
            [switchView addTarget:self action:@selector(notifiChange:) forControlEvents:UIControlEventValueChanged];
            switchView.tag =101;
           [switchView setOn:[[YjyxOverallData sharedInstance].parentInfo.notify_with_sound integerValue]];
            cell.accessoryView = switchView;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"消息提示音";
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"default"]) {
                [cell.detailTextLabel setText:@"默认"];
            }
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"push1.caf"]) {
                [cell.detailTextLabel setText:@"三全音"];
            }
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"push2.caf"]) {
                [cell.detailTextLabel setText:@"管钟琴"];
            }
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"push3.caf"]) {
                [cell.detailTextLabel setText:@"玻璃"];
            }
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"push4.caf"]) {
                [cell.detailTextLabel setText:@"圆号"];
            }
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"push5.caf"]) {
                [cell.detailTextLabel setText:@"铃音"];
            }
            if ([[YjyxOverallData sharedInstance].parentInfo.notify_sound isEqualToString:@"push6.caf"]) {
                [cell.detailTextLabel setText:@"电子乐"];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        }else
        {
            cell.textLabel.text = @"我要吐槽";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        }
    }
    else{
        UIButton *loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        loginOutBtn.backgroundColor = [UIColor whiteColor];
        [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:loginOutBtn];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isNeednotifySet = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            ParentMoifyNameViewController *modifyName = [[ParentMoifyNameViewController alloc] init];
            [modifyName setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:modifyName animated:YES];
        }else if (indexPath.row == 1){
            ParentModifyPhoneViewController *modifyPhone = [[ParentModifyPhoneViewController alloc] init];
            [modifyPhone setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:modifyPhone animated:YES];
        }else if (indexPath.row == 2){
            ParentChildrensViewController *childrens = [[ParentChildrensViewController alloc] init];
            [childrens setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:childrens animated:YES];
        }else if (indexPath.row == 3){
            YjyxOrderViewController *vc = [[YjyxOrderViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            YjyxParentModifyPwdController *modifyPwdVc = [[YjyxParentModifyPwdController alloc] init];
            modifyPwdVc.roleType = @3;
            [modifyPwdVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:modifyPwdVc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 2) {
            YjyxSoundViewController *sound = [[YjyxSoundViewController alloc] init];
            [sound setAudio:cell.detailTextLabel.text];
            sound.delegate = self;
            [sound setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:sound animated:YES];
        }
        
        
        if (indexPath.row == 3) {
            YjyxFeedBackViewController *vc = [[YjyxFeedBackViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark -Event

-(void)notifiChange:(id)sender
{
    UISwitch *switchView =  (UISwitch *)sender;
    if (switchView.tag == 100) {
        [YjyxOverallData sharedInstance].parentInfo.receive_notify = switchView.isOn?@"1":@"0";
        [_personalTab reloadData];
    }else{
        [YjyxOverallData sharedInstance].parentInfo.notify_with_sound = switchView.isOn?@"1":@"0";
    }
}

-(void)notifySetting
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"notify_setting",@"action",[YjyxOverallData sharedInstance].parentInfo.receive_notify,@"receive_notify",[YjyxOverallData sharedInstance].parentInfo.notify_sound,@"sound",[YjyxOverallData sharedInstance].parentInfo.notify_with_sound,@"with_sound",@"1",@"vibrate",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
            }else{
//                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
//            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

-(void)loginOut
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [self.view makeToastActivity:SHOW_CENTER];
    [[YjxService sharedInstance] parentsLoginout:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        NSArray *array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,@"/api/parents/login/"]]];
        for (NSHTTPCookie *cookie in array)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        
        [SYS_CACHE removeObjectForKey:@"AutoLogoin"];
        LoginViewController *loginCtl = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCtl];
        AppDelegate *mydelegate = (AppDelegate*)SYS_DELEGATE;
        nav.navigationBarHidden = YES;
        [mydelegate.window setRootViewController:nav];
        [YjyxOverallData sharedInstance].parentInfo = nil;
        [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    }];
}

#pragma mark -SoundSelectDelegate
-(void)selectSoundWith:(NSString *)soundName
{
    [YjyxOverallData sharedInstance].parentInfo.notify_sound = soundName;
    [_personalTab reloadData];
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
