/*!
 @header WMPlayer.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/1/24
 
 @version 1.00 16/1/24 Creation(版本信息)
 
   Copyright © 2016年 郑文明. All rights reserved.
 */


/**
 *  全屏按钮被点击的通知
 */
#define WMPlayerFullScreenButtonClickedNotification @"fullScreenBtnClickNotice"
/**
 *  关闭播放器的通知
 */
#define WMPlayerClosedNotification @"closeTheVideo"
/**
 *  播放完成的通知
 */
#define WMPlayerFinishedPlayNotification @"WMPlayerFinishedPlayNotification"
/**
 *  单击播放器view的通知
 */
#define WMPlayerSingleTapNotification @"WMPlayerSingleTapNotification"
/**
 *  双击播放器view的通知
 */
#define WMPlayerDoubleTapNotification @"WMPlayerDoubleTapNotification"

#define WMVideoSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMVideoFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]


#import <UIKit/UIKit.h>
#import "Masonry.h"

@import MediaPlayer;
@import AVFoundation;

/**
 *  注意⚠：本人把属性都公开到.h文件里面了，为了适配广大开发者，不同的需求可以修改属性东西，也可以直接修改源代码。
 */
@interface WMPlayer : UIView
/**
 *  播放器player
 */
@property(nonatomic,retain)AVPlayer *player;
/**
 *playerLayer,可以修改frame
 */
@property(nonatomic,retain)AVPlayerLayer *playerLayer;
/**
 *  底部操作工具栏
 */
@property(nonatomic,retain)UIView *bottomView;
@property(nonatomic,retain)UISlider *progressSlider;
@property(nonatomic,retain)UISlider *volumeSlider;
@property(nonatomic,copy) NSString *videoURLStr;

/**
 *  定时器
 */
@property (nonatomic, retain) NSTimer *durationTimer;
@property (nonatomic, retain) NSTimer *autoDismissTimer;
/**
 *  BOOL值判断当前的状态
 */
@property(nonatomic,assign)BOOL isFullscreen;

@property (nonatomic, assign) BOOL isPlay;
/**
 *  显示播放时间的UILabel
 */
@property(nonatomic,retain)UILabel *timeLabel;
/**
 *  控制全屏的按钮
 */
@property(nonatomic,retain)UIButton *fullScreenBtn;
/**
 *  播放暂停按钮
 */
@property(nonatomic,retain)UIButton *playOrPauseBtn;
/**
 *  关闭按钮
 */
@property(nonatomic,retain)UIButton *closeBtn;

/* playItem */
@property (nonatomic, retain) AVPlayerItem *currentItem;

@property (nonatomic,retain) UIButton *backBtn;
/**
 *  初始化WMPlayer的方法
 *
 *  @param frame       frame
 *  @param videoURLStr URL字符串，包括网络的和本地的URL
 *
 *  @return id类型，实际上就是WMPlayer的一个对象
 */
- (id)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr;
/**
 * 暂停
 */
- (void)pause;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
