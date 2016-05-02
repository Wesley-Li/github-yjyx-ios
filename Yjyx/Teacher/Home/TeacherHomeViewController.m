//
//  TeacherHomeViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TeacherHomeViewController.h"

@interface TeacherHomeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation TeacherHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.picImage.image =[UIImage imageNamed:@"pic.png"];
    self.picImage.contentMode = UIViewContentModeScaleAspectFit;
//    self.picImage.layer.cornerRadius = self.picImage.frame.size.height/2;
//    self.picImage.layer.masksToBounds = YES;
    self.picImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.picImage.layer.borderWidth = 5.0f;
    
    
    [self addTapToPicImage];
    
}

// 方法重调
- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    self.picImage.layer.cornerRadius = self.picImage.layer.frame.size.height/2;
    self.picImage.layer.masksToBounds = YES;

}


#pragma mark - 点击积分按钮
- (IBAction)handleScoreBtn:(id)sender {
    
    NSLog(@"点击了积分商城");
    
}
#pragma mark - 点击签到按钮
- (IBAction)handleReport:(id)sender {
    
    NSLog(@"点击了签到");
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
        pickerIamge.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self.view makeToastActivity:SHOW_CENTER];
    UIImage *image = [info[UIImagePickerControllerOriginalImage] fixOrientation];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
    [[YjxService sharedInstance] getAboutqinniu:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                NSString *token = [result objectForKey:@"uptoken"];
                [self upfiletoQiniu:token image:image];
            }else{
                [self.view hideToastActivity];
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view hideToastActivity];
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

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
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                _iconImage.image = image;
                [_iconImage setCornerRadius:_iconImage.height /2];
                
                [YjyxOverallData sharedInstance].parentInfo.avatar = url;
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    
}



#pragma mark - 点击学生任务
- (IBAction)handleStuTask:(id)sender {
    NSLog(@"点击了学生任务");
}


#pragma mark - 点击数据统计
- (IBAction)handleAcount:(id)sender {
    
    NSLog(@"点击了数据统计");
}


#pragma mark - 点击我的微课
- (IBAction)handleMicroClass:(id)sender {
    
    NSLog(@"点击了我的微课");
}

#pragma mark - 点击积分商城
- (IBAction)handleMall:(id)sender {
    
    NSLog(@"点击了积分商城");
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
