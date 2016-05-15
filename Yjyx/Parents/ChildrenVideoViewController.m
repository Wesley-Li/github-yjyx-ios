//
//  ChildrenVideoViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenVideoViewController.h"
#import "WMPlayer.h"

@interface ChildrenVideoViewController ()
{
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    UIImageView *videoImage;
}

@end

@implementation ChildrenVideoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
    }
    return self;
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
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,SCREEN_HEIGHT);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(SCREEN_HEIGHT);
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
    self.navigationController.navigationBarHidden = NO;
    [self loadBackBtn];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
   if (_URLString.length > 0) {
       playerFrame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320);
       wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:self.URLString];
       wmPlayer.closeBtn.hidden = YES;
       [self.view addSubview:wmPlayer];
       [wmPlayer.player pause];

       videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4)];
       videoImage.image = [UIImage imageNamed:@"Common_video.png"];
       videoImage.userInteractionEnabled = YES;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
       [videoImage addGestureRecognizer:tap];
       [self.view addSubview:videoImage];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, playerFrame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - playerFrame.size.height - 64)];
       [web loadHTMLString:_explantionStr baseURL:nil];
       [self.view addSubview:web];
   }else{
       UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
       [web loadHTMLString:_explantionStr baseURL:nil];
       [self.view addSubview:web];
   }
  //    [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
}

-(void)playVideo
{
    [wmPlayer.player play];
    [videoImage removeFromSuperview];
    videoImage = nil;
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

#pragma mark -UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '160%'"];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
