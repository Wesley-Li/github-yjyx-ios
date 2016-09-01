//
//  YiTeachMicroController.m
//  Yjyx
//
//  Created by liushaochang on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YiTeachMicroController.h"
#import "WMPlayer.h"
#import "YjyxMemberDetailViewController.h"
#import "ProductEntity.h"
#import "YjyxThreeStageController.h"


@interface YiTeachMicroController ()

{
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    UIImageView *videoImage;
    
    
}




@end

@implementation YiTeachMicroController

- (NSMutableArray *)baseQuestionIDList {

    if (!_baseQuestionIDList) {
        self.baseQuestionIDList = [NSMutableArray array];
    }
    return _baseQuestionIDList;
}

- (NSMutableArray *)consolidateIDList {

    if (!_consolidateIDList) {
        self.consolidateIDList = [NSMutableArray array];
    }
    return _consolidateIDList;
}

- (NSMutableArray *)improveIDList {

    if (!_improveIDList) {
        self.improveIDList = [NSMutableArray array];
    }
    return _improveIDList;
}

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    [self configureTheThreeBtn];
}

- (void)configureTheThreeBtn {

    self.baseButton.layer.cornerRadius = self.baseButton.width/2;
    self.baseButton.layer.masksToBounds = YES;
    self.baseButton.backgroundColor = [UIColor colorWithHexString:@"#3dd995"];
    self.consolidateButton.layer.cornerRadius = self.consolidateButton.width/2;
    self.consolidateButton.layer.masksToBounds = YES;
    self.consolidateButton.backgroundColor = [UIColor colorWithHexString:@"#3ed9d0"];
    self.improveButton.layer.cornerRadius = self.improveButton.width/2;
    self.improveButton.layer.masksToBounds = YES;
    self.improveButton.backgroundColor = [UIColor colorWithHexString:@"#3573d9"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 setImage:[UIImage imageNamed:@"comm_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.title = @"亿教课堂";
    
    [self readDataFromNetwork];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    // 注册通知
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeTheVideo:)
                                                 name:WMPlayerClosedNotification
                                               object:nil
     ];

    //注册全屏播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];

    

    if(_openMember == 1){
        [self readDataFromNetwork];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self closeTheVideo:nil];
}



- (BOOL)prefersStatusBarHidden
{
    if(wmPlayer.isFullscreen == YES){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - videoEvent
-(void)videoDidFinished:(NSNotification *)notice{
    
    if(wmPlayer.isFullscreen == YES){
        [self toNormal];
    }
    
    //    currentCell.playBtn.hidden = NO;
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [videoImage removeFromSuperview];
    [self configureWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)closeTheVideo:(NSNotification *)obj{
    
    wmPlayer.closeBtn.hidden = YES;
    [wmPlayer.player pause];
    [self releaseWMPlayer];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];

    [videoImage removeFromSuperview];
   
    [self configureWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
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
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)toNormal{
    [wmPlayer removeFromSuperview];
    wmPlayer.isFullscreen = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.videoBgView addSubview:wmPlayer];
        
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
        [self setNeedsStatusBarAppearanceUpdate];
        
    }];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        wmPlayer.isFullscreen = NO;
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





#pragma mark - 读取网络数据
- (void)readDataFromNetwork {

    [SVProgressHUD showWithStatus:@"正在拼命加载数据"];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"m_getbootunit_lesson", @"action", self.version_id, @"textbookverid", self.subject_id, @"subjectid", self.classes_id, @"gradeid", self.book_id, @"textbookvolid", self.textbookunitid, @"textbookunitid", nil];
    UIView *convertView = [[UIView alloc] init];
    [self.view addSubview:convertView];
    convertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    convertView.backgroundColor = [UIColor lightGrayColor];
    convertView.alpha = 0.1;
    [convertView makeToastActivity:SHOW_CENTER];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[BaseURL stringByAppendingString:@"/api/student/product_yjmemeber/"] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [convertView removeFromSuperview];
        [convertView hideToastActivity];
        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] isEqual:@0]) {

            self.responseObject = responseObject;
            self.microName = responseObject[@"name"];
            self.knowledgedesc = responseObject[@"knowledgedesc"];
            self.microNameLabel.text = _microName;
            NSArray *array = [responseObject[@"quizcontent"] JSONValue][@"questionList"][0][1];
            NSLog(@"-------%@", array);
            // id列表
            for (NSDictionary *dic in array) {
                if ([dic[@"level"] isEqual:@1]) {
                    [self.baseQuestionIDList addObject:dic[@"id"]];
                }else if ([dic[@"level"] isEqual:@2]) {
                    [self.consolidateIDList addObject:dic[@"id"]];
                }else {
                    
                    [self.improveIDList addObject:dic[@"id"]];
                }
            }
            if([responseObject[@"showview"] integerValue] == 1 && ![[responseObject allKeys] containsObject:@"videoobjlist"]){
                [self configureWMPlayer];
                self.scroHeightConstraint.constant = 1;
                
            }
            
            if ([responseObject[@"showview"] isEqual:@0]) {
                [SVProgressHUD showErrorWithStatus:@"暂无亿教课"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            if ([[responseObject allKeys] containsObject:@"videoobjlist"]) {
                self.microArr = [responseObject[@"videoobjlist"] JSONValue];
                self.videoURL = _microArr[0][@"url"];
                [self configureWMPlayer];
                [self configureTheNumBtn:_microArr];
            }else {
            
                self.topConstraint.constant = 20;
            }
            [SVProgressHUD dismissWithDelay:0.1];
            
            
        }else {
        
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:0.8];


        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络出错了" duration:1 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
        [convertView hideToastActivity];
        [convertView removeFromSuperview];
    }];
}


#pragma mark - 配置视频
- (void)configureWMPlayer {
    
    if (self.videoURL != nil || self.videoURL.length != 0) {
        playerFrame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320);
        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:self.videoURL];
        NSLog(@"%@", wmPlayer);
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wmPlayer).with.offset(-10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        wmPlayer.closeBtn.hidden = YES;
        wmPlayer.layer.masksToBounds = YES;
        [self.view addSubview:wmPlayer];
        [wmPlayer.player pause];
        
       
        videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4)];
        videoImage.image = [UIImage imageNamed:@"Common_video.png"];
        
        videoImage.layer.masksToBounds = YES;
        videoImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playvideo)];
        [videoImage addGestureRecognizer:tap];
        [self.view addSubview:videoImage];
 
        
    }else{
        videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4)];
        videoImage.image = [UIImage imageNamed:@"Common_video.png"];
        
        videoImage.layer.masksToBounds = YES;
        videoImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playvideo)];
        [videoImage addGestureRecognizer:tap];
        [self.view addSubview:videoImage];
        

    }

    
}

#pragma mark - 配置视频选择按钮
- (void)configureTheNumBtn:(NSArray *)array {

    CGSize size = CGSizeMake(10, 5);// 初始位置
    CGFloat padding = 10;// 间距
    NSInteger num = 6;
    CGFloat tWidth = (SCREEN_WIDTH - 20 -(num - 1)*padding)/num;
    CGFloat tHeight = tWidth;
    if (array.count > 1) {
        for (int i = 0; i < array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(size.width, size.height, tWidth, tHeight);
            size.width += tWidth + padding;
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
            [self.numBtnBgView addSubview:button];
            
        }
        self.topConstraint.constant = 80;
        self.scroHeightConstraint.constant = tHeight + 10;
        self.numBtnBgView.contentSize = CGSizeMake(size.width + padding, self.numBtnBgView.height - 10);
        
    }else {
    
        self.numBtnBgView.hidden = YES;
        self.topConstraint.constant = 20;
    }

    
}


- (void)microNumButtonClick:(UIButton *)sender {
    
    self.videoURL = [self.microArr[sender.tag - 500] objectForKey:@"url"];
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [videoImage removeFromSuperview];
    [self configureWMPlayer];
    [wmPlayer.player play];
    wmPlayer.closeBtn.hidden = NO;
    [self.view sendSubviewToBack:videoImage];
    
    self.preBtn.backgroundColor = [UIColor whiteColor];
    self.preBtn.tintColor = [UIColor lightGrayColor];
    sender.backgroundColor = [UIColor lightGrayColor];
    self.preBtn.selected = NO;
    sender.selected = YES;
    self.preBtn = sender;
    
}

-(void)releaseWMPlayer{
    if(wmPlayer == nil){
        
        return;
    }
//    [wmPlayer removeFromSuperview];
//    [wmPlayer.playerLayer removeFromSuperlayer];
//    wmPlayer = nil;
    NSLog(@"%@, %@", wmPlayer, [NSThread currentThread]);
    
    
        [wmPlayer.player.currentItem cancelPendingSeeks];
        [wmPlayer.player.currentItem.asset cancelLoading];
        [wmPlayer.player pause];
        
        //移除观察者
        [wmPlayer.currentItem removeObserver:wmPlayer forKeyPath:@"status"];
    
        [wmPlayer removeFromSuperview];
        [wmPlayer.playerLayer removeFromSuperlayer];
//        [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
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
//    });
    
}


#pragma mark - 基础
- (IBAction)baseBtnClick:(UIButton *)sender {
    
    YjyxThreeStageController *threeStageVC = [[YjyxThreeStageController alloc] init];
    NSLog(@"%@", self.baseQuestionIDList);
    threeStageVC.qidlist = self.baseQuestionIDList;
    threeStageVC.subjectid = self.subject_id;
    threeStageVC.knowledge = self.knowledgedesc;
    [self.navigationController pushViewController:threeStageVC animated:YES];
    
}

#pragma mark - 巩固
- (IBAction)consolidateBtnClick:(UIButton *)sender {
    
    YjyxThreeStageController *threeStageVC = [[YjyxThreeStageController alloc] init];
    threeStageVC.qidlist = self.consolidateIDList;
    threeStageVC.subjectid = self.subject_id;
    threeStageVC.knowledge = self.knowledgedesc;
    [self.navigationController pushViewController:threeStageVC animated:YES];

    
}

#pragma mark - 提高
- (IBAction)improveBtnClick:(UIButton *)sender {
    
    YjyxThreeStageController *threeStageVC = [[YjyxThreeStageController alloc] init];
    threeStageVC.qidlist = self.improveIDList;
    threeStageVC.subjectid = self.subject_id;
    threeStageVC.knowledge = self.knowledgedesc;
    [self.navigationController pushViewController:threeStageVC animated:YES];

    
}


#pragma mark - 点击视频开始按钮
-(void)playvideo
{
    NSLog(@"%@", _responseObject);
    // 是否需要会员
    if (![[self.responseObject allKeys] containsObject:@"videoobjlist"]) {
        
        [self getMemberInfo];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"观看该视频需要会员权限,是否前往试用或成为会员?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(self.entity == nil){
                [self.view makeToast:@"您的网络缓慢,请稍候尝试" duration:1.0 position:SHOW_CENTER complete:nil];
                return;
            }
            // 跳转至会员页面
            YjyxMemberDetailViewController *vc = [[YjyxMemberDetailViewController alloc] init];
            vc.productEntity = self.entity;
            vc.jumpType = 1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        

        
    }else {
        
        [wmPlayer.player play];
        wmPlayer.closeBtn.hidden = NO;

    }
    
}

// 获取会员信息
- (void)getMemberInfo
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"getonememproductinfo";
    param[@"subjectid"] = self.subject_id;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/mobile/m_product/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] integerValue] == 0) {
            ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:responseObject];
            self.entity = entity;
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseWMPlayer];
    
    NSLog(@"player deallco");
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
