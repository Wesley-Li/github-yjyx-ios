//
//  OneSubjectController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OneSubjectController.h"
#import "OneSubjectModel.h"
#import "TitleContentCell.h"
#import "AnswerCell.h"
#import "ReleaseVideoCell.h"
#import "ReleaseExplanationCell.h"
#import "WMPlayer.h"
#import "WrongDataBase.h"
#import "YjyxWrongSubModel.h"
@interface OneSubjectController ()<UITableViewDelegate, UITableViewDataSource>
{
    WMPlayer *wmPlayer;
    NSIndexPath *currentIndexPath;
    BOOL isSmallScreen;
    BOOL isPlay;
}
@property (weak, nonatomic) IBOutlet UIButton *moveToReleaseBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) OneSubjectModel *model;

@property (strong, nonatomic) ReleaseVideoCell *videoCell;
@end

@implementation OneSubjectController
static NSString *TitleID = @"TITLECELL";
static NSString *AnswerID = @"ANSWERCELL";
static NSString *ExplanationID = @"EXPLANATIONCELL";
static NSString *VideoID = @"VIDEOCELL";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    self.title = @"预览作业";
    // 加载返回按钮
    [self loadBackBtn];
    // 加载数据
    [self loadData];
    // 设置tableview的属性
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COMMONCOLOR;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TitleContentCell class]) bundle:nil] forCellReuseIdentifier:TitleID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnswerCell class]) bundle:nil] forCellReuseIdentifier:AnswerID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseVideoCell class]) bundle:nil] forCellReuseIdentifier:VideoID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseExplanationCell class]) bundle:nil] forCellReuseIdentifier:ExplanationID];
    // wmPlayer的设置
    // 初始状态
    isSmallScreen = NO;
    isPlay = NO;
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
    
}
- (void)viewWillAppear:(BOOL)animated
{
    if(_is_select == 0){
        [self.moveToReleaseBtn setTitle:@"出题" forState:UIControlStateNormal];
    }else{
        [self.moveToReleaseBtn setTitle:@"移除本题" forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self releaseWMPlayer];
    [wmPlayer removeFromSuperview];
    [SVProgressHUD dismiss];
}
-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - wmPlayer的方法
-(void)videoDidFinished:(NSNotification *)notice{
    ReleaseVideoCell *currentCell = (ReleaseVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    isPlay = NO;
    currentCell.playBtn.hidden = NO;
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)closeTheVideo:(NSNotification *)obj{
    
    ReleaseVideoCell *currentCell = (ReleaseVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
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
    ReleaseVideoCell *currentCell = (ReleaseVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
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
-(void)startPlayVideo:(UIButton *)sender{
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",(long)currentIndexPath.row);
    
    isPlay = YES;
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.videoCell = (ReleaseVideoCell *)sender.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        self.videoCell = (ReleaseVideoCell *)sender.superview.superview.subviews;
        
    }
    
    //    isSmallScreen = NO;
    if (isSmallScreen) {
        [self releaseWMPlayer];
        isSmallScreen = NO;
        
    }
    if (wmPlayer) {
        [wmPlayer removeFromSuperview];
        wmPlayer.backBtn.hidden = YES;
        [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
        [wmPlayer setVideoURLStr:self.model.videourl];
        [wmPlayer.player play];
    }else{
        wmPlayer = [[WMPlayer alloc]initWithFrame:self.videoCell.backgroundIV.bounds videoURLStr:self.model.videourl];
        wmPlayer.backBtn.hidden = YES;
        
    }
    
    // 将按钮放到底部
    [self.videoCell.backgroundIV addSubview:wmPlayer];
    [self.videoCell.backgroundIV bringSubviewToFront:wmPlayer];
    //    [self.videoCell.playBtn.superview sendSubviewToBack:self.videoCell.playBtn];
    self.videoCell.playBtn.hidden = YES;
    
    [self.tableView reloadData];
    
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
#pragma mark - 私有方法
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_getone";
    param[@"qtype"] = self.qtype;
    param[@"qid"] = self.w_id;
    NSLog(@"%@, %@", self.qtype, self.w_id);
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/mobile/question/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] isEqual:@0]) {
            OneSubjectModel *model = [OneSubjectModel oneSubjectModelWithDict:responseObject];
            self.model = model;
            if ([model.explanation isEqualToString:@""] || [model.videourl isEqualToString:@""]) {
                _count = 4;
            }else{
                _count = 4;
            }
            [self.tableView reloadData];
            
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)moveOrReleaseBtnClick:(UIButton *)sender {
    if([sender.titleLabel.text isEqualToString:@"移除本题"]){
        [[WrongDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", _wrongSubjectModel.questionid]  andQuestionType:[NSString stringWithFormat:@"%ld", _wrongSubjectModel.questiontype]];
    }else{
        [[WrongDataBase shareDataBase] insertQuestion:self.wrongSubjectModel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
       TitleContentCell *cell =  [tableView dequeueReusableCellWithIdentifier:TitleID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        return cell;
    }else if(indexPath.row == 1){
       AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:AnswerID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        return cell;
    }else if (indexPath.row == 2){
        ReleaseExplanationCell *cell = [tableView dequeueReusableCellWithIdentifier:ExplanationID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        return cell;
    }else {
        ReleaseVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoID];
        self.videoCell = cell;
        cell.model = _model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
         cell.playBtn.tag = indexPath.row;
        if([_model.videourl isEqualToString:@""]  ){
           cell.videoLabel.hidden = YES;
        }
        // 按钮的显示
        if (isPlay == YES) {
            cell.playBtn.hidden = YES;
        }else {
            
            cell.playBtn.hidden = NO;
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
        }
        
        if (wmPlayer&&wmPlayer.superview) {
            if (indexPath.row == currentIndexPath.row) {
                [cell.backgroundIV.superview sendSubviewToBack:cell.backgroundIV];
            }else{
    
                
            }
            
            NSArray *indexpaths = [tableView indexPathsForVisibleRows];
            
            if (![indexpaths containsObject:currentIndexPath]&&currentIndexPath!=nil) {//复用
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]) {
                    wmPlayer.hidden = NO;
                }else{
                    wmPlayer.hidden = YES;
                    
                    NSLog(@"%d", isPlay);
           
                }
            }else{
                if ([cell.backgroundIV.subviews containsObject:wmPlayer]) {
                    [cell.backgroundIV addSubview:wmPlayer];
                    
                    [wmPlayer.player play];
                    wmPlayer.hidden = NO;
                }
                
            }
        }

        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return _model.firstCellHeight;
    }else if(indexPath.row == 1){
        return 60;
    }else if(indexPath.row == 2){
        if ([_model.explanation isEqualToString:@""]) {
            return 0;
        }
        return _model.threeCellHeight;
    }else{
        if([_model.videourl isEqualToString:@""] ){
            return 0;
        }
        return (SCREEN_WIDTH)*184/320 + 30;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
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
@end
