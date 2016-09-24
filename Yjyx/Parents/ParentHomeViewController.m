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
#import "YjyxPMemberCenterViewController.h"
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
    _iconImage.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    _iconImage.layer.borderWidth = 4.0f;
    _iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    [_iconImage addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSwitch) name:@"ChildActivityNotification" object:nil];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    
    if (((AppDelegate *)SYS_DELEGATE).isComeFromNoti == YES) {
        [self getRemote];
    }
    // Do any additional setup after loading the view from its nib.
    
//    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.frame = CGRectMake(50, 50, 30, 30);
//    imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cdn-web-img.zgyjyx.com/mgr/cb7ae464b0f82abf2e6dcad28fedbee6"]] scale:1];
//    [self.view addSubview:imageV];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -MyEvent

- (void)getRemote {

    NSDictionary *userInfo = ((AppDelegate *)SYS_DELEGATE).remoteNoti;
    
    if ([userInfo[@"type"] isEqualToString:@"childactivity"]) {//
        if ([userInfo[@"finished"] integerValue] == 0 ) {
            if ([userInfo[@"tasktype"] integerValue] ==1) {
                [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
            }else{
                [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
            }
        }else{
            if ([userInfo[@"tasktype"] integerValue] ==1) {
                [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTHOMEWORK;
            }else{
                [YjyxOverallData sharedInstance].pushType = PUSHTYPE_RESULTMICRO;
            }
        }
        [YjyxOverallData sharedInstance].historyId = userInfo[@"id"];
        [YjyxOverallData sharedInstance].previewRid = userInfo[@"rid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildActivityNotification" object:nil];
        
    }else if ([userInfo[@"type"] isEqualToString:@"hastentask"]){
        
        if ([userInfo[@"tasktype"] integerValue] == 1) {
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
        }else{
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
        }
        
        [YjyxOverallData sharedInstance].previewRid = userInfo[@"rid"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildActivityNotification" object:nil];
        
    }else if ([userInfo[@"type"] isEqualToString:@"childstats"]) {//统计数据更新处理
        NSString *cachePath = [USER_IMGCACHE stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"cid"]]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachePath error:nil];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *fileName;
        while (fileName = [e nextObject]) {
            [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName] error:NULL];
        }
    }

}


-(void)pushSwitch
{
    ((AppDelegate *)SYS_DELEGATE).isComeFromNoti = nil;
        switch ([YjyxOverallData sharedInstance].pushType) {
                
                
            case 1:{
                YjyxWorkPreviewViewController *result = [[YjyxWorkPreviewViewController alloc] init];
                result.previewRid = [YjyxOverallData sharedInstance].previewRid;
                result.title = @"作业预览";
                [result setHidesBottomBarWhenPushed:YES];
                [((AppDelegate *)SYS_DELEGATE).tabBar.selectedViewController pushViewController:result animated:YES];
            }
                break;
            case 2:{
                YjyxMicroClassViewController *result = [[YjyxMicroClassViewController alloc] init];
                result.previewRid = [YjyxOverallData sharedInstance].previewRid;
                result.title = @"微课预览";
                [result setHidesBottomBarWhenPushed:YES];

                [((AppDelegate *)SYS_DELEGATE).tabBar.selectedViewController pushViewController:result animated:YES];
            }
                break;
            case 3:{
                ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
                result.taskResultId = [YjyxOverallData sharedInstance].historyId;
                result.title = @"结果详情";
                [result setHidesBottomBarWhenPushed:YES];

                [((AppDelegate *)SYS_DELEGATE).tabBar.selectedViewController pushViewController:result animated:YES];
            }
                break;
            case 4:{
                ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
                result.taskResultId = [YjyxOverallData sharedInstance].historyId;
                [result setHidesBottomBarWhenPushed:YES];
                result.title = @"结果详情";

                [((AppDelegate *)SYS_DELEGATE).tabBar.selectedViewController pushViewController:result animated:YES];
            }
                break;
            default:
                break;
        }

    
    
}
// 会员中心的点击
- (IBAction)memberCenterClick:(UIButton *)sender {
    YjyxPMemberCenterViewController *vc = [[YjyxPMemberCenterViewController alloc] init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_picker setAllowsEditing:YES];
        [self.navigationController presentViewController:_picker animated:YES completion:nil];

    } else if(buttonIndex == 1){
        if (![AccessJudge libraryAccessJudge])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启相机:设置 > 隐私 > 照片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [_picker setAllowsEditing:YES];
        [self.navigationController presentViewController:_picker animated:YES completion:nil];

    }
}

#pragma mark -UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.view makeToastActivity:SHOW_CENTER];
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];;
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
    UIImage *newImage = [self imageCompressForWidth:image targetWidth:SCREEN_WIDTH];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.3);
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
