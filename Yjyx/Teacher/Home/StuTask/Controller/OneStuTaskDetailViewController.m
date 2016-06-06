//
//  OneStuTaskDetailViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OneStuTaskDetailViewController.h"

#import "TaskCell.h"
#import "CorectCell.h"
#import "SolutionCell.h"
#import "VideoCell.h"
#import "YourAnswerCell.h"
#import "WMPlayer.h"

#define kidentifier1 @"kCell1"
#define kidentifier2 @"kCell2"
#define Kidentifier3 @"kCell3"
#define Kidentifier4 @"kCell4"
#define Kidentifier5 @"kCell5"


@interface OneStuTaskDetailViewController ()

{
    WMPlayer *wmPlayer;
    NSIndexPath *currentIndexPath;
    BOOL isSmallScreen;
    BOOL isPlay;
    NSInteger _rows;
    NSString *_explanation;
    NSString *_videourl;
    
}

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) TaskCell *taskCell;
@property (nonatomic, strong) YourAnswerCell *yourAnswerCell;
@property (nonatomic, strong) CorectCell *corectCell;
@property (nonatomic, strong) SolutionCell *solutionCell;
@property (nonatomic, strong) VideoCell *videoCell;

@end

@implementation OneStuTaskDetailViewController

-(BOOL)prefersStatusBarHidden{
    if (wmPlayer) {
        if (wmPlayer.isFullscreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}


-(void)videoDidFinished:(NSNotification *)notice{
    VideoCell *currentCell = (VideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    currentCell.playBtn.hidden = NO;
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)closeTheVideo:(NSNotification *)obj{
    VideoCell *currentCell = (VideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    currentCell.playBtn.hidden = NO;
    isPlay = NO;
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                if (isSmallScreen) {
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }else{
                    [self toCell];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                wmPlayer.isFullscreen = YES;
                
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                wmPlayer.isFullscreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}


-(void)toCell{
    VideoCell *currentCell = (VideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [wmPlayer removeFromSuperview];
    NSLog(@"row = %ld",(long)currentIndexPath.row);
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = currentCell.backgroundIV.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [currentCell.backgroundIV addSubview:wmPlayer];
        [currentCell.backgroundIV bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(SCREEN_WIDTH-40);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-SCREEN_HEIGHT/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toSmallScreen{
    //放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-60-(SCREEN_WIDTH/2)*0.575, SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*0.575);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        wmPlayer.fullScreenBtn.selected = NO;
        isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
    }];
    
}


// 强制加载单个cell
- (void)viewDidAppear:(BOOL)animated {

    if (_rows != 0) {
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:3 inSection:0];
        NSArray *indexPathArray = [NSArray arrayWithObjects:indexPath1,indexPath2, nil];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    // 初始状态
    isSmallScreen = NO;
    
    // 申请网络
    [self readDataFromNetWork];
    
    // 注册cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskCell" bundle:nil] forCellReuseIdentifier:kidentifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"YourAnswerCell" bundle:nil] forCellReuseIdentifier:kidentifier2];
    [self.tableView registerNib:[UINib nibWithNibName:@"CorectCell" bundle:nil] forCellReuseIdentifier:Kidentifier3];
    [self.tableView registerNib:[UINib nibWithNibName:@"SolutionCell" bundle:nil] forCellReuseIdentifier:Kidentifier4];
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:Kidentifier5];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];
    
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeTheVideo:)
                                                 name:WMPlayerClosedNotification
                                               object:nil
     ];
    

    self.view.backgroundColor = RGBACOLOR(239, 239, 244,1);

}

#pragma mark - 网络请求
- (void)readDataFromNetWork {

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getonequestiondetailforonestudent", @"action", self.taskid, @"taskid", self.suid, @"suid", self.qtype, @"qtype", self.qid, @"qid", nil];
    NSLog(@"%@", dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[BaseURL stringByAppendingString:TEACHER_DETAIL_ONESTU_ONETASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        _explanation = responseObject[@"question"][@"explanation"];
        _videourl = responseObject[@"question"][@"videourl"];
        if ([responseObject[@"retcode"] isEqual: @0]) {
            
            self.dic = [NSDictionary dictionaryWithDictionary:responseObject];
            
        }else {
            
            [self.tableView makeToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] duration:1.0 position:SHOW_CENTER complete:nil];
        }
//        if ([responseObject[@"question"][@"videourl"] isEqualToString: @""]&&[responseObject[@"question"][@"explanation"] isEqualToString:@""]) {
//            _rows = 0;
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//            imageV.image = [UIImage imageNamed:@"wrong"];
//            self.tableView.tableFooterView = (UIView *)imageV;
//        }else{
//            _rows = 5;
//        }
        _rows = 5;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
       
        
        _rows = 0;
        [self.tableView reloadData];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        
        imageV.image = [UIImage imageNamed:@"wrong"];
        
        self.tableView.tableFooterView = (UIView *)imageV;
        self.tableView.scrollEnabled = NO;
        NSLog(@"%@", error);
        
    }];

    
}

- (void)goBack {
    
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

    return _rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.taskCell = [tableView dequeueReusableCellWithIdentifier:kidentifier1 forIndexPath:indexPath];
        _taskCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_taskCell setValueWithDictionary:self.dic];
        return _taskCell;
    }else if (indexPath.row == 1) {
    
        self.yourAnswerCell = [tableView dequeueReusableCellWithIdentifier:kidentifier2 forIndexPath:indexPath];
        _yourAnswerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.qtype isEqual:@1]) {
            
            [_yourAnswerCell setChoiceValueWithDictionary:_dic];
        }else if ([self.qtype isEqual:@2]) {
        
            [_yourAnswerCell setBlankfillValueWithDictionary:_dic];
        }
        
        return _yourAnswerCell;
    }else if (indexPath.row == 2) {
        
        self.corectCell = [tableView dequeueReusableCellWithIdentifier:Kidentifier3 forIndexPath:indexPath];
        _corectCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.qtype isEqual:@1]) {
            [_corectCell setChoiceValueWithDictionary:_dic];
            
        }else {
            
            [_corectCell setBlankfillValueWithDictionary:_dic];
            
        }
        return _corectCell;
        
    }else if (indexPath.row == 3) {
        
        self.solutionCell = [tableView dequeueReusableCellWithIdentifier:Kidentifier4 forIndexPath:indexPath];
        if([_explanation isEqualToString:@""]  ){
            _solutionCell.solutionLabel.hidden = YES;
        }
        _solutionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_solutionCell setSolutionValueWithDiction:self.dic];
        return _solutionCell;
    }else {
        
        self.videoCell = [tableView dequeueReusableCellWithIdentifier:Kidentifier5 forIndexPath:indexPath];
        
        [_videoCell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        _videoCell.playBtn.tag = indexPath.row;
        if([_videourl isEqualToString:@""]  ){
            _videoCell.videoLabel.hidden = YES;
        }
        // 按钮的显示
        if (isPlay == YES) {
            _videoCell.playBtn.hidden = YES;
        }else {
            
            _videoCell.playBtn.hidden = NO;
            [_videoCell.playBtn.superview bringSubviewToFront:_videoCell.playBtn];
        }

        
        if (wmPlayer&&wmPlayer.superview) {
            if (indexPath.row == currentIndexPath.row) {
                [_videoCell.backgroundIV.superview sendSubviewToBack:_videoCell.backgroundIV];
            }else{
                [_videoCell.backgroundIV.superview bringSubviewToFront:_videoCell.backgroundIV];
            }
            NSArray *indexpaths = [tableView indexPathsForVisibleRows];
            if (![indexpaths containsObject:currentIndexPath]&&currentIndexPath!=nil) {//复用
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]) {
                    wmPlayer.hidden = NO;
                }else{
                    wmPlayer.hidden = YES;
                    [_videoCell.backgroundIV.superview bringSubviewToFront:_videoCell.backgroundIV];
                }
            }else{
                if ([_videoCell.backgroundIV.subviews containsObject:wmPlayer]) {
                    [_videoCell.backgroundIV addSubview:wmPlayer];
                    
                    [wmPlayer.player play];
                    wmPlayer.hidden = NO;
                }
                
            }
        }
        
        return _videoCell;
    }


}

/**
 *  开始播放
 */
-(void)startPlayVideo:(UIButton *)sender{
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",(long)currentIndexPath.row);
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.videoCell = (VideoCell *)sender.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        self.videoCell = (VideoCell *)sender.superview.superview.subviews;
        
    }
    
    //    isSmallScreen = NO;
    if (isSmallScreen) {
        [self releaseWMPlayer];
        isSmallScreen = NO;
        
    }
    if (wmPlayer) {
        [wmPlayer removeFromSuperview];
        [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
        [wmPlayer setVideoURLStr:[_dic[@"question"] objectForKey:@"videourl"]];
        wmPlayer.backBtn.hidden = YES;
        [wmPlayer.player play];
    }else{
        wmPlayer = [[WMPlayer alloc]initWithFrame:self.videoCell.backgroundIV.bounds videoURLStr:[_dic[@"question"] objectForKey:@"videourl"]];
        wmPlayer.backBtn.hidden = YES;
        
    }
    
    // 将按钮放到底部
    [self.videoCell.backgroundIV addSubview:wmPlayer];
    [self.videoCell.backgroundIV bringSubviewToFront:wmPlayer];
    //    [self.videoCell.playBtn.superview sendSubviewToBack:self.videoCell.playBtn];
    isPlay = YES;
    self.videoCell.playBtn.hidden = YES;
    [self.tableView reloadData];
    
}



#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView ==self.tableView){
        if (wmPlayer==nil) {
            return;
        }
        
        if (wmPlayer.superview) {
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:currentIndexPath];
            CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            if (rectInSuperview.origin.y<-self.videoCell.backgroundIV.frame.size.height||rectInSuperview.origin.y>SCREEN_HEIGHT-64-60) {//往上拖动
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]&&isSmallScreen) {
                    isSmallScreen = YES;
                }else{
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }
                
            }else{
                if ([self.videoCell.backgroundIV.subviews containsObject:wmPlayer]) {
                    
                }else{
                    [self toCell];
                }
            }
        }
        
    }
}


/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    [wmPlayer.player pause];
    
    //移除观察者
    [wmPlayer.currentItem removeObserver:wmPlayer forKeyPath:@"status"];
    
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    [wmPlayer.durationTimer invalidate];
    wmPlayer.durationTimer = nil;
    
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}



-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player dealloc");
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return _taskCell.height;
    }else if (indexPath.row == 1) {
        return 50;
    }else if (indexPath.row == 2) {
        return _corectCell.height;
    }else if (indexPath.row == 3) {
        if ([_explanation isEqualToString:@""]) {
            return 0;
        }
        return _solutionCell.height;
    }else {
        if ([_videourl isEqualToString:@""]) {
            return 0;
        }
        return (SCREEN_WIDTH)*184/320 + 20;
    }
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
