//
//  TeacherHomeViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TeacherHomeViewController.h"
#import "UIImageView+WebCache.h"
#import "StuTaskTableViewController.h"

#import "StatisticController.h"


#import "MyMicroMainController.h"
#import "ReleaseMicroController.h"
#import "YjyxShopDisplayController.h"
@interface TeacherHomeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;




@end

@implementation TeacherHomeViewController

- (void)viewWillAppear:(BOOL)animated {
//    [self judgeTimeIsOneDay];
    self.signLabel.hidden = YES;
    self.signButton.hidden = YES;
     _nameLabel.text = [YjyxOverallData sharedInstance].teacherInfo.name;
    self.navigationController.navigationBarHidden = YES;
    // 积分
    _scoreLabel.text = [YjyxOverallData sharedInstance].teacherInfo.coins;
    
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = NO;
}

- (void)judgeTimeIsOneDay {
    if (![SYS_CACHE objectForKey:@"signDate"]) {
        _signButton.userInteractionEnabled = YES;
        _signLabel.text = @"签到有奖";
    }else {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *strDateNow = [formatter stringFromDate:[NSDate date]];
        NSString *strDateOld = [formatter stringFromDate:[SYS_CACHE objectForKey:@"signDate"]];
        if ([strDateNow isEqualToString:strDateOld]) {
            _signButton.userInteractionEnabled = NO;
            _signLabel.text = @"已签到";
        }else {
        
            _signButton.userInteractionEnabled = YES;
            _signLabel.text = @"签到有奖";
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    // 头像
    if ([[YjyxOverallData sharedInstance].teacherInfo.avatar isEqual:[NSNull null]]) {
        
        [self.picImage setImage:[UIImage imageNamed:@"teacher_p"]];
        
    }else {
    
        [self.picImage setImageWithURL:[NSURL URLWithString:[YjyxOverallData sharedInstance].teacherInfo.avatar] placeholderImage:[UIImage imageNamed:@"pic"]];
    }
    
    
    
    self.picImage.contentMode = UIViewContentModeScaleAspectFit;

    self.picImage.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    self.picImage.layer.borderWidth = 4.0f;
    
    // 名字
    _nameLabel.text = [YjyxOverallData sharedInstance].teacherInfo.name;
    

    
    // 简介
#warning 后续可能会加上老师的科目信息
    _descriptionLabel.text = [NSString stringWithFormat:@"%@",  [YjyxOverallData sharedInstance].teacherInfo.school_name];
    
    
    [self addTapToPicImage];
    
    // 程序沙盒路径
//    NSLog(@"#####%@", NSHomeDirectory());
    
}

// 方法重调
- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    self.picImage.layer.cornerRadius = self.picImage.layer.frame.size.height/2;
    self.picImage.layer.masksToBounds = YES;

}


- (void)dealloc
{
    NSLog(@"teahcer delooc");
}


#pragma mark - 点击积分按钮
- (IBAction)handleScoreBtn:(id)sender {
  
    // 积分按钮暂时不可点击
    
}

#pragma mark - 点击签到按钮
- (IBAction)handleReport:(UIButton *)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:@"/api/checkin/"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] isEqual:@0]) {
            _signLabel.text = @"已签到";
            sender.userInteractionEnabled = NO;
            NSDate *signDate = [NSDate date];
            [SYS_CACHE setObject:signDate forKey:@"signDate"];
            
        }else {
        
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:@"貌似网络出了点问题" duration:1.0 position:SHOW_CENTER complete:nil];
    }];

}

#pragma mark - 点击更换头像
- (void)addTapToPicImage {
    
    // 打开交互
    self.picImage.userInteractionEnabled = YES;
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicImage:)];
    
    [self.picImage addGestureRecognizer:tap];
    
}

#pragma mark - 点击头像

- (void)tapPicImage:(UITapGestureRecognizer *)tapGesture {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从图库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerIamge = [[UIImagePickerController alloc] init];
        pickerIamge.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 允许编辑
        pickerIamge.allowsEditing = YES;
        pickerIamge.delegate = self;
        [self presentViewController:pickerIamge animated:YES completion:nil];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerIamge = [[UIImagePickerController alloc] init];
        pickerIamge.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 允许编辑
        pickerIamge.allowsEditing = YES;
        pickerIamge.delegate = self;
        [self presentViewController:pickerIamge animated:YES completion:nil];

        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}

// 头像更换代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self.view makeToastActivity:SHOW_CENTER];
//    UIImage *image = [info[UIImagePickerControllerOriginalImage] fixOrientation];
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_PIC_SETTING_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"%@", responseObject);
        NSString *upToken = responseObject[@"uptoken"];
        
        [self upfiletoQiniu:upToken image:image];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

// 上传头像
-(void)upfiletoQiniu:(NSString *)token image:(UIImage*)image
{
    UIImage *imageNew = [self imageCompressForWidth:image targetWidth:self.picImage.width];
    NSData *data = UIImageJPEGRepresentation(imageNew, 0.3);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resq){
        if (info.error == nil) {
            NSString *portraitUrl = [NSString stringWithFormat:@"%@%@",QiniuYunURL,[resq objectForKey:@"key"]];
            [self uploadPortrait:portraitUrl image:image];
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

-(void)uploadPortrait:(NSString *)url image:(UIImage *)image
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"chavatar",@"action",url,@"url", nil];
    
    [[YjxService sharedInstance] teacherUploadFile:dic withBlock:^(id result, NSError *error) {
        
        [self.view hideToastActivity];
        
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                _picImage.image = image;
//                [_picImage setCornerRadius:_picImage.height /2];
                
                [YjyxOverallData sharedInstance].teacherInfo.avatar = url;
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }

        
    }];
    
    
}



#pragma mark - 点击学生任务
- (IBAction)handleStuTask:(id)sender {
    NSLog(@"点击了学生任务");
    
    StuTaskTableViewController *stuTaskTVC = [[StuTaskTableViewController alloc] init];
    [self.navigationController pushViewController:stuTaskTVC animated:YES];
    
}


#pragma mark - 点击数据统计
- (IBAction)handleAcount:(id)sender {
    
    StatisticController *staVC = [[StatisticController alloc] init];
    [self.navigationController pushViewController:staVC animated:YES];
}


#pragma mark - 点击我的微课
- (IBAction)handleMicroClass:(id)sender {
    MyMicroMainController *microVc = [[MyMicroMainController alloc] init];
    [self.navigationController pushViewController:microVc animated:YES];
   
    
}

#pragma mark - 点击积分商城
- (IBAction)handleMall:(id)sender {
    
    YjyxShopDisplayController *shopVc = [[YjyxShopDisplayController alloc] init];
    [self.navigationController pushViewController:shopVc animated:YES];
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
