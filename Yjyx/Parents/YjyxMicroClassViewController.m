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

@interface YjyxMicroClassViewController ()
{
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    UIImageView *videoImage;
    UIScrollView *_contentScroll;
    UIView *_knowledgeView;
    UILabel *_namelb;

}

@end

@implementation YjyxMicroClassViewController

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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

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
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toNormal{
    [wmPlayer removeFromSuperview];
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
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
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
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    self.navigationController.navigationBarHidden = NO;
    [self loadBackBtn];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    [self getchildResult:_previewRid];
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
            NSLog(@"%@",result);
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [self initView:[result objectForKey:@"lessonobj"] questionDic:[result objectForKey:@"questions"]];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}


-(void)initView:(NSDictionary *)lessionDic questionDic:(NSDictionary *)questionDic
{
    NSString *videoStr = [[[[lessionDic objectForKey:@"videoobjlist"] JSONValue] firstObject] objectForKey:@"url"];
    playerFrame = CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320);
    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:videoStr];
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
    
    // scrollview
    UIScrollView *contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + playerFrame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - playerFrame.size.height -64)];
    [self.view addSubview:contentScroll];
    _contentScroll = contentScroll;
    UILabel * namelb = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:[lessionDic objectForKey:@"name"]];
    _namelb = namelb;
    namelb.backgroundColor = [UIColor whiteColor];
    
    [contentScroll addSubview:namelb];
    
    UIView *knowledgeView = [[UIView alloc] initWithFrame:CGRectMake(0, namelb.frame.origin.y + 50, SCREEN_WIDTH, 60)];
    knowledgeView.backgroundColor = [UIColor whiteColor];
    _knowledgeView = knowledgeView;
    UILabel *title = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"知识清单"];
    [knowledgeView addSubview:title];
    
    
    NSString *content = [lessionDic objectForKey:@"knowledgedesc"];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH - 20, 999)];
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [templabel optimumSize];
    [knowledgeView addSubview:templabel];
    knowledgeView.frame = CGRectMake(0, namelb.frame.origin.y + 50, SCREEN_WIDTH, optimalSize.height + 30);
    
    [contentScroll addSubview:knowledgeView];
    
    _choices= [[questionDic objectForKey:@"choice"] objectForKey:@"questionlist"];
    _blankfills = [[questionDic objectForKey:@"blankfill"] objectForKey:@"questionlist"];
    
    // 选择题和填空题的内容,tableviw
    if (_choices.count > 0 || _blankfills.count > 0) {
        _subjectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, knowledgeView.frame.origin.y+knowledgeView.frame.size.height +10, SCREEN_WIDTH, 1500) style:UITableViewStylePlain];
        _subjectTable.dataSource = self;
        _subjectTable.delegate = self;
        _subjectTable.userInteractionEnabled = NO;
        _subjectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [contentScroll addSubview:_subjectTable];
    }
    
    NSMutableString *contentStr = [[NSMutableString alloc] init];
    NSArray *choiceAry = [[questionDic objectForKey:@"choice"] objectForKey:@"questionlist"];
    NSArray *blankfillAry = [[questionDic objectForKey:@"blankfill"] objectForKey:@"questionlist"];
    if ([choiceAry count]>0) {
        [contentStr appendString:[NSString stringWithFormat:@"%@\n",@"选择题"]];
    }
    for (int i = 0; i<[choiceAry count]; i++) {
        [contentStr appendString:[NSString stringWithFormat:@"%d、 %@\n",(i+1),[[choiceAry objectAtIndex:i] objectForKey:@"content"]]];
    }
    
    if ([blankfillAry count]>0) {
        [contentStr appendString:[NSString stringWithFormat:@"%@\n",@"填空题"]];
    }
    
    for (int i = 0; i<[blankfillAry count]; i++) {
        [contentStr appendString:[NSString stringWithFormat:@"%d、 %@\n",(i+1),[[blankfillAry objectAtIndex:i] objectForKey:@"content"]]];
    }
    
    // 问题背景view
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(0, knowledgeView.frame.origin.y+knowledgeView.frame.size.height+10, SCREEN_WIDTH , 10000)];
    questionView.backgroundColor = [UIColor redColor];
    
    UILabel *hometitle = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"作业内容"];
    [questionView addSubview:hometitle];

    
    
    NSString *questionStr = [contentStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *tempLable1 = [[RCLabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH , 999)];
    tempLable1.font = [UIFont systemFontOfSize:14];
    tempLable1.textColor = [UIColor blackColor];
    tempLable1.userInteractionEnabled = NO;
    RTLabelComponentsStructure *componentsDS1 = [RCLabel extractTextStyle:questionStr];
    tempLable1.componentsAndPlainText = componentsDS1;
    CGSize optimalSize1 = [tempLable1 optimumSize];
    
    
    CGFloat height = ([_choices count]+[_blankfills count]) *10;
    
    contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, questionView.frame.origin.y + optimalSize1.height + height + 30);
    
}
#pragma mark -UITableViewDelegate
#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_choices count]>0&&[_blankfills  count]>0) {
        return 2;
    }else if ([_choices count] == 0&&[_blankfills count] == 0)
    {
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_choices count]>0) {
            return [_choices count];
        }
        return [_blankfills count];
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
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
            return titlelb;
        }else{
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }
    }else{
        UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
        return titlelb;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_choices count]>0) {
            NSString *content = [[_choices objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            return optimalSize.height + 10;
        }else{
            NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            return optimalSize.height + 10;
        }
    }else{
        NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
        templabel.font = [UIFont systemFontOfSize:14];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        return optimalSize.height + 10;
    }
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH-10, 120-4)];
    bg.backgroundColor = [UIColor clearColor];
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = RGBACOLOR(225, 225, 225, 1).CGColor;
    
    if (indexPath.section == 0) {
        if ([_choices count]>0) {
            NSString *content = [[_choices objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 5);
            [cell.contentView addSubview:bg];
            _contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, _subjectTable.contentSize.height + _namelb.frame.size.height + _knowledgeView.frame.size.height + 20);
            [bg addSubview:templabel];
        }else{
            NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 5);
            [cell.contentView addSubview:bg];
            _contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, _subjectTable.contentSize.height + _namelb.frame.size.height + _knowledgeView.frame.size.height + 20);
            [bg addSubview:templabel];
        }
    }else{
        NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
        templabel.font = [UIFont systemFontOfSize:14];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 5);
        [cell.contentView addSubview:bg];
        _contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, _subjectTable.contentSize.height + _namelb.frame.size.height + _knowledgeView.frame.size.height + 20);
        [bg addSubview:templabel];
    }
   
    
    return cell;
}


#pragma mark -event
-(void)playVideo
{
    [wmPlayer.player play];
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
