//
//  ChildrenVideoViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenVideoViewController.h"
#import "WMPlayer.h"
#import "YjyxCommonNavController.h"
@interface ChildrenVideoViewController ()<UIWebViewDelegate>
{
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    UIImageView *videoImage;
    UIButton *backBtn;
    BOOL isPlay;
}
@property (assign, nonatomic) NSInteger flag;  // 1代表学生端
@end

@implementation ChildrenVideoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"goBackBtnClickNotice" object:nil];
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
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
    videoImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    if (isPlay) {
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        wmPlayer.playOrPauseBtn.selected = YES;
    }else {
        wmPlayer.playOrPauseBtn.selected = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [[UIApplication sharedApplication].keyWindow addSubview:videoImage];
    }
    

    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toNormal{
    [wmPlayer removeFromSuperview];
    [backBtn removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        videoImage.transform = CGAffineTransformIdentity;
        videoImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4);
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
        
        [self.view insertSubview:backBtn aboveSubview:wmPlayer];
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
       isPlay = NO;

       videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320+4)];
       videoImage.image = [UIImage imageNamed:@"Common_video.png"];
       videoImage.userInteractionEnabled = YES;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
       [videoImage addGestureRecognizer:tap];
       [self.view addSubview:videoImage];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, playerFrame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - playerFrame.size.height)];
       web.detectsPhoneNumbers = NO;
       NSLog(@"%@", _explantionStr);
       if ([_explantionStr isEqualToString:@""]) {
           [web loadHTMLString:@"暂无解析" baseURL:nil];
       }else {
       
           NSRange range = [_explantionStr rangeOfString:@">" options:NSCaseInsensitiveSearch];
           
           NSLog(@"%@", NSStringFromRange(range));
           if(range.length == 0 && range.location > 5000000){
               NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
               
               _explantionStr = [_explantionStr  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
               NSString *str2 = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", _explantionStr];
               [web loadHTMLString:str2 baseURL:nil];
           }else if(range.length != 1){
               [web loadHTMLString:_explantionStr baseURL:nil];
           }else{
               NSString *str1 =  [_explantionStr substringFromIndex:range.location];
               NSString *str2 = [NSString stringWithFormat:@"<p%@%@",@" style=\"word-wrap:break-word; width:SCREEN_WIDTH;\"", str1];
               
               NSLog(@"%@", str2);
               [web loadHTMLString:str2 baseURL:nil];
           }

       }
       
       [self.view addSubview:web];
       
      
       backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 44, 44)];
       [backBtn setImage:[UIImage imageNamed:@"Parent_VideoBack"] forState:UIControlStateNormal];
       [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//       [self.view addSubview:backBtn];
       [self.view insertSubview:backBtn aboveSubview:videoImage];
      
   }else{
       UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
       NSLog(@"%f,%f", SCREEN_WIDTH, SCREEN_HEIGHT);

       web.delegate = self;
       web.detectsPhoneNumbers = NO;
       if ([_explantionStr isEqualToString:@""]) {
           [web loadHTMLString:@"暂无解析" baseURL:nil];
       }else {
       
           NSRange range = [_explantionStr rangeOfString:@">" options:NSCaseInsensitiveSearch];
           
           NSLog(@"%@", NSStringFromRange(range));
           if(range.length == 0 && range.location > 5000000){
               NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
               
               _explantionStr = [_explantionStr  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
               NSString *str2 = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", _explantionStr];
               [web loadHTMLString:str2 baseURL:nil];
               
           }else if(range.length != 1){
               [web loadHTMLString:_explantionStr baseURL:nil];
           }else{
               NSString *str1 =  [_explantionStr substringFromIndex:range.location];
               NSString *str2 = [NSString stringWithFormat:@"<p%@%@",@" style=\"word-wrap:break-word; width:SCREEN_WIDTH;\"", str1];
               
               NSLog(@"%@", str2);
               [web loadHTMLString:str2 baseURL:nil];
           }
           

       }
       
       [self.view addSubview:web];
   }
  //    [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    if([self.navigationController isKindOfClass:[YjyxCommonNavController class]]){
        _flag = 1;
    }
    
}


- (BOOL)prefersStatusBarHidden {
    if(self.URLString.length > 0){
        return YES;
    }else{
    return NO;
    }
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
    
    if (_URLString.length > 0) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        if(_flag == 0){
        [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
        }
        self.navigationController.navigationBarHidden = NO;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
  
    [self releaseWMPlayer];
    isPlay = NO;
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playVideo
{
//    backBtn.hidden = YES;
    [wmPlayer.player play];
    isPlay = YES;
    [videoImage removeFromSuperview];
    videoImage = nil;
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
        
        //        [wmPlayer removeFromSuperview];
        //        [wmPlayer.playerLayer removeFromSuperlayer];
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

-(void)dealloc{
    
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
