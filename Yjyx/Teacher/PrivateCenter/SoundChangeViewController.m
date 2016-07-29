//
//  SoundChangeViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SoundChangeViewController.h"

@interface SoundChangeViewController ()

{

    NSNumber *number;
}

@end

@implementation SoundChangeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

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
    [[NSUserDefaults standardUserDefaults]setValue:[YjyxOverallData sharedInstance].teacherInfo.notify_sound forKey:@"T_SOUND"];
      [YjyxOverallData sharedInstance].teacherInfo.notify_sound = _audio;
    // 上报消息设置
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"notify_setting",@"action",[YjyxOverallData sharedInstance].teacherInfo.receive_notify,@"receive_notify",[YjyxOverallData sharedInstance].teacherInfo.notify_with_sound,@"with_sound",_audio,@"sound",[YjyxOverallData sharedInstance].teacherInfo.notify_shake,@"vibrate", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    [manager POST:[BaseURL stringByAppendingString:TEACHER_UPLOAD_SOUND_SETTING_CONNECT_POST] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       
//        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
//        NSLog(@"%@", error);
    }];
    
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"%ld, %ld", [[[NSUserDefaults standardUserDefaults] objectForKey:@"T_SOUNDS"] integerValue], [[[NSUserDefaults standardUserDefaults] objectForKey:@"SOUNDS"] integerValue]);
    
//    if (indexPath.row == [[[NSUserDefaults standardUserDefaults] objectForKey:@"T_SOUNDS"] integerValue]) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//        defaultIndex = indexPath;
//    }
    
    if([_audio isEqualToString:[sounds objectAtIndex:indexPath.row]]){
        UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:defaultIndex];
        cell1.accessoryType = UITableViewCellAccessoryNone;
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
//        [YjyxOverallData sharedInstance].teacherInfo.notify_sound = _audio;
        number = [NSNumber numberWithInteger:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"T_SOUNDS"];
        
    }else{
        _audio = [NSString stringWithFormat:@"push%ld.caf",(long)indexPath.row];
//        [YjyxOverallData sharedInstance].teacherInfo.notify_sound = _audio;
        number = [NSNumber numberWithInteger:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"T_SOUNDS"];

    }


}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
