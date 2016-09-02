//
//  YjyxDoWorkCollectionCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/30.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDoWorkCollectionCell.h"
#import "YjyxDoingWorkModel.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "SVProgressHUD.h"
#import "UploadImageTool.h"
@interface YjyxDoWorkCollectionCell()<UIWebViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate>
{
//    NSInteger count; // 题目的个数
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    NSMutableArray *_urlArr;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgAnswerBottomConst;
@property (weak, nonatomic) IBOutlet UILabel *solveProcessLabel; // 解题过程的label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst; // 解题过程的底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processHeightConst; // 图片collview的高度约束
@property (weak, nonatomic) IBOutlet UIWebView *webView; // 题目内容
@property (weak, nonatomic) IBOutlet UIView *answerBgView; // 整个答案的背景view
@property (weak, nonatomic) IBOutlet UIScrollView *blankScrollV; // 填空题答案的view
@property (weak, nonatomic) IBOutlet UIView *choiceAnswerView; // 选择题答案的view
@property (weak, nonatomic) IBOutlet UIView *processBgView; // 解题过程图片的背景view
@property (weak, nonatomic) IBOutlet UICollectionView *processCollectionView; // 解题过程的图片
@property (weak, nonatomic) IBOutlet UIButton *nextWorkBtn;

@property (assign, nonatomic) CGSize preSize;
@end
@implementation YjyxDoWorkCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.blankScrollV.bounces = NO;
    self.blankScrollV.showsVerticalScrollIndicator = NO;
    self.blankScrollV.showsHorizontalScrollIndicator = NO;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.answerBgView.layer.borderWidth = 1;
//    self.answerBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.detectsPhoneNumbers = NO;
    
    _itemWH = SCREEN_WIDTH  / 5;
    [self setupCollectionView];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _urlArr = [NSMutableArray array];
    self.processHeightConst.constant = _itemWH;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setModel:(YjyxDoingWorkModel *)model
{
    _model = model;
    if ([model.requireprocess integerValue] == 0) {
        self.processHeightConst.constant = 0;
        self.bottomConst.constant  = - 29;
        self.solveProcessLabel.hidden = YES;
    }else{
        self.processHeightConst.constant = _itemWH;
        self.bottomConst.constant = 5;
        self.solveProcessLabel.hidden = NO;
    }
    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";

    model.content = [model.content  stringByReplacingOccurrencesOfString:@"<p>" withString:str];
    NSLog(@"%@",model.content);
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    
    [_webView loadHTMLString:jsString baseURL:nil];
    // 学生答案
    if(model.questiontype == 2){
        self.choiceAnswerView.hidden = YES;
        self.blankScrollV.hidden = NO;
        for (UIView *view in self.blankScrollV.subviews) {
            [view removeFromSuperview];
        }
//        int count = [model.blankcount integerValue];
        for (int i = 0; i < [model.blankcount integerValue]; i++) {
         
            UITextField *blankAnswer = [[UITextField alloc] init];
            blankAnswer.tag = i + 200;
            blankAnswer.delegate = self;
            //        blankAnswer1.borderStyle = UITextBorderStyleLine;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 39)];
            label.text = [NSString stringWithFormat:@"%d", i + 1];
            label.textAlignment = NSTextAlignmentCenter;
            blankAnswer.tintColor = [UIColor lightGrayColor];
            blankAnswer.leftView = label;
            blankAnswer.leftViewMode = UITextFieldViewModeAlways;
            blankAnswer.backgroundColor = [UIColor whiteColor];
            blankAnswer.placeholder = @" 请填写答案";
            blankAnswer.text = model.blankfillArr[i];
            blankAnswer.frame = CGRectMake(0, 40 * i , SCREEN_WIDTH - 70, 40 -1);
            [self.blankScrollV addSubview:blankAnswer];
        }
        if([model.blankcount integerValue] == 1){
            UIView *blankAnswer = [[UIView alloc] init];
            blankAnswer.backgroundColor = [UIColor whiteColor];
            blankAnswer.userInteractionEnabled = NO;
            blankAnswer.frame = CGRectMake(0, 40 , SCREEN_WIDTH - 70, 40 -1);
            [self.blankScrollV addSubview:blankAnswer];
        }
        self.blankScrollV.contentSize = CGSizeMake(SCREEN_WIDTH - 70, 40 * [model.blankcount integerValue]);
    }else{
        for (UIView *view in self.choiceAnswerView.subviews) {
            [view removeFromSuperview];
        }
        self.choiceAnswerView.hidden = NO;
        self.blankScrollV.hidden = YES;
        NSArray *choiceAnswer = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
        CGFloat margin = 3;
        CGFloat BtnWH = 0;
        int count = [model.choicecount integerValue];
        if([model.choicecount integerValue] <= 5){
            BtnWH = (SCREEN_WIDTH - 70 - (count + 1) * margin) / count;
            if(BtnWH >= 70){
                BtnWH = 60;
                margin = ((SCREEN_WIDTH - 71) - count * BtnWH) / (count + 1);
            }
        }else{
            BtnWH = 35;
            margin = (SCREEN_WIDTH - 70 - 5 * BtnWH) / 6;
            
        }
        for (int i = 0; i < count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:choiceAnswer[i] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            [btn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 1;
            [self.choiceAnswerView addSubview:btn];
            btn.width = BtnWH;
            btn.height = BtnWH;
            if(count <= 5){
                btn.center = CGPointMake(margin + BtnWH / 2 + (margin + BtnWH) * (i % 5), 79 / 2);
            }else{
                btn.center = CGPointMake(margin + BtnWH / 2 + (margin + BtnWH) * (i % 5), 79 / 4 + (79  * 2 / 4) * (i / 5));
            }
            if ([model.answerArr containsObject:[NSNumber numberWithInteger:i]]) {
                btn.backgroundColor = STUDENTCOLOR;
            }else{
                btn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    // 上传解答
    _selectedPhotos = model.processImgArr;
    _urlArr = model.processImgUrlArr;
    _selectedAssets = model.processAssetArr;
    [self.processCollectionView reloadData];
    // 下一题与提交
    if(self.tag == 1000){
        self.nextWorkBtn.backgroundColor = STUDENTCOLOR;
        [self.nextWorkBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        self.nextWorkBtn.backgroundColor = [UIColor whiteColor];
        [self.nextWorkBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
    

}
// 选择题答案的点击
- (IBAction)answerBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = STUDENTCOLOR;
        [_model.answerArr addObject:[NSNumber numberWithInteger:sender.tag - 1]];
    }else{
        sender.backgroundColor = [UIColor whiteColor];
        [_model.answerArr removeObject:[NSNumber numberWithInteger:sender.tag - 1]];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGRect frame = webView.frame;
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if (img.width > %f) {\
    img.style.maxWidth = %f; \
    }\
    } \
    }";
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 10, SCREEN_WIDTH - 10];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
//    frame.size.height = webView.scrollView.contentSize.height;
//    webView.frame = frame;
//
}
#pragma mark - 下一题点击
- (IBAction)nextWorkBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doWorkCollectionCell:nextWorkBtnIsClick:)]) {
        [self.delegate doWorkCollectionCell:self nextWorkBtnIsClick:sender];
    }
}
#pragma mark -UITextFieldDelegate代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UITextField *newField = [self viewWithTag:textField.tag + 1];
    [newField becomeFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *str = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([str isEqualToString:@""]){
       [_model.blankfillArr replaceObjectAtIndex:textField.tag - 200 withObject:str];
    }else{
        [_model.blankfillArr replaceObjectAtIndex:textField.tag - 200 withObject:textField.text];
    }
    
}
#pragma mark 第三方上传图片
#pragma mark UICollectionViewData
- (void)setupCollectionView
{
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 0;
    
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    self.processCollectionView.collectionViewLayout = layout;
    self.processCollectionView.backgroundColor = [UIColor whiteColor];
    self.processCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.processCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.processCollectionView.dataSource = self;
    self.processCollectionView.delegate = self;
    
    [self.processCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld", _selectedPhotos.count);
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
        NSLog(@"%@, %@", _selectedAssets, _selectedPhotos);
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        NSLog(@"%@, %@", _selectedAssets, _selectedPhotos);
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray<PHAsset *> *assets, BOOL isSelectOriginalPhoto) {
            //            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            //            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            
            
            NSMutableArray *tempArr = [NSMutableArray array];
            [tempArr addObjectsFromArray:assets];
         
            [_selectedAssets removeAllObjects];
            [_selectedPhotos removeAllObjects];
            [_selectedPhotos addObjectsFromArray:photos];
            [_selectedAssets addObjectsFromArray:tempArr];
          
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [UploadImageTool uploadImages:_selectedPhotos progress:nil success:^(NSArray *urlArr) {
                [_urlArr removeAllObjects];
               
                [_urlArr addObjectsFromArray:urlArr];
             
            } failure:^{
                [SVProgressHUD showWithStatus:@"上传解题步骤时,出现错误,请选择图片重新上传"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                });;
            }];
            _layout.itemCount = _selectedPhotos.count;
            [self.processCollectionView  reloadData];
            
            //            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [self.processCollectionView reloadData];
    }
}

#pragma mark Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    NSLog(@"%ld, %ld", sender.tag, _urlArr.count);
    if(sender.tag >= _urlArr.count){
        [SVProgressHUD showWithStatus:@"上传失败,请重新选择照片上传"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return;
        });
        
    }
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    if (!(_selectedAssets.count == 0)) {
        [_selectedAssets removeObjectAtIndex:sender.tag];
    }
    [_urlArr removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [self.processCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.processCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        NSLog(@"----%@, %@", _model.processImgArr, _model.processImgUrlArr);
        [self.processCollectionView reloadData];
    }];
}

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    
    // 设置支持最多照片数目
    int maxCount = 5;
    
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
    imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    
    // 不可以选择原图,太费流量
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    //    _selectedAssets = [NSMutableArray arrayWithArray:assets];
        NSLog(@"%@", photos);
 
    [_selectedAssets removeAllObjects];
    [_selectedPhotos removeAllObjects];
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
  
    
    [UploadImageTool uploadImages:_selectedPhotos progress:nil success:^(NSArray *urlArr) {
        [_urlArr removeAllObjects];
       
        [_urlArr addObjectsFromArray:urlArr];
        NSLog(@"+++%@, %@", _model.processImgArr, _model.processImgUrlArr);
    } failure:^{
        [SVProgressHUD showWithStatus:@"上传解题步骤时,出现错误,请选择图片重新上传"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });;
    }];
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [self.processCollectionView reloadData];
   

}

#pragma mark - 键盘的弹出和退下
// 键盘弹出
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSLog(@"%@", self.superview.superview);
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    NSLog(@"%@", NSStringFromCGSize(self.preSize));
    if(CGSizeEqualToSize(self.preSize, CGSizeZero)){
        self.preSize = CGSizeMake(0, height - 104);
        CGSize size = self.webView.scrollView.contentSize;
        size.height += self.preSize.height;
        
        self.webView.scrollView.contentSize = size;
        NSLog(@"%@, ++%@", NSStringFromCGSize(self.webView.scrollView.contentSize), NSStringFromCGRect(self.webView.frame));
    }
   
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.superview.superview.centerY = SCREEN_HEIGHT / 2 - 104;
        self.bgAnswerBottomConst.constant = height - 104;
    }];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.bgAnswerBottomConst.constant = 0;
    }];
    CGSize size = self.webView.scrollView.contentSize;
    size.height -= self.preSize.height;
    self.webView.scrollView.contentSize = size;
    NSLog(@"%@, --%@", NSStringFromCGSize(self.webView.scrollView.contentSize), NSStringFromCGRect(self.webView.frame));
   self.superview.superview.centerY = SCREEN_HEIGHT / 2 ;
    self.preSize = CGSizeZero;
}

@end
