//
//  YjyxMicroClassViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxMicroClassViewController.h"
#import "WMPlayer.h"
#import "RCLabel.h"
#import "PMicroPreviewModel.h"
#import "MicroCell.h"
#import "YjyxCommonNavController.h"
#import "YjyxDoingWorkModel.h"
#import "YjyxDoingWorkController.h"
#define ID @"cell"
@interface YjyxMicroClassViewController ()<UIWebViewDelegate>
{
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    UIImageView *videoImage;
    UIScrollView *_contentScroll;
    UIView *_knowledgeView;
    UILabel *_namelb;
    NSDictionary *lessDic;
    UIView *headerView;
    NSInteger lastSelectedVideoTag;
    NSTimeInterval lastPlayingTaskInterval;
}

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSMutableArray *videoURLArr;
@property (nonatomic, copy) NSString *microName;
@property (nonatomic, copy) NSString *knowledgeName;

@property (nonatomic, strong) NSMutableDictionary *choiceCellHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillHeightDic;
@property (nonatomic, strong) NSMutableArray *microArr;// 微课视频数组

@property (assign, nonatomic) NSInteger jumpType;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *preBtn;

@property (strong, nonatomic) NSMutableArray *doWorkArr;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) UIView *bgView; // 保存视频个数的背景view
@property (strong, nonatomic) NSNumber *subject_id; // 科目id
@end

@implementation YjyxMicroClassViewController

- (NSMutableArray *)choices {

    if (!_choices) {
        self.choices = [NSMutableArray array];
    }
    return _choices;
}

- (NSMutableArray *)blankfills {

    if (!_blankfills) {
        self.blankfills = [NSMutableArray array];
    }
    return _blankfills;
}


-(BOOL)prefersStatusBarHidden{
    if(self.jumpType == 1){
        return YES;
    }else{
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
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        lastSelectedVideoTag = -1;
//        //注册播放完成通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
//        //注册播放完成通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    if(self.jumpType == 1){
        self.navigationController.navigationBar.barTintColor = STUDENTCOLOR;
        self.submitBtn.hidden = NO;
    }else{
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    if(self.jumpType == 1){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [videoImage removeFromSuperview];
    [wmPlayer removeFromSuperview];
    [self releaseWMPlayer];
    [super viewDidDisappear:animated];
}

-(void)videoDidFinished:(NSNotification *)notice{

    if(wmPlayer.isFullscreen == YES){
        [self toNormal];
    }

//    currentCell.playBtn.hidden = NO;
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [videoImage removeFromSuperview];
    [self configureWMPlayer];
    wmPlayer.isPlay = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)closeTheVideo:(NSNotification *)obj{
   
    lastSelectedVideoTag = -1;
    wmPlayer.closeBtn.hidden = YES;
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [videoImage removeFromSuperview];
    [self configureWMPlayer];
    wmPlayer.isPlay = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}


-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [wmPlayer removeFromSuperview];
    [videoImage removeFromSuperview];
    videoImage.transform = CGAffineTransformIdentity;
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        videoImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        videoImage.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }

    wmPlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    videoImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    if (wmPlayer.isPlay) {
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        wmPlayer.playOrPauseBtn.selected = NO;
    }else {
        wmPlayer.playOrPauseBtn.selected = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [[UIApplication sharedApplication].keyWindow addSubview:videoImage];
    }
    

    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)toNormal{
    [wmPlayer removeFromSuperview];
    [videoImage removeFromSuperview];
//    _namelb.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//    _knowledgeView.frame = CGRectMake(0, _namelb.frame.origin.y + 50, SCREEN_WIDTH, 60);
    

    [UIView animateWithDuration:0.5f animations:^{
        videoImage.transform = CGAffineTransformIdentity;
        if(self.jumpType == 1){// 学生
            videoImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4);
        }else {
            videoImage.frame = CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4);
        }
        
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.view insertSubview:wmPlayer belowSubview:_backBtn];
        [self.view insertSubview:videoImage belowSubview:_backBtn];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wmPlayer).with.offset(-10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
         
    }completion:^(BOOL finished) {
//        _contentScroll.frame = CGRectMake(0, 64 + playerFrame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - playerFrame.size.height -64);
//        _namelb.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//        _knowledgeView.frame = CGRectMake(0, _namelb.frame.origin.y + 50, SCREEN_WIDTH, 60);
        NSLog(@"%@", NSStringFromCGRect(_namelb.frame));
        NSLog(@"%@", NSStringFromCGRect(_contentScroll.frame));
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        
    }];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
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
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.choices = [NSMutableArray array];
//    self.blankfills = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 50, 50);
    [_backBtn setImage:[UIImage imageNamed:@"Parent_VideoBack"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    [self.view bringSubviewToFront:_backBtn];
    
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadBackBtn];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    self.choiceCellHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillHeightDic = [[NSMutableDictionary alloc] init];
    
    _doWorkArr = [NSMutableArray array];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //注册全屏播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];
    
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeTheVideo:)
                                                 name:WMPlayerClosedNotification
                                               object:nil
     ];

    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight:) name:@"cellHeighChange" object:nil];
    
    if([self.navigationController isKindOfClass:[YjyxCommonNavController class]]){
        self.jumpType = 1;
        
        [self loadData];
    }else{
         [self getchildResult:_previewRid];
    }
}


- (void)refreshCellHeight:(NSNotification *)sender {
    
    MicroCell *cell = [sender object];
    
    // 保存高度
    if (cell.indexPath.section == 0) {
        
        if (![self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||fabs([[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2)
        {
            [self.choiceCellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.subjectTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else {
        if (![self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||fabs([[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2)
        {
            [self.blankfillHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.subjectTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    if(wmPlayer == nil){
        
        return;
    }
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [wmPlayer.player.currentItem cancelPendingSeeks];
        [wmPlayer.player.currentItem.asset cancelLoading];
        [wmPlayer.player pause];
        
        //移除观察者
        [wmPlayer.currentItem removeObserver:wmPlayer forKeyPath:@"status"];
        
    //    [wmPlayer removeFromSuperview];
    //    [wmPlayer.playerLayer removeFromSuperlayer];
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
    });
    
}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    if(_jumpType == 1){
//    [self releaseWMPlayer];
//    }
//}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player deallco");
}

#pragma mark -Request
-(void)getchildResult:(NSString *)previewrid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:previewrid,@"rid", @"2",@"tasktype",@"preview",@"action",nil];
    [[YjxService sharedInstance] getChildrenPreviewResult:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            NSLog(@"%@", result);
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                
                NSLog(@"%@", [[result[@"lessonobj"] objectForKey:@"videoobjlist"] JSONValue]);
                // 视频和表头信息
                self.microArr = [[[result[@"lessonobj"] objectForKey:@"videoobjlist"] JSONValue] mutableCopy];
                self.videoURL = [[[[result[@"lessonobj"] objectForKey:@"videoobjlist"] JSONValue] firstObject] objectForKey:@"url"];
                self.videoURLArr = [[result[@"lessonobj"] objectForKey:@"videoobjlist"] JSONValue];
                self.microName = [result[@"lessonobj"] objectForKey:@"name"];
                self.knowledgeName = [result[@"lessonobj"] objectForKey:@"knowledgedesc"];
                // 配置视频
                [self configureWMPlayer];
                
                // tableview数据源
                // 选择题
                NSArray *choiceArr = [[result[@"questions"] objectForKey:@"choice"] objectForKey:@"questionlist"];
                for (NSDictionary *dic in choiceArr) {
                    PMicroPreviewModel *model = [[PMicroPreviewModel alloc] init];
                    [model initModelWithDic:dic];
                    [self.choices addObject:model];
                }
                
                // 填空题
                NSArray *blankfillArr = [[result[@"questions"] objectForKey:@"blankfill"] objectForKey:@"questionlist"];
                for (NSDictionary *dic in blankfillArr) {
                    PMicroPreviewModel *model = [[PMicroPreviewModel alloc] init];
                    [model initModelWithDic:dic];
                    [self.blankfills addObject:model];
                }
                
                // 配置tableview
                [self configureTableview];
                [self.subjectTable registerNib:[UINib nibWithNibName:NSStringFromClass([MicroCell class]) bundle:nil] forCellReuseIdentifier:ID];
                
                // 配置表头
                [self configureTableviewHeaderview];
                
                [self.subjectTable reloadData];
                
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
            
            
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

- (void)loadData{
    [self.view makeToastActivity:SHOW_CENTER];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_get_task_lesson_preview_data";
    param[@"taskid"] = self.taskid;
    param[@"lessonid"] = self.lessonid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        [self.view hideToastActivity];
            
            if ([[responseObject objectForKey:@"retcode"] integerValue] == 0) {
                self.subject_id = responseObject[@"retobj"][@"lessonobj"][@"subjectid"];
                for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"]) {
                    //                [responseObject[@"retobj"][@"lessonobj"][@"quizcontent"] JSONValue][@"questionList"]
                    YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                    model.questiontype = 1;
                    [self.doWorkArr addObject:model];
                }
                for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"]) {
                    YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                    model.questiontype = 2;
                    [self.doWorkArr addObject:model];
                }
                if(self.doWorkArr.count == 0){
                   [self.view makeToast:@"题目已经被老师删除了" duration:3.0 position:SHOW_CENTER complete:nil];
                    
                }
                NSInteger i = 0;
                for (NSArray *arr in [responseObject[@"retobj"][@"lessonobj"][@"quizcontent"] JSONValue][@"questionList"]) {
                    if(arr.count == 0){
                        continue;
                    }
                    if ([arr[0] isEqualToString:@"choice"]) {
                        for (NSDictionary *dict in arr[1]) {
                            if(i >= self.doWorkArr.count){
                                continue;
                            }
                            YjyxDoingWorkModel *model = self.doWorkArr[i];
                            if([dict[@"id"] isEqual:model.t_id]){
                            model.requireprocess = dict[@"requireprocess"];
                            i++;
                            }
                        }
                    }
                    if ([arr[0] isEqualToString:@"blankfill"]) {
                        for (NSDictionary *dict in arr[1]) {
                            if(i >= self.doWorkArr.count){
                                continue;
                            }
                            YjyxDoingWorkModel *model = self.doWorkArr[i];
                            if([dict[@"id"] isEqual:model.t_id]){
                            model.requireprocess = dict[@"requireprocess"];
                            i++;
                            }
                        }
                    }
                }

                // 视频和表头信息
                self.microArr = [[responseObject[@"retobj"][@"lessonobj"][@"videoobjlist"] JSONValue] mutableCopy];
                self.videoURL = [[responseObject[@"retobj"][@"lessonobj"][@"videoobjlist"] JSONValue] firstObject][@"url"];
                self.videoURLArr = [responseObject[@"retobj"][@"lessonobj"][@"videoobjlist"] JSONValue];
                self.microName = responseObject[@"retobj"][@"lessonobj"][@"name"];
                self.knowledgeName = responseObject[@"retobj"][@"lessonobj"][@"knowledgedesc"];
                // 配置视频
                [self configureWMPlayer];
                
                // tableview数据源
                // 选择题
                NSArray *choiceArr = responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"];
                for (NSDictionary *dic in choiceArr) {
                    PMicroPreviewModel *model = [[PMicroPreviewModel alloc] init];
                    [model initModelWithDic:dic];
                    [self.choices addObject:model];
                }
                
                // 填空题
                NSArray *blankfillArr = responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"];
                for (NSDictionary *dic in blankfillArr) {
                    PMicroPreviewModel *model = [[PMicroPreviewModel alloc] init];
                    [model initModelWithDic:dic];
                    [self.blankfills addObject:model];
                }
                
                // 配置tableview
                [self configureTableview];
                [self.subjectTable registerNib:[UINib nibWithNibName:NSStringFromClass([MicroCell class]) bundle:nil] forCellReuseIdentifier:ID];
                
                // 配置表头
                [self configureTableviewHeaderview];
                
                [self.subjectTable reloadData];
            }else{
                
                [self.view makeToast:@"获取作业失败" duration:0.5 position:SHOW_CENTER complete:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                self.submitBtn.userInteractionEnabled = NO;
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        [self.view makeToast:@"获取作业失败" duration:0.5 position:SHOW_CENTER complete:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.submitBtn.userInteractionEnabled = NO;
        
    }];
}
// 做作业按钮被点击
- (IBAction)doWorkBtnClick:(UIButton *)sender {
    YjyxDoingWorkController *vc = [[YjyxDoingWorkController alloc] init];
    vc.desc = self.navigationItem.title;
    vc.workTitle = self.workDesc;
    vc.type = @2;
    vc.jumpDoworkArr = self.doWorkArr;
    vc.taskid = self.taskid;
    vc.examid =  self.lessonid;
    vc.subject_id = self.subject_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 配置视频
- (void)configureWMPlayer {

    if (self.videoURL != nil || self.videoURL.length != 0) {
    
        playerFrame = CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320);
        if (self.jumpType == 1) {
            playerFrame.origin.y = 0;
        }
        if (wmPlayer == nil) {
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:self.videoURL];
            
            [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(wmPlayer).with.offset(-10);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(30);
                make.top.equalTo(wmPlayer).with.offset(5);
            }];
            
            wmPlayer.layer.masksToBounds = YES;
        }
        else{
            [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
            [wmPlayer setVideoURLStr:self.videoURL];
        }

        wmPlayer.closeBtn.hidden = YES;
        [self.view addSubview:wmPlayer];
        wmPlayer.isPlay = NO;
        [wmPlayer.player pause];
        
        if (videoImage == nil) {
            videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4)];
            videoImage.image = [UIImage imageNamed:@"Common_video.png"];
            videoImage.layer.masksToBounds = YES;
            videoImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playvideo)];
            [videoImage addGestureRecognizer:tap];
        }
        [self.view addSubview:videoImage];
        [self.view bringSubviewToFront:_backBtn];
        
        if (self.jumpType == 1) {
            videoImage.y = 0;
        }
    }
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 配置tableview 
- (void)configureTableview {

    self.subjectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, playerFrame.size.height + 64, SCREEN_WIDTH, SCREEN_HEIGHT - playerFrame.size.height - 64) style:UITableViewStylePlain];
    _subjectTable.dataSource = self;
    _subjectTable.delegate = self;
    _subjectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(self.jumpType == 1){
        self.subjectTable.y = playerFrame.size.height;
        self.subjectTable.height = SCREEN_HEIGHT - playerFrame.size.height - 49;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_subjectTable];
    
}

#pragma mark - 配置tableview表头视图
- (void)configureTableviewHeaderview {

    headerView = [[UIView alloc] init];
    headerView.backgroundColor = COMMONCOLOR;
    
    // name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.text = self.microName;
    [headerView addSubview:nameLabel];
    
    // 多视频选择按钮
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    CGSize size = CGSizeMake(10, 5);// 初始位置
    CGFloat padding = 10;// 间距
    NSInteger num = 6;
    CGFloat tWidth = (SCREEN_WIDTH - 20 -(num - 1)*padding)/num;
    CGFloat tHeight = tWidth;
    if (self.microArr.count > 1) {
        for (int i = 0; i < self.microArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(size.width, size.height, tWidth, tHeight);
            size.width += tWidth + padding;
            if (SCREEN_WIDTH - 20 - size.width <= 0) {
                size.width = 10;
                if (self.microArr.count - i > 1) {
                    size.height += tHeight + 10;
                }
            }
            button.tag = 500 + i;
            button.tintColor = [UIColor lightGrayColor];
            if (button.tag == 500) {
                self.preBtn = button;
                button.backgroundColor = [UIColor lightGrayColor];
                button.tintColor = [UIColor whiteColor];
                
            }
            [button setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            button.layer.cornerRadius = tWidth / 2;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [button addTarget:self action:@selector(microNumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
        }
 
    }
    CGFloat bgviewHeight = self.microArr.count >1 ? size.height + tHeight + 5 : 0;
    bgView.frame = CGRectMake(0, nameLabel.origin.y + 40 + 1, SCREEN_WIDTH, bgviewHeight);
    [headerView addSubview:bgView];
    
    // 知识清单
    UILabel *kowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView.origin.y + bgView.height + 5, SCREEN_WIDTH, 40)];
    kowLabel.backgroundColor = [UIColor whiteColor];
    kowLabel.text = @"知识清单";
    [headerView addSubview:kowLabel];
    
    // 清单内容
    NSString *content = _knowledgeName;
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, kowLabel.origin.y + 40, SCREEN_WIDTH, 10)];
    web.scrollView.scrollEnabled = NO;
    web.detectsPhoneNumbers = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.delegate = self;
    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    content = [content  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", content];
    [web loadHTMLString:jsString baseURL:nil];
   
    [headerView addSubview:web];
    
//    UIView *videoNumView = [[UIView alloc] initWithFrame:CGRectMake(0, kowLabel.origin.y + 50, SCREEN_WIDTH, 80)];
//    [headerView addSubview:videoNumView];
//    videoNumView.backgroundColor = [UIColor whiteColor];
//    self.bgView = videoNumView;
  
    headerView.frame = CGRectMake(0, playerFrame.size.height + 64, SCREEN_WIDTH, web.origin.y + web.height + 5);
    
    self.subjectTable.tableHeaderView = headerView;
    
//    CGFloat margin = 15;
//    CGFloat btnWH = (SCREEN_WIDTH - 6 * margin) / 5;
//    for (int i = 0; i < self.videoURLArr.count; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btn.frame = CGRectMake(margin + (margin + btnWH) * i, 40 - btnWH / 2, btnWH, btnWH);
//        btn.layer.cornerRadius = btnWH / 2;
//        btn.layer.borderWidth = 1;
//        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        btn.tag = i;
//        if (btn.tag == 0) {
//            self.preBtn = btn;
//            btn.backgroundColor = [UIColor lightGrayColor];
//            btn.layer.borderWidth = 0;
//        }
//        [btn addTarget:self action:@selector(videoNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [videoNumView addSubview:btn];
//    }
    
}

- (void)microNumButtonClick:(UIButton *)sender {
    if (lastSelectedVideoTag == sender.tag) { //点击同个视频，忽略
        return;
    }
    lastSelectedVideoTag = sender.tag;

    self.videoURL = [self.microArr[sender.tag - 500] objectForKey:@"url"];
    [wmPlayer.player pause];
    wmPlayer.isPlay = NO;

    self.preBtn.backgroundColor = [UIColor whiteColor];
    self.preBtn.tintColor = [UIColor lightGrayColor];
    sender.backgroundColor = [UIColor lightGrayColor];
    self.preBtn.selected = NO;
    sender.selected = YES;
    self.preBtn = sender;
    
    lastPlayingTaskInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeIntervalLocal = lastPlayingTaskInterval;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //延迟0.5秒播放，防止暴力点击
        if (lastPlayingTaskInterval > timeIntervalLocal) { //有新播放任务，放弃本次播放任务
            NSLog(@"有新播放任务，放弃本次播放任务");
            return;
        }
        
        NSLog(@"延时播放开始，对应按钮号：%ld",lastSelectedVideoTag);
        
        [wmPlayer removeFromSuperview];
        [videoImage removeFromSuperview];
        [self configureWMPlayer];
        [wmPlayer.player play];
        wmPlayer.isPlay = YES;
        wmPlayer.closeBtn.hidden = NO;
        [self.view sendSubviewToBack:videoImage];
        [self.view bringSubviewToFront:_backBtn];
    });
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if (img.width > %f) {\
    img.style.maxWidth = %f; \
    }\
    } \
    }";
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 40, SCREEN_WIDTH - 40];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    headerView.frame = CGRectMake(0, playerFrame.size.height + 64, SCREEN_WIDTH, webView.origin.y + webView.frame.size.height + 5);

    self.subjectTable.tableHeaderView = headerView;
}
// 多视频按钮的点击
- (void)videoNumBtnClick:(UIButton *)btn
{
    self.preBtn.backgroundColor = [UIColor whiteColor];
    self.preBtn.layer.borderWidth = 1;
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.borderWidth = 0;
    self.preBtn.selected = NO;
    btn.selected = YES;
    self.preBtn = btn;
    self.videoURL = self.videoURLArr[btn.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_choices count];
    }else{
        return [_blankfills count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}





-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_choices count]) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
            return titlelb;
        }else{
            return nil;
        }
    }else{
        if ([_blankfills count]) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }else {
        
            return nil;
        }
    }
}
 


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CGFloat height = [[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        
        if (height == 0) {
            
            return 300;
            
        }else {
            
            return height;
        }
        
        
    }else {
        
        CGFloat height = [[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        
        if (height == 0) {
            
            return 300;
            
        }else {
            
            return height;
        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    MicroCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    if (indexPath.section == 0) {
        PMicroPreviewModel *model = self.choices[indexPath.row];
        [cell setValuesWithModel:model];
        cell.tag = indexPath.row;
    }else {
    
        PMicroPreviewModel *model = self.blankfills[indexPath.row];
        [cell setValuesWithModel:model];
        cell.tag = indexPath.row;
    }
    

    
    return cell;
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 40;
    //固定section 随着cell滚动而滚动
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}


#pragma mark -event
-(void)playvideo
{
    
    [videoImage removeFromSuperview];
    videoImage = nil;
    [wmPlayer.player play];
    wmPlayer.isPlay = YES;
    wmPlayer.closeBtn.hidden = NO;
    wmPlayer.playOrPauseBtn.selected = NO;

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
