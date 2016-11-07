//
//  TeacherDrawViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TeacherDrawViewController.h"
#import "YjyxDrawLine.h"
#import "VoiceListCell.h"
#import "EMCDDeviceManager.h"
#import "EMVoiceConverter.h"
#import "NotifySoundTool.h"
#import "OneStuTaskDetailViewController.h"
#import "YjyxCommonNavController.h"

@import AVFoundation;
@import AudioToolbox;

@interface TeacherDrawViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    BOOL isExpand;
    BOOL isEdit;// 是否编辑
    BOOL isChoosePencil;
    NSDate *startDate;
    NSDate *endDate;
    NSInteger currentIndex;
    NSInteger flag;
    UIImageView *animatingImageview;

}

@property (nonatomic, copy) NSString *imgURL;
@property (strong, nonatomic) NSMutableArray *voiceArr;
@property (weak, nonatomic) IBOutlet UITableView *voiceList;

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
@property (weak, nonatomic) IBOutlet UILabel *voiceNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animationImage;

@property (weak, nonatomic) IBOutlet UIButton *bluePenBtn;
@property (weak, nonatomic) IBOutlet UIButton *yellowPenBtn;
@property (weak, nonatomic) IBOutlet UIButton *redPenBtn;

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSString *recordFileName;
@property (strong, nonatomic) NSString *recordFilePath;
@property (strong, nonatomic) NSString *playFilePath;

@property (weak, nonatomic) UIView *infoView;

@property (strong, nonatomic) VoiceListCell *selCell;
@end

@implementation TeacherDrawViewController

- (NSMutableArray *)voiceArr {

    if (!_voiceArr) {
        self.voiceArr = [NSMutableArray array];
    }
    return _voiceArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isEdit = NO;
    isChoosePencil = NO;
    currentIndex = -1;
    [self configureNavBar];
    self.imgURL = [self.processArr[_imageIndex] objectForKey:@"img"];
    self.voiceArr = [[self.processArr[_imageIndex] objectForKey:@"teachervoice"] mutableCopy];
    
    if (self.voiceArr.count == 0) {
        self.voiceImage.hidden = YES;
        self.voiceNumLabel.hidden = YES;
    }else {
    
        self.voiceNumLabel.text = [NSString stringWithFormat:@"%ld", self.voiceArr.count];
    }
    
    
    self.voiceImage.userInteractionEnabled = YES;
    self.voiceNumLabel.layer.cornerRadius = 7.5;
    self.voiceNumLabel.layer.masksToBounds = YES;
    self.voiceNumLabel.userInteractionEnabled = NO;
    self.voiceBtn.layer.cornerRadius = 41;
    self.voiceBtn.layer.masksToBounds = YES;
    self.imageview.userInteractionEnabled = NO;
    [self.imageview setImageWithURL:[NSURL URLWithString:_imgURL]];
    
    YjyxDrawLine *lineView = [YjyxDrawLine defaultLine];
    [self.imageview addSubview:lineView];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"储存" style:UIBarButtonItemStylePlain target:self action:@selector(saveImageAct:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    // 观察属性变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTheVoiceNum:) name:@"voiceNumShow" object:nil];
    // 点击声音图片
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.voiceImage addGestureRecognizer:tap];
    
    // 录音
    [self.voiceBtn addTarget:self action:@selector(speakEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceBtn addTarget:self action:@selector(speakLeavel:) forControlEvents:UIControlEventTouchDragExit];
    [self.voiceBtn addTarget:self action:@selector(speakOut:) forControlEvents:UIControlEventTouchUpOutside];
    [self.voiceBtn addTarget:self action:@selector(speakEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self recordingAnimationConfigure];
    
    // 注册cell
    [self.voiceList registerNib:[UINib nibWithNibName:NSStringFromClass([VoiceListCell class]) bundle:nil] forCellReuseIdentifier:@"ID"];
    self.voiceList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.voiceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.voiceList addGestureRecognizer:longPress];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUrlIsFinish) name:@"DOWNLOADISFINISH" object:nil];
    
    
}

- (void)configureNavBar {

    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld/%ld)", self.stuName, self.imageIndex + 1, self.processArr.count];
    

}

- (void)goBack {
    
    // 如果做了编辑,判断是否储存
    if ([YjyxDrawLine defaultLine].num != 0 || isEdit == YES) {
        
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"您当前的操作还没有储存,如果返回,将会使操作丢失,是否确定返回?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 清空audio文件
                [self cleanAllStudioFile];
                // 清空画图
                [[YjyxDrawLine defaultLine] cleanAllDrawBySelf];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            
            [self presentViewController:alertVC animated:YES completion:nil];
            
        
    }else {
    
        // 清空audio文件
        [self cleanAllStudioFile];
        // 清空画图
        [[YjyxDrawLine defaultLine] cleanAllDrawBySelf];

        [self.navigationController popViewControllerAnimated:YES];

        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {

    if ([[EMCDDeviceManager sharedInstance] isPlaying] || [self.selCell.activityView isAnimating]) {
        [[EMCDDeviceManager sharedInstance] stopPlaying];

    }
}


// 清空音频文件
- (void)cleanAllStudioFile {

    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [directory stringByAppendingPathComponent:@"audio"];
    NSError *error = nil;
    if([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"清除音频文件成功");
    } else {
        NSLog(@"error=%@", error);
    }

    
}


// 点击声音按钮
- (void)handleTap:(UITapGestureRecognizer *)sender {

    self.imageview.userInteractionEnabled = NO;
    self.voiceNumLabel.hidden = YES;
    self.voiceImage.hidden = YES;
    [self.view bringSubviewToFront:self.voiceList];

    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.voiceArr.count == 0) {
        self.voiceImage.hidden = YES;
        self.voiceNumLabel.hidden = YES;
        [self.view sendSubviewToBack:self.voiceList];
    }else {
        
        self.voiceImage.hidden = NO;
        self.voiceNumLabel.hidden = NO;
        if (isChoosePencil) {
            self.imageview.userInteractionEnabled = YES;
        }else {
            self.imageview.userInteractionEnabled = NO;
        }
        
        [self.view sendSubviewToBack:self.voiceList];
    }
    

}

// 观察者调用
- (void)showTheVoiceNum:(NSNotification *)sender {

    if (self.voiceArr.count > 0) {
        self.voiceImage.hidden = NO;
        self.voiceNumLabel.hidden = NO;
        self.voiceNumLabel.text = [NSString stringWithFormat:@"%ld", self.voiceArr.count];
    }else {
    
        self.voiceImage.hidden = YES;
        self.voiceNumLabel.hidden = YES;
    }
    
    [self.voiceList reloadData];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.navigationController isKindOfClass:[YjyxCommonNavController class]]){
        self.navigationController.navigationBar.barTintColor = STUDENTCOLOR;
    }
}
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

// 蓝色笔
- (IBAction)drawBlueLine:(UIButton *)sender {
    
    self.bluePenBtn.selected = YES;
    self.yellowPenBtn.selected = NO;
    self.redPenBtn.selected = NO;
    self.imageview.userInteractionEnabled = YES;
    isChoosePencil = YES;
    [YjyxDrawLine defaultLine].currentPaintBrushColor = [UIColor blueColor];
    
}

// 黄色笔
- (IBAction)drawYelloewLine:(UIButton *)sender {
    self.bluePenBtn.selected = NO;
    self.yellowPenBtn.selected = YES;
    self.redPenBtn.selected = NO;
    self.imageview.userInteractionEnabled = YES;
    isChoosePencil = YES;
    [YjyxDrawLine defaultLine].currentPaintBrushColor = [UIColor yellowColor];
}

// 红色笔
- (IBAction)drawRedLine:(UIButton *)sender {
    self.bluePenBtn.selected = NO;
    self.yellowPenBtn.selected = NO;
    self.redPenBtn.selected = YES;
    self.imageview.userInteractionEnabled = YES;
    isChoosePencil = YES;
    [YjyxDrawLine defaultLine].currentPaintBrushColor = [UIColor redColor];
}

// 撤销
- (IBAction)deleteLastLine:(UIButton *)sender {
    
    [[YjyxDrawLine defaultLine] cleanFinallyDraw];
    
}

// 恢复
- (IBAction)recoverLastLine:(UIButton *)sender {
    
    [[YjyxDrawLine defaultLine] recoverFinalDraw];
}

// 清空
- (IBAction)removeAllLine:(UIButton *)sender {
    
    [[YjyxDrawLine defaultLine] cleanAllDrawBySelf];
}

// 语音动画
- (void)recordingAnimationConfigure {

    self.animationImage.animationImages = @[[UIImage imageNamed:@"record_1"], [UIImage imageNamed:@"record_2"], [UIImage imageNamed:@"record_3"], [UIImage imageNamed:@"record_4"]];
    [self.animationImage setAnimationDuration:1.0f];
    [self.animationImage setAnimationRepeatCount:0];
    
}

// 语音录制
- (IBAction)speakStart:(UIButton *)sender {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"%d", sender.highlighted);
            if(sender.highlighted == NO){
                return;
            }
            // **************************用户同意获取数据*************************
            // 如果语音正在播放,将语音播放停止
            [[EMCDDeviceManager sharedInstance] stopPlaying];
            UIImageView *imageview = [self.voiceList viewWithTag:currentIndex + 300];
            [imageview stopAnimating];
            
            NSLog(@"开始录音了");
            isEdit = YES;
            self.imageview.userInteractionEnabled = NO;
            self.animationImage.hidden = NO;
            [self.animationImage startAnimating];
           startDate = [NSDate date];
            
#warning  录音开始
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            
            // 根据当前时间生成文件名
            self.recordFileName = [TeacherDrawViewController getCurrentTimeString];
            // 获取路径
            self.recordFilePath = [TeacherDrawViewController getPathByFilename:_recordFileName ofType:@"wav"];
            NSLog(@"%@", self.recordFilePath);
            // 初始化录音
            NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                           [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                           [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                           [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                           //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                           //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                           //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                           nil];

            self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_recordFilePath] settings:recordSetting error:nil];
            
            self.recorder.delegate = self;
            self.recorder.meteringEnabled = YES;
            // 准备录音
            [self.recorder prepareToRecord];
            [self.recorder record];

        } else {
            // 可以显示一个提示框告诉用户这个app没有得到允许？
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"请在\"设置-隐私-麦克风\"打开麦克风" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertVc addAction:action];
            [self presentViewController:alertVc animated:YES completion:nil];
            flag = 1;
            return ;
        }
    }];
   
    
    
}

#pragma mark - 录音结束
- (void)speakEnter:(UIButton *)sender{
    [self.infoView removeFromSuperview];
}
- (void)speakOut:(UIButton *)sender{
    [self.infoView removeFromSuperview];
    [self.recorder stop];
    self.recorder = nil;
    [self.animationImage stopAnimating];
    self.animationImage.hidden = YES;
}
- (void)speakLeavel:(UIButton *)sender{
    NSLog(@"_____");
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor lightGrayColor];
    infoView.width = 100;
    infoView.height = 100;
    infoView.center = CGPointMake(self.view.width / 2, self.view.height * 2 / 3);
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"松开手指\n将取消录音";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    [infoLabel sizeToFit];
    infoLabel.center = CGPointMake(infoView.width / 2, infoView.height / 2);
    [self.view addSubview:infoView];
    self.infoView = infoView;
    [infoView addSubview:infoLabel];
}
- (void)speakEnd:(UIButton *)sender {
    if(flag == 1){
        flag = 0;
        return;
    }
    [self.infoView removeFromSuperview];
    // 停止录音
    [self.recorder stop];
    self.recorder = nil;
    [self.animationImage stopAnimating];
    self.animationImage.hidden = YES;
    // 转换格式
    endDate = [NSDate date];
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    if (timeInterval < 1) {
        [self.view makeToast:@"说话时间太短" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
    
        NSString *amrPath = [TeacherDrawViewController getPathByFilename:_recordFileName ofType:@"amr"];
        //    NSString *wavPath = [TeacherDrawViewController getPathByFilename:_recordFileName ofType:@"wav"];
//        int result = [EMVoiceConverter ConvertWavToAmr:_recordFilePath amrSavePath:amrPath];
        int result = [EMVoiceConverter wavToAmr:_recordFilePath amrSavePath:amrPath];
        NSLog(@"%@", result == 1 ? @"格式转换成功" : @"格式转换失败");
        
        // 音频上传七牛云
        NSData *data = [NSData dataWithContentsOfFile:amrPath];
        if (data == nil) {
            return;
        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[BaseURL stringByAppendingString:TEACHER_PIC_SETTING_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            //        NSLog(@"%@", responseObject);
            NSString *upToken = responseObject[@"uptoken"];
            
            [self upfileToQiniu:upToken data:data];
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        

    }
    
//     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}

// 音频上传七牛云
- (void)upfileToQiniu:(NSString *)upToken data:(NSData *)data {

    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:upToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resq){
        if (info.error == nil) {
            NSString *voiceUrl = [NSString stringWithFormat:@"%@%@",QiniuYunURL,[resq objectForKey:@"key"]];
            NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
            NSDictionary *dic = @{@"url":voiceUrl, @"time":[NSNumber numberWithDouble:timeInterval]};
            [self.voiceArr addObject:dic];
            isEdit = YES;
            // 发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceNumShow" object:self userInfo:nil];
            
        }else{
            [self.view hideToastActivity];
            [self.view makeToast:[info.error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    } option:nil];   

}


#pragma mark - 存储
- (void)saveImageAct:(id)sender {
    // 生成图片
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, self.imageview.frame.size.height), YES, 1.0);
    [self.imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
    __block UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.imageview.image=uiImage;
    self.imageview.userInteractionEnabled = NO;
    
    // 判断图片是否做了编辑
    if ([YjyxDrawLine defaultLine].allMyDrawPaletteLineInfos.count != 0) {
        // 图片有改动
        // 图片上传七牛云
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:[BaseURL stringByAppendingString:TEACHER_PIC_SETTING_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSString *upToken = responseObject[@"uptoken"];
            [self uploadImageToQiniu:upToken image:uiImage];
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];

    }else {
        // 图片没有改动
        // 直接上传服务器
        [self uploadAnonitionToSever:self.imgURL];
        
        
    }
    
    
    
    
}

// 图片上传七牛云
- (void)uploadImageToQiniu:(NSString *)token image:(UIImage *)image {
    UIImage *newImage = [self imageCompressForWidth:image targetWidth:SCREEN_WIDTH];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.5);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resq){
        if (info.error == nil) {
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@",QiniuYunURL,[resq objectForKey:@"key"]];
            // 将图片,声音上传服务器
            [self uploadAnonitionToSever:imgUrl];
            
        }else{
            [self.view hideToastActivity];
            [self.view makeToast:[info.error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    } option:nil];

    
}

// 图片尺寸压缩
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 将批注信息上传服务器
- (void)uploadAnonitionToSever:(NSString *)imgUrl {

    [SVProgressHUD showWithStatus:@"正在为您保存"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgUrl, @"img", self.voiceArr, @"teachervoice", nil];
    
    [self.processArr replaceObjectAtIndex:self.imageIndex withObject:dict];
    NSDictionary *parm = [NSDictionary dictionaryWithObjectsAndKeys:@"commentquestionprocess", @"action", self.taskid, @"taskid", self.suid, @"suid", self.qtype, @"qtype", self.qid, @"qid", [self.processArr JSONString], @"writeprocess", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[BaseURL stringByAppendingString:TEACHER_ANOTITATION_POST] parameters:parm success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [SVProgressHUD dismissWithDelay:1.5];
            isEdit = NO;
            [YjyxDrawLine defaultLine].num = 0;
        }else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", responseObject[@"reason"]]];
        
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"保存失败,请检查网络"];
        [SVProgressHUD dismissWithDelay:1];
        
    }];
    
    
}

#pragma mark - 移动声音的位置
- (void)longPressAction:(UILongPressGestureRecognizer *)sender {

    CGPoint longPressLocation = [sender locationInView:self.voiceList];
    // 手势状态
    UIGestureRecognizerState state = sender.state;
    // 获取手势所在indexPath
    NSIndexPath *indexpath = [self.voiceList indexPathForRowAtPoint:longPressLocation];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.

    switch (state) {
        case UIGestureRecognizerStateBegan:
            if (indexpath) {
                sourceIndexPath = indexpath;
                UITableViewCell *cell = [self.voiceList cellForRowAtIndexPath:indexpath];
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.voiceList addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = longPressLocation.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];

            }
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = longPressLocation.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexpath && ![indexpath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.voiceArr exchangeObjectAtIndex:indexpath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.voiceList moveRowAtIndexPath:sourceIndexPath toIndexPath:indexpath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexpath;
                [self.voiceList reloadData];
            }
            break;
        }
            
            
            
        default: {
        
            UITableViewCell *cell = [self.voiceList cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];

        
        }
            break;
    }
    
    
    
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.voiceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.activityView.hidden = YES;
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];
    cell.timeLabel.text = [NSString stringWithFormat:@"%.f''",[[self.voiceArr[indexPath.row] objectForKey:@"time"] floatValue]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceShow:)];
    [cell.voiceDelete addTarget:self action:@selector(deleteTheVoice:) forControlEvents:UIControlEventTouchUpInside];
    [cell.voiceView addGestureRecognizer:tap];
    cell.voiceView.tag = indexPath.row + 200;
    cell.animationImage.tag = indexPath.row + 300;
    cell.voiceDelete.tag = indexPath.row + 400;
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - 删除单个音频
- (void)deleteTheVoice:(UIButton *)sender {
    isEdit = YES;
    if (currentIndex == sender.tag - 400 && [[EMCDDeviceManager sharedInstance] isPlaying] == YES) {
        [self.view makeToast:@"当前语音正在播放,无法删除!" duration:1.0 position:SHOW_CENTER complete:nil];
    }else {
    
        [self.voiceArr removeObjectAtIndex:sender.tag - 400];
        self.voiceNumLabel.text = [NSString stringWithFormat:@"%ld", self.voiceArr.count];
        
        [self.voiceList reloadData];
    }
    
}

#pragma mark - 音频播放
// 下载音频结束
- (void)loadUrlIsFinish
{
    self.selCell.activityView.hidden = YES;
    [self.selCell.activityView stopAnimating];
    [animatingImageview startAnimating];
}
// 音频播放
- (void)voiceShow:(UITapGestureRecognizer *)sender {
    self.selCell.activityView.hidden = YES;
    [self.selCell.activityView stopAnimating];
    VoiceListCell *cell = (VoiceListCell *)sender.view.superview.superview;
    self.selCell = cell;
    NSString *urlString = [_voiceArr[sender.view.tag - 200] objectForKey:@"url"];
    currentIndex = sender.view.tag - 200;
    // 判断是否正在播放
    if (cell.animationImage.isAnimating) {
        [cell.animationImage stopAnimating];
        [[EMCDDeviceManager sharedInstance] stopPlaying];
    }else {
    
        [animatingImageview stopAnimating];
//        [cell.animationImage startAnimating];
        [[EMCDDeviceManager sharedInstance] stopPlaying];
        cell.activityView.hidden = NO;
        [cell.activityView startAnimating];
        animatingImageview = cell.animationImage;
        
        [NotifySoundTool asyncPlayingWithUrl:urlString completion:^(NSError *error) {
            [animatingImageview stopAnimating];
            // 播放完成,自动播放下一句
            if (error == NULL) {
                [self playEnd:currentIndex];
            }
        }];
    }
    
    
}

// 播放结束自动播放下一句
- (void)playEnd:(NSInteger)curIndex {

    if (curIndex < self.voiceArr.count - 1) {
        currentIndex = curIndex + 1;
        UIImageView *imageview = [self.voiceList viewWithTag:currentIndex + 200];
        VoiceListCell *cell = (VoiceListCell *)imageview.superview.superview;
        self.selCell = cell;
        NSString *urlString = [_voiceArr[currentIndex] objectForKey:@"url"];
        
//        [cell.animationImage startAnimating];
        cell.activityView.hidden = NO;
        [cell.activityView startAnimating];
        animatingImageview = cell.animationImage;
        
        [NotifySoundTool asyncPlayingWithUrl:urlString completion:^(NSError *error) {
            [animatingImageview stopAnimating];
            // 播放完成,自动播放下一句
            if (error == NULL) {
                [self playEnd:currentIndex];
            }
        }];

        
    }else {
        currentIndex = -1;
        [self.view makeToast:@"最后一句已经播放完毕" duration:1.0 position:SHOW_CENTER complete:nil];
    }
    
    
}



#pragma mark - voice recording

#pragma mark - 生成当前时间
+ (NSString *)getCurrentTimeString {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormat stringFromDate:[NSDate date]];
}

#pragma mark - 生成文件路径
+ (NSString *)getPathByFilename:(NSString *)fileName ofType:(NSString *)type {

    // 创建audio文件夹
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *audioPath = [NSString stringWithFormat:@"%@/audio", directory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [[[audioPath stringByAppendingPathComponent: fileName] stringByAppendingPathExtension:type] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return filePath;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
