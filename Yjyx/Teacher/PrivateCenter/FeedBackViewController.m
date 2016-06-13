//
//  FeedBackViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/18.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FEPlaceHolderTextView.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "SVProgressHUD.h"
#import "UploadImageTool.h"
#import "YjxService.h"


@interface FeedBackViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
    FEPlaceHolderTextView *contentText;
    

}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionViewBGview;

@property (weak, nonatomic) IBOutlet UIView *textBGview;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;



@end

@implementation FeedBackViewController


- (void)viewWillAppear:(BOOL)animated {
    
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    // finishBtn设置
    self.finishBtn.layer.cornerRadius = 20;
    self.finishBtn.backgroundColor = TEACHERCOLOR;
    
    // 配置textview
    [self configureTextview];
    
    // 配置collectionView,图片显示样式
    [self configureCollectionView];
    

    
}

/**
 * 配置textView
 */
- (void)configureTextview {

    contentText = [[FEPlaceHolderTextView alloc] initWithFrame:CGRectMake(3, 0, SCREEN_WIDTH-6, self.textBGview.frame.size.height)];
    contentText.placeholder = @"请简要描述您的问题和意见";
    contentText.font = [UIFont systemFontOfSize:14];
    [_textBGview addSubview:contentText];
    [contentText becomeFirstResponder];

}

/**
 * 配置collectionView,图片显示样式
 */
- (void)configureCollectionView {

    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 0;
    _itemWH = (SCREEN_WIDTH - 2 * _margin - 4) / 5 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 3, SCREEN_WIDTH, 160) collectionViewLayout:_layout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionViewBGview addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [contentText endEditing:YES];
}

#pragma mark - 点击完成,上传
- (IBAction)finishBtnClick:(UIButton *)sender {
    
    
    // 判断字数超出300提示
    if (contentText.text.length > 300) {
        [self.view makeToast:@"您输入的内容超过了300字数限制" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if (contentText.text.length ==0&&[_selectedPhotos count] == 0) {
        [self.view makeToast:@"请输入您的意见反馈" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }

    [SVProgressHUD showWithStatus:@"正在拼命上传"];
    
    [UploadImageTool uploadImages:_selectedPhotos progress:nil success:^(NSArray *urlArray) {
        
            
            NSString *jsonString = [urlArray JSONString];
            
            // 上传给自己的服务器
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:contentText.text,@"description", jsonString,@"images", nil];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager POST:[BaseURL stringByAppendingString:TEACHER_FEEDBACK] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"%@", responseObject);
                
                if ([responseObject[@"retcode"] isEqual:@0]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"感谢您的反馈"];
                    [SVProgressHUD dismissWithDelay:1.5];
                    [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
                    
                }else {
                    
                    //                [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
                    [SVProgressHUD showErrorWithStatus:responseObject[@"reason"]];
                    [SVProgressHUD dismissWithDelay:1.5];
                    [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
                }
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
            }];
            

            
        } failure:^{
            
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
            [SVProgressHUD dismissWithDelay:1.5];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
            
        }];
        

    
}

- (void)goBack {

    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pickPhotoButtonClick:nil];
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    
    // 设置支持最多照片数目
    int maxCount = 6;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    
    // 不可以选择原图,太费流量
     imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
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
