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

}

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *microName;
@property (nonatomic, copy) NSString *knowledgeName;

@property (nonatomic, strong) NSMutableDictionary *choiceCellHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillHeightDic;



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
        self.blankfills = [NSMutableArray alloc];
    }
    return _blankfills;
}


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
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];

    self.navigationController.navigationBarHidden = NO;
}



-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
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
//    _namelb.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//    _knowledgeView.frame = CGRectMake(0, _namelb.frame.origin.y + 50, SCREEN_WIDTH, 60);
    

    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.view addSubview:wmPlayer];
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    self.navigationController.navigationBarHidden = NO;
    [self loadBackBtn];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    self.choiceCellHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillHeightDic = [[NSMutableDictionary alloc] init];
    
    [self getchildResult:_previewRid];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight:) name:@"cellHeighChange" object:nil];
    
    
}


- (void)refreshCellHeight:(NSNotification *)sender {
    
    MicroCell *cell = [sender object];
    
    // 保存高度
    if (cell.indexPath.section == 0) {
        
        if (![self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
        {
            [self.choiceCellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.subjectTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else {
        if (![self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
        {
            [self.blankfillHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.subjectTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:1 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
}

-(void)dealloc{
    [self releaseWMPlayer];
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
            
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                
                // 视频和表头信息
                self.videoURL = [[[[result[@"lessonobj"] objectForKey:@"videoobjlist"] JSONValue] firstObject] objectForKey:@"url"];
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


#pragma mark - 配置视频
- (void)configureWMPlayer {

    if (self.videoURL != nil || self.videoURL.length != 0) {
        playerFrame = CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320);
        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:self.videoURL];
        wmPlayer.closeBtn.hidden = YES;
        wmPlayer.layer.masksToBounds = YES;
        [self.view addSubview:wmPlayer];
        [wmPlayer.player pause];
        
        videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4)];
        videoImage.image = [UIImage imageNamed:@"Common_video.png"];
        videoImage.layer.masksToBounds = YES;
        videoImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
        [videoImage addGestureRecognizer:tap];
        [self.view addSubview:videoImage];

    }
    

}

#pragma mark - 配置tableview 
- (void)configureTableview {

    self.subjectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, playerFrame.size.height + 64, SCREEN_WIDTH, SCREEN_HEIGHT - playerFrame.size.height - 64) style:UITableViewStylePlain];
    _subjectTable.dataSource = self;
    _subjectTable.delegate = self;
    _subjectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    // 知识清单
    UILabel *kowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.origin.y + 40 + 5, SCREEN_WIDTH, 40)];
    kowLabel.backgroundColor = [UIColor whiteColor];
    kowLabel.text = @"知识清单";
    [headerView addSubview:kowLabel];
    
    // 清单内容
    NSString *content = _knowledgeName;
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, kowLabel.origin.y + 40, SCREEN_WIDTH, 10)];
    web.scrollView.scrollEnabled = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.delegate = self;
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", content];
    [web loadHTMLString:jsString baseURL:nil];
    
    
    [headerView addSubview:web];
    
    headerView.frame = CGRectMake(0, playerFrame.size.height + 64, SCREEN_WIDTH, web.origin.y + web.height + 5);
    
    self.subjectTable.tableHeaderView = headerView;
    
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
-(void)playVideo
{
//    NSString *videoUrl = [[[lessDic objectForKey:@"videoobjlist"] JSONValue][(sender.view.tag - 2)/ 2] objectForKey:@"url"];
//    NSLog(@"%@, %ld", self.view.subviews, sender.view.tag);
////    wmPlayer = self.view.subviews[sender.view.tag - 2];
//    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:videoUrl];
    [wmPlayer.player play];
//    [self.view.subviews[sender.view.tag -1] removeFromSuperview];
    [videoImage removeFromSuperview];
    videoImage = nil;
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
