//
//  YjyxFeedBackViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/5/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxFeedBackViewController.h"

@interface YjyxFeedBackViewController ()

@end

@implementation YjyxFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setTitle:@"取消" forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goBackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.title = @"我要吐槽";
    
    dynamicScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, SCREEN_WIDTH/4) withImages:nil];
    dynamicScrollView.delegate = self;
    
    imageUrlAry = [[NSMutableArray alloc] init];
    
    [self.view addSubview:dynamicScrollView];
    
    finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, 175+SCREEN_WIDTH/4, finishBtn.frame.size.width, 40);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
    [self.view addGestureRecognizer:tap];

    
    contentText = [[FEPlaceHolderTextView alloc] initWithFrame:CGRectMake(3, 0, SCREEN_WIDTH-6, feedView.frame.size.height)];
    contentText.placeholder = @"请简要描述您的问题和意见";
    contentText.font = [UIFont systemFontOfSize:14];
    [feedView addSubview:contentText];
    [contentText becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [super viewWillDisappear:YES];
}

-(void)clicked:(id)sender
{
    [self.view hideKeyboard];
}


#pragma mark -pickerImageSelect
- (void)deleteImageWithIndex:(NSInteger)index
{
    [imageUrlAry removeObjectAtIndex:index];
}

-(void)selectImage
{
    [self.view hideKeyboard];
    if ([imageUrlAry count]>=6) {
        [self.view makeToast:@"最多提交可提交6张图片" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
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
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)upfiletoQiniu:(NSString *)token image:(UIImage*)image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resq){
        if (info.error == nil) {
            NSString *portraitUrl = [NSString stringWithFormat:@"%@%@",QiniuYunURL,[resq objectForKey:@"key"]];
            [dynamicScrollView addImageView:image];
            [imageUrlAry addObject:portraitUrl];
            [self.view hideToastActivity];
            
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

                
                [YjyxOverallData sharedInstance].parentInfo.avatar = url;
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitFeedBack:(id)sender
{
    if (contentText.text.length ==0&&[imageUrlAry count] == 0) {
         [self.view makeToast:@"请输入您的意见反馈" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:contentText.text,@"description",[imageUrlAry JSONString],@"images", nil];
    [self.view makeToastActivity:SHOW_CENTER];
    [[YjxService sharedInstance] feedBack:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];

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
