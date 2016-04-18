//
//  YjyxSoundViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxSoundViewController.h"

@interface YjyxSoundViewController ()

@end

@implementation YjyxSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    [self setTitle:@"设置提示音"];
    //    sounds = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                                                          @"push1",NSLocalizedString(@"Push1", @""),
    //                                                          @"push2",NSLocalizedString(@"Push2", @""),
    //                                                          @"push3",NSLocalizedString(@"Push3", @""),
    //                                                          @"push4",NSLocalizedString(@"Push4", @""),
    //                                                          @"push5",NSLocalizedString(@"Push5", @""),
    //                                                          @"push6",NSLocalizedString(@"Push6", @""),
    //              @"push7",NSLocalizedString(@"Push7", @""),nil];
    sounds = [[NSMutableArray alloc] initWithObjects:@"默认",@"三全音",@"管钟琴",@"玻璃",@"圆号",@"铃音",@"电子乐", nil];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [sureBtn addTarget:self action:@selector(goSure) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setImage:[UIImage imageNamed:@"comm_sure"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [APP_WINDOW hideToastActivity];
}

- (void)goSure
{
    [self.delegate selectSoundWith:_audio];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sounds count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell.textLabel setText:[sounds  objectAtIndex:indexPath.row]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    if ([_audio isEqualToString:NSLocalizedString(@"push7", nil)]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        defaultIndex = indexPath;
    }
    
    if([_audio isEqualToString:[sounds objectAtIndex:indexPath.row]]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        defaultIndex = indexPath;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if (indexPath != defaultIndex && defaultIndex != nil) {
        UITableViewCell *defaultCell = [tableView cellForRowAtIndexPath:defaultIndex];
        [defaultCell setAccessoryType:UITableViewCellAccessoryNone];
        defaultIndex = nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"push%ld",(long)indexPath.row] ofType:@"caf"];
    if (path) {
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
    }else{
        _audio = [NSString stringWithFormat:@"push%ld.caf",(long)indexPath.row];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

@end
