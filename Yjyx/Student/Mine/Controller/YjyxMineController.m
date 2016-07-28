//
//  YjyxMineController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxMineController.h"
#import "YjyxPrivateViewController.h"
#import "YjyxPMemberCenterViewController.h"
@interface YjyxMineController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@end

@implementation YjyxMineController
- (void)awakeFromNib
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.coinBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick)];
    [self.iconImageView addGestureRecognizer:tap];
 
   
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    // 初始化
    self.nameLabel.text = [YjyxOverallData sharedInstance].studentInfo.realname;
    NSString *str1 = [YjyxOverallData sharedInstance].studentInfo.schoolprovincename ? [YjyxOverallData sharedInstance].studentInfo.schoolprovincename : @"";
    
    NSString *str2 = [YjyxOverallData sharedInstance].studentInfo.schoolcityname ? [YjyxOverallData sharedInstance].studentInfo.schoolcityname : @"";
    NSString *str3 = [YjyxOverallData sharedInstance].studentInfo.schoolname ? [YjyxOverallData sharedInstance].studentInfo.schoolname : @"";
    NSString *str4 = [YjyxOverallData sharedInstance].studentInfo.gradename ? [YjyxOverallData sharedInstance].studentInfo.gradename : @"";
    NSString *str5 = [YjyxOverallData sharedInstance].studentInfo.classname ? [YjyxOverallData sharedInstance].studentInfo.classname : @"";
    
    self.gradeLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", str1, str2, str3, str4, str5];
    self.coinLabel.text = [[YjyxOverallData sharedInstance].studentInfo.coins stringValue];
    self.codeLabel.text = [NSString stringWithFormat:@"家长邀请码: %@" ,[YjyxOverallData sharedInstance].studentInfo.invitecode ];
    // 头像
    if ([[YjyxOverallData sharedInstance].studentInfo.avatar_url isEqual:[NSNull null]]) {
        
        [self.iconImageView setImage:[UIImage imageNamed:@"teacher_p"]];
        
    }else {
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:[YjyxOverallData sharedInstance].studentInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"pic"]];
    }
    
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.iconImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    self.iconImageView.layer.borderWidth = 4.0f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 方法重调
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.iconImageView.layer.cornerRadius = self.iconImageView.layer.frame.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
    
}
#pragma mark - 点击方法
// 设置按钮的点击
- (IBAction)setterBtnClick:(UIButton *)sender {
    YjyxPrivateViewController *vc = [[YjyxPrivateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 点击了头像
- (void)iconImageViewClick
{
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
    [manager GET:[BaseURL stringByAppendingString:STUDENT_PIC_SETTING_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
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

-(void)uploadPortrait:(NSString *)url image:(UIImage *)image
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"chavatar",@"action",url,@"url", nil];
    
    [[YjxService sharedInstance] studentUploadFile:dic withBlock:^(id result, NSError *error) {
        
        [self.view hideToastActivity];
        
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                _iconImageView.image = image;
                //                [_picImage setCornerRadius:_picImage.height /2];
                
                [YjyxOverallData sharedInstance].studentInfo.avatar_url = url;
                
                NSLog(@"%@+++++", [YjyxOverallData sharedInstance].studentInfo.avatar_url);
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        
    }];
    
    
}

// 点击金币
- (IBAction)coinBtnClick:(id)sender {
    [self.view makeToast:@"敬请期待" duration:1.0 position:SHOW_CENTER complete:nil];
}

// 点击签到
- (IBAction)signBtnClick:(UIButton *)sender {
    [self.view makeToast:@"敬请期待" duration:1.0 position:SHOW_CENTER complete:nil];
}

// 点击我的统计
- (IBAction)myCountBtnClick:(UIButton *)sender {
    [self.view makeToast:@"敬请期待" duration:1.0 position:SHOW_CENTER complete:nil];
}

// 点击常用工具
- (IBAction)commonToolBtnClick:(UIButton *)sender {
    [self.view makeToast:@"敬请期待" duration:1.0 position:SHOW_CENTER complete:nil];
}

// 点击课程表
- (IBAction)courseFormBtnClick:(UIButton *)sender {
    [self.view makeToast:@"敬请期待" duration:1.0 position:SHOW_CENTER complete:nil];
}

// 点击会员中心
- (IBAction)privateDiaryBtnClick:(UIButton *)sender {
    YjyxPMemberCenterViewController *vc = [[YjyxPMemberCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
