//
//  YjyxChangeSoundViewController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxChangeSoundViewController.h"

@interface YjyxChangeSoundViewController ()
{
    NSNumber *number;
}
@end

@implementation YjyxChangeSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"设置提示音"];
    sounds = [[NSMutableArray alloc] initWithObjects:@"默认",@"三全音",@"管钟琴",@"玻璃",@"圆号",@"铃音",@"电子乐", nil];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setTitle:@"取消" forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goBackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sureBtn addTarget:self action:@selector(goSure) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

// 返回
-(void)goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 确定,并上报消息通知设置
- (void)goSure
{
    // 存储
    [[NSUserDefaults standardUserDefaults]setValue:[YjyxOverallData sharedInstance].studentInfo.notify_sound forKey:@"T_SOUND"];
    
    // 上报消息设置
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"notify_setting",@"action",[YjyxOverallData sharedInstance].studentInfo.receive_notify,@"receive_notify",[YjyxOverallData sharedInstance].studentInfo.notify_with_sound,@"with_sound",_audio,@"sound",[YjyxOverallData sharedInstance].studentInfo.notify_shake,@"vibrate", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager POST:[BaseURL stringByAppendingString:STUDENT_UPLOAD_SOUND_SETTING_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // 返回
        [self.navigationController popViewControllerAnimated:YES];
        //        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
        //        NSLog(@"%@", error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return sounds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell.textLabel setText:[sounds  objectAtIndex:indexPath.row]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
//    if (indexPath.row == [[[NSUserDefaults standardUserDefaults] objectForKey:@"T_SOUNDS"] integerValue]) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//        defaultIndex = indexPath;
//    }
    
    if([_audio isEqualToString:[sounds objectAtIndex:indexPath.row]]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        defaultIndex = indexPath;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if (indexPath != defaultIndex && defaultIndex != nil) {
        UITableViewCell *defaultCell = [tableView cellForRowAtIndexPath:defaultIndex];
        [defaultCell setAccessoryType:UITableViewCellAccessoryNone];
        defaultIndex = nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"push%ld",(long)indexPath.row] ofType:@"caf"];
    if (path) {
        if (player) {
            [player stop];
            player = nil;
        }
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        NSURL *audioPath = [NSURL fileURLWithPath:path];
        NSError *playerError;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioPath error:&playerError];
        [player setNumberOfLoops:0];
        [player setVolume:1];
        [player prepareToPlay];
        [player play];
    }
    if (indexPath.row == 0) {
        _audio = @"default";
        [YjyxOverallData sharedInstance].studentInfo.notify_sound = _audio;
        number = [NSNumber numberWithInteger:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"S_SOUNDS"];
        
    }else{
        _audio = [NSString stringWithFormat:@"push%ld.caf",(long)indexPath.row];
        [YjyxOverallData sharedInstance].studentInfo.notify_sound = _audio;
        number = [NSNumber numberWithInteger:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"S_SOUNDS"];
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

@end
