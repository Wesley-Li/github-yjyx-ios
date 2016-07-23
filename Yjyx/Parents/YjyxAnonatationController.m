//
//  YjyxAnonatationController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxAnonatationController.h"
#import "VoiceListCell.h"
#import "VoiceConverter.h"


@import AVFoundation;
@import AudioToolbox;
@interface YjyxAnonatationController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger num;
    NSInteger currentIndex;

}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UITableView *voiceList;
@property (strong, nonatomic) NSMutableArray *voiceArr;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSString *playFilePath;


@end

@implementation YjyxAnonatationController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.voiceArr = [[self.processArr[0] objectForKey:@"teachervoice"] mutableCopy];

    [self configureNav];
    num = self.processArr.count;
    [self configureScroll];
    [self configurePageControll];
    
    [_voiceList registerNib:[UINib nibWithNibName:NSStringFromClass([VoiceListCell class]) bundle:nil] forCellReuseIdentifier:@"ID"];
    _voiceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}


- (void)configureNav {

    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.title = [NSString stringWithFormat:@"1/%ld", num];

}

- (void)configureScroll {

    NSLog(@"%@",self.processArr);
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * num, SCREEN_HEIGHT - 64);
    self.scrollview.delegate = self;
    for (int i = 0; i < num; i++) {
        // 做题过程
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        imageview.userInteractionEnabled = YES;
        NSDictionary *dic = self.processArr[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendVoiceListToBackground:)];
        [imageview addGestureRecognizer:tap];
        [imageview setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
        [self.scrollview addSubview:imageview];
        
        // 语音批注
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.frame = CGRectMake(10, 10, 46, 46);
        voiceBtn.tag = 500 + i;
        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
        [voiceBtn addTarget:self action:@selector(showTheVoiceList:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:voiceBtn];
        
        // 语音数量
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 10, 15, 15)];
        numLabel.userInteractionEnabled = NO;
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.text = [NSString stringWithFormat:@"%ld", [[self.processArr[i] objectForKey:@"teachervoice"] count]];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.layer.cornerRadius = 7.5;
        numLabel.layer.masksToBounds = YES;
        [imageview addSubview:numLabel];
        
    }
}


- (void)configurePageControll {

    _pageControll.numberOfPages = num;
    _pageControll.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControll.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_pageControll addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)goBack {
    
    // 清空audio文件
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [directory stringByAppendingPathComponent:@"audio"];
    NSError *error = nil;
    if([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"清除音频文件成功");
    } else {
        NSLog(@"error=%@", error);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    int page = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControll.currentPage = page;
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%ld", page, num];
    self.voiceArr = [[self.processArr[page] objectForKey:@"teachervoice"] mutableCopy];
    [_voiceList reloadData];
    
}

- (void)changePage:(id)sender {

    int page = _pageControll.currentPage;
    self.scrollview.contentOffset = CGPointMake(SCREEN_WIDTH * page, 0);
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%ld", page, num];
    self.voiceArr = [[self.processArr[page] objectForKey:@"teachervoice"] mutableCopy];
    [_voiceList reloadData];
}

- (void)showTheVoiceList:(UITapGestureRecognizer *)sender {

    NSLog(@"点击了声音");
    [self.view bringSubviewToFront:self.voiceList];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.voiceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];
    cell.timeLabel.text = [NSString stringWithFormat:@"%.f''",[[self.voiceArr[indexPath.row] objectForKey:@"time"] floatValue]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceShow:)];
    cell.voiceDelete.hidden = YES;
    [cell.voiceView addGestureRecognizer:tap];
    cell.voiceView.tag = indexPath.row + 200;
    cell.animationImage.tag = indexPath.row + 300;
    
    
    return cell;
}

- (void)sendVoiceListToBackground:(UITapGestureRecognizer *)sender {

    [self.view sendSubviewToBack:self.voiceList];
    
}

#pragma mark - 音频播放
// 音频播放
- (void)voiceShow:(UITapGestureRecognizer *)sender {
    
    VoiceListCell *cell = (VoiceListCell *)sender.view.superview.superview;
    NSURL *url = [NSURL URLWithString:[_voiceArr[sender.view.tag - 200] objectForKey:@"url"]];
    [self changeAMRtoWAVbyUrl:url];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.playFilePath]];
    
    NSLog(@"%@", self.voiceArr);
    
    if (self.player) {
        if (currentIndex == sender.view.tag - 200) {
            [_player pause];
            [cell.animationImage stopAnimating];
            _player = nil;
        }else {
            
            [_player pause];
            currentIndex = sender.view.tag - 200;
            UIImageView *imageview = (UIImageView *)[self.view viewWithTag:currentIndex + 300];
            [imageview stopAnimating];
            [_player play];
            currentIndex = sender.view.tag - 200;
            [cell.animationImage startAnimating];
            
        }
    }else {
        
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [_player play];
        [cell.animationImage startAnimating];
        currentIndex = sender.view.tag - 200;
    }
    
}

// 播放结束,自动播放下一句
- (void)playDidEnd:(NSNotification *)sender {
    
    if (currentIndex < self.voiceArr.count - 1) {
        currentIndex++;
        UIImageView *imageview = (UIImageView *)[self.view viewWithTag:currentIndex - 1 + 300];
        [imageview stopAnimating];
        [_player pause];
        NSURL *url = [NSURL URLWithString:[_voiceArr[currentIndex] objectForKey:@"url"]];
        [self changeAMRtoWAVbyUrl:url];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.playFilePath]];
        [_player replaceCurrentItemWithPlayerItem:playerItem];
        [_player play];
        UIImageView *imageview2 = (UIImageView *)[self.view viewWithTag:currentIndex + 300];
        [imageview2 startAnimating];
        
        
    }else {
        
        [self.view makeToast:@"最后一句已经播放完毕" duration:1.0 position:SHOW_CENTER complete:nil];
        UIImageView *imageview = (UIImageView *)[self.view viewWithTag:currentIndex + 300];
        [imageview stopAnimating];
        
    }
    
    
    
}

// 获取amr音频并转码
- (void)changeAMRtoWAVbyUrl:(NSURL *)url {
    
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    NSString *amrPath = [YjyxAnonatationController getPathByFilename:[YjyxAnonatationController getCurrentTimeString] ofType:@"amr"];
    [audioData writeToFile:amrPath atomically:YES];
    self.playFilePath = [YjyxAnonatationController getPathByFilename:[YjyxAnonatationController getCurrentTimeString] ofType:@"wav"];
    int result = [VoiceConverter ConvertAmrToWav:amrPath wavSavePath:_playFilePath];
    NSLog(@"%@", result == 1 ? @"格式转换成功" : @"格式转换失败");
    
}

#pragma mark - voice recording

#pragma mark - 生成当前时间
+ (NSString *)getCurrentTimeString {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormat stringFromDate:[NSDate date]];
}

#pragma mark - 生成文件路径
+ (NSString *)getPathByFilename:(NSString *)fileName ofType:(NSString *)type {
    
    // 创建audio文件夹
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *audioPath = [NSString stringWithFormat:@"%@/audio", directory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [[[audioPath stringByAppendingPathComponent: fileName] stringByAppendingPathExtension:type] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return filePath;
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
