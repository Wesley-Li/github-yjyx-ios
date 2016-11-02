//
//  ChildrenwmPlayerController.m
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

    CGRect playerFrame;
    UIImageView *videoImage;
    UIButton *backBtn;
}
@property (assign, nonatomic) NSInteger flag;  // 1代表学生端
@property (strong, nonatomic) WMPlayer *wmPlayer;




@end

@implementation ChildrenVideoViewController

// 懒加载创建
- (WMPlayer *)wmPlayer {

    if (!_wmPlayer) {
        _wmPlayer = [[WMPlayer alloc] initWithFrame:playerFrame videoURLStr:_URLString];
        _wmPlayer.closeBtn.hidden = YES;
        [self.view insertSubview:_wmPlayer belowSubview:backBtn];
    }
    return _wmPlayer;
}


-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [_wmPlayer removeFromSuperview];
    _wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        _wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        _wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }
    _wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT);
    _wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,SCREEN_HEIGHT);
    
    [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(SCREEN_WIDTH-40);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_wmPlayer).with.offset(5);
        
    }];

    
    [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
    _wmPlayer.fullScreenBtn.selected = YES;
    [_wmPlayer bringSubviewToFront:_wmPlayer.bottomView];
    
}
-(void)toNormal{
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        
        _wmPlayer.transform = CGAffineTransformIdentity;
        _wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        _wmPlayer.playerLayer.frame = _wmPlayer.bounds;
        [self.view insertSubview:_wmPlayer belowSubview:backBtn];

        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        
        _wmPlayer.fullScreenBtn.selected = NO;
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
    if (_wmPlayer==nil||_wmPlayer.superview==nil){
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
            [self toNormal];

        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];

        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];

        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self loadBackBtn];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    
   if (_URLString.length > 0) {
       
       //旋转屏幕通知
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(onDeviceOrientationChange)
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
        ];
       //注册播放完成通知
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
       
       //注册全屏播放通知
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];

       
       playerFrame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH)*184/320);

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
    [super viewWillAppear:animated];
    
    if (_URLString.length > 0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        if(_flag == 0){
            [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
            [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
        }
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
    [self releaseWMPlayer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playVideo
{
    
    videoImage.hidden = YES;
    [self.wmPlayer.player play];
    self.wmPlayer.isPlay = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    if(_wmPlayer == nil){
        return;
    }

    [_wmPlayer removeFromSuperview];
    [_wmPlayer.playerLayer removeFromSuperlayer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_wmPlayer.player.currentItem cancelPendingSeeks];
        [_wmPlayer.player.currentItem.asset cancelLoading];
        [_wmPlayer.player pause];
        
        //移除观察者
        [_wmPlayer.currentItem removeObserver:_wmPlayer forKeyPath:@"status"];
        
        //        [_wmPlayer removeFromSuperview];
        //        [_wmPlayer.playerLayer removeFromSuperlayer];
        [_wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
        _wmPlayer.player = nil;
        _wmPlayer.currentItem = nil;
        
        //释放定时器，否侧不会调用WMPlayer中的dealloc方法
        [_wmPlayer.autoDismissTimer invalidate];
        _wmPlayer.autoDismissTimer = nil;
        [_wmPlayer.durationTimer invalidate];
        _wmPlayer.durationTimer = nil;
        
        
        _wmPlayer.playOrPauseBtn = nil;
        _wmPlayer.playerLayer = nil;
        _wmPlayer = nil;
        
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
