//
//  ParentHomeViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentHomeViewController.h"
#import "MyChildrenViewController.h"
#import "ChildrenStatisticViewController.h"
#import "ChildrenResultViewController.h"
#import "YjyxMicroClassViewController.h"
#import "YjyxWorkPreviewViewController.h"
#import "YjyxShopMallViewController.h"

@interface ParentHomeViewController ()

@end

@implementation ParentHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationController.navigationBar.translucent = YES;
    [_iconImage setImageWithURL:[NSURL URLWithString:[YjyxOverallData sharedInstance].parentInfo.avatar] placeholderImage:[UIImage imageNamed:@"Parent_default.png"]];
    [_iconImage setCornerRadius:_iconImage.height /2];
    _iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    [_iconImage addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSwitch) name:@"ChildActivityNotification" object:nil];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    // Do any additional setup after loading the view from its nib.
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = RGBACOLOR(23, 155, 121, 1);
    self.navigationController.navigationBarHidden = YES ;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden = YES ;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -MyEvent

-(void)pushSwitch
{
    switch ([YjyxOverallData sharedInstance].pushType) {
        case 1:{
            YjyxWorkPreviewViewController *result = [[YjyxWorkPreviewViewController alloc] init];
            result.previewRid = [YjyxOverallData sharedInstance].previewRid;
            result.title = @"作业预览";
            [result setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:result animated:YES];
        }
            break;
        case 2:{
            YjyxMicroClassViewController *result = [[YjyxMicroClassViewController alloc] init];
            result.previewRid = [YjyxOverallData sharedInstance].previewRid;
            result.title = @"微课预览";
            [result setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:result animated:YES];
        }
            break;
        case 3:{
            ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
            result.taskResultId = [YjyxOverallData sharedInstance].historyId;
            result.title = @"结果详情";
            [result setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:result animated:YES];
            
        }
            break;
        case 4:{
            ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
            result.taskResultId = [YjyxOverallData sharedInstance].historyId;
            [result setHidesBottomBarWhenPushed:YES];
            result.title = @"结果详情";
            [self.navigationController pushViewController:result animated:YES];
            
        }
            break;
        default:
            break;
    }

}

-(IBAction)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
        {
            MyChildrenViewController *childrenCtl = [[MyChildrenViewController alloc] init];
            [childrenCtl setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:childrenCtl animated:YES];
            break;
        }
        case 101:
        {
            ChildrenStatisticViewController *childrenstatist = [[ChildrenStatisticViewController alloc] init];
            [childrenstatist setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:childrenstatist animated:YES];
            break;
        }
        case 102:
        {
            YjyxShopMallViewController *vc = [[YjyxShopMallViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -ChangePortrait
-(void)changeIcon
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"更换头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从相册中选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    if (buttonIndex == 0) {
        if (![AccessJudge carmerAccessJudge])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启相机:设置 > 隐私 > 相机" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [_picker setAllowsEditing:NO];
        [self.navigationController presentViewController:_picker animated:YES completion:nil];

    } else if(buttonIndex == 1){
        if (![AccessJudge libraryAccessJudge])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启相机:设置 > 隐私 > 照片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [_picker setAllowsEditing:NO];
        [self.navigationController presentViewController:_picker animated:YES completion:nil];

    }
}

#pragma mark -UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
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
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
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
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"chavatar",@"action",url,@"url",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
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
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];

}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
