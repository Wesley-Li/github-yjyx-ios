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
#import "VoiceConverter.h"


@import AVFoundation;
@import AudioToolbox;

@interface TeacherDrawViewController ()<AVAudioRecorderDelegate>
{
    BOOL isExpand;
    NSDate *startDate;
    NSDate *endDate;
    

}

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
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSString *recordFileName;
@property (strong, nonatomic) NSString *recordFilePath;


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
    
    if (self.voiceArr.count == 0) {
        self.voiceImage.hidden = YES;
        self.voiceNumLabel.hidden = YES;
    }
    
    self.voiceImage.userInteractionEnabled = YES;
    self.voiceNumLabel.layer.cornerRadius = 7.5;
    self.voiceNumLabel.layer.masksToBounds = YES;
    self.voiceNumLabel.userInteractionEnabled = NO;
    self.voiceBtn.layer.cornerRadius = 41;
    self.voiceBtn.layer.masksToBounds = YES;
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
    [self recordingAnimationConfigure];
    
    // 注册cell
    [self.voiceList registerNib:[UINib nibWithNibName:NSStringFromClass([VoiceListCell class]) bundle:nil] forCellReuseIdentifier:@"ID"];
    self.voiceList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.voiceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

// 点击声音按钮
- (void)handleTap:(UITapGestureRecognizer *)sender {

    self.voiceNumLabel.hidden = YES;
    self.voiceImage.hidden = YES;
    [self.view bringSubviewToFront:self.voiceList];

    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
    self.voiceImage.hidden = NO;
    self.voiceNumLabel.hidden = NO;
    [self.view sendSubviewToBack:self.voiceList];
    

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

- (void)viewDidAppear:(BOOL)animated {

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

// 蓝色笔
- (IBAction)drawBlueLine:(UIButton *)sender {
    
    self.bluePenBtn.selected = YES;
    self.yellowPenBtn.selected = NO;
    self.redPenBtn.selected = NO;
    [YjyxDrawLine defaultLine].currentPaintBrushColor = [UIColor blueColor];
    
}

// 黄色笔
- (IBAction)drawYelloewLine:(UIButton *)sender {
    self.bluePenBtn.selected = NO;
    self.yellowPenBtn.selected = YES;
    self.redPenBtn.selected = NO;
    [YjyxDrawLine defaultLine].currentPaintBrushColor = [UIColor yellowColor];
}

// 红色笔
- (IBAction)drawRedLine:(UIButton *)sender {
    self.bluePenBtn.selected = NO;
    self.yellowPenBtn.selected = NO;
    self.redPenBtn.selected = YES;
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
    
    NSLog(@"开始录音了");
    
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
    // 初始化录音
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_recordFilePath] settings:[VoiceConverter GetAudioRecorderSettingDict] error:nil];
    
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    // 准备录音
    [self.recorder prepareToRecord];
    [self.recorder record];

    
    
}

// 录音结束
- (void)speakEnd:(UIButton *)sender {

    // 停止录音
    [self.recorder stop];
    self.recorder = nil;
    // 转换格式
    endDate = [NSDate date];
    NSString *amrPath = [TeacherDrawViewController getPathByFilename:_recordFileName ofType:@"amr"];
    NSString *wavPath = [TeacherDrawViewController getPathByFilename:_recordFileName ofType:@"wav"];
    int result = [VoiceConverter ConvertWavToAmr:wavPath amrSavePath:amrPath];
    NSLog(@"%@", result == 1 ? @"格式转换成功" : @"格式转换失败");
    
    // 上传七牛云
    
    NSData *data = [NSData dataWithContentsOfFile:amrPath];
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

// 上传七牛云
- (void)upfileToQiniu:(NSString *)upToken data:(NSData *)data {

    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:upToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resq){
        if (info.error == nil) {
            NSString *voiceUrl = [NSString stringWithFormat:@"%@%@",QiniuYunURL,[resq objectForKey:@"key"]];
            NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
            NSDictionary *dic = @{@"url":voiceUrl, @"time":[NSNumber numberWithDouble:timeInterval]};
            [self.voiceArr addObject:dic];
            
            // 发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceNumShow" object:self userInfo:nil];
            [self.animationImage stopAnimating];
            self.animationImage.hidden = YES;
        }else{
            [self.view hideToastActivity];
            [self.view makeToast:[info.error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    } option:nil];

}


// 保存
- (void)saveImageAct:(id)sender {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, self.imageview.frame.size.height), YES, 1.0);
    [self.imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.imageview.image=uiImage;
    self.imageview.userInteractionEnabled = NO;
    
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
    
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];
    cell.timeLabel.text = [NSString stringWithFormat:@"%.f''",[[self.voiceArr[indexPath.row] objectForKey:@"time"] floatValue]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceShow:)];
    [cell.voiceView addGestureRecognizer:tap];
    cell.voiceView.tag = indexPath.row + 200;
    
    return cell;
}

// 音频播放
- (void)voiceShow:(UITapGestureRecognizer *)sender {

    VoiceListCell *cell = (VoiceListCell *)sender.view.superview.superview;
    [cell.animationImage startAnimating];
    NSLog(@"%@", self.voiceArr);
    
    
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

    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:type] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
