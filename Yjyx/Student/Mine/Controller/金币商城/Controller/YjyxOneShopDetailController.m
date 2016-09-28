//
//  YjyxOneShopDetailController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxOneShopDetailController.h"
#import "YjyxTeacherShopModel.h"
#import "YjyxExchangeRecordViewController.h"
#import "YjyxExchangeRecordModel.h"
#import "YjyxConvertDetailController.h"
@interface YjyxOneShopDetailController ()<UIWebViewDelegate>

{
    NSInteger num;
}

@property (weak, nonatomic) IBOutlet UILabel *paperNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireCoinLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLabel;

@property (strong, nonatomic) NSMutableArray *convertGoodsArr;
@property (weak, nonatomic) IBOutlet UIButton *exchangBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIWebView *detail_webview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@property (weak, nonatomic) UILabel *promptLabel;

@end

@implementation YjyxOneShopDetailController

#pragma mark - 懒加载
- (NSMutableArray *)convertGoodsArr
{
    if (_convertGoodsArr == nil) {
        _convertGoodsArr = [NSMutableArray array];
    }
    return _convertGoodsArr;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    num = 1;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.paperNameLabel.text = self.oneShopModel.name;
    self.requireCoinLabel.text = [self.oneShopModel.exchange_coins stringValue];
    NSInteger coinNum = [[YjyxOverallData sharedInstance].teacherInfo.coins integerValue];
    self.exchangBtn.enabled = [self.requireCoinLabel.text integerValue] > coinNum ? NO : YES;
    [self.paperImageView setImageWithURL:[NSURL URLWithString:[self.oneShopModel.goods_display JSONValue][@"small_img_url"]] placeholderImage:[UIImage imageNamed:@"T_deafultPicture"]];
    if (![[self.oneShopModel.goods_display JSONValue][@"detail_url"] isEqual:[NSNull null]]) {
        NSURL *url = [NSURL URLWithString:[self.oneShopModel.goods_display JSONValue][@"detail_url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.detail_webview.scrollView.scrollEnabled = NO;
        [self.detail_webview loadRequest:request];

    }else {
    
        self.webviewHeight.constant = SCREEN_HEIGHT - self.detail_webview.frame.origin.y - 64;
        
    }
    //[self.oneShopModel.goods_display JSONValue][@"detail_url"]
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"金币商城";
  
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.exchangBtn.enabled == NO) {
        [self addMessageLabel];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
// 减少数量
- (IBAction)reduceNumBtnClick:(UIButton *)sender {
    if ([self.buyNumLabel.text integerValue] == 1) {
        return;
    }
    NSInteger num = [self.buyNumLabel.text integerValue];
    self.buyNumLabel.text = [NSString stringWithFormat:@"%ld", --num];
    NSInteger totalPrice = num * [_oneShopModel.exchange_coins integerValue];
    self.requireCoinLabel.text = [NSString stringWithFormat:@"%ld", totalPrice];
    NSInteger coinNum = [[YjyxOverallData sharedInstance].teacherInfo.coins integerValue];
    self.exchangBtn.enabled = [self.requireCoinLabel.text integerValue] >= coinNum ? NO : YES;
    self.promptLabel.hidden = [self.requireCoinLabel.text integerValue] >= coinNum ? NO : YES;
}
// 增加数量
- (IBAction)addNumBtnClick:(UIButton *)sender {
    NSInteger coinNum = [[YjyxOverallData sharedInstance].teacherInfo.coins integerValue];
    if([self.requireCoinLabel.text integerValue] > coinNum){
        [self addMessageLabel];
        return;
    }
    NSInteger num = [self.buyNumLabel.text integerValue];
    self.buyNumLabel.text = [NSString stringWithFormat:@"%ld", ++num];
    NSInteger totalPrice = num * [_oneShopModel.exchange_coins integerValue];
    self.requireCoinLabel.text = [NSString stringWithFormat:@"%ld", totalPrice];
    
    if ([self.requireCoinLabel.text integerValue] > coinNum) {
  
        [self addMessageLabel];
        self.exchangBtn.enabled = NO;
        return;
    }
}
// 添加提示余额不足的信息
- (void)addMessageLabel{
    [self.promptLabel removeFromSuperview];
    UILabel *label = [[UILabel alloc] init];
    self.promptLabel = label;
    [self.bgView addSubview:label];
    label.text = @"您账户金币不足";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGBACOLOR(255.0, 90.0, 18.0, 1);
    [label sizeToFit];
    label.centerX = self.exchangBtn.centerX;
    label.y = CGRectGetMaxY(self.exchangBtn.frame) + 5;
    NSLog(@"%@", NSStringFromCGRect(label.frame));
    label.alpha = 0;
    [UIView animateWithDuration:1.5 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        //            label.alpha = 0;
    }];
}
// 弹框提示是否确定兑换
- (IBAction)gosureExchangeBtnClick:(UIButton *)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"是否确定兑换?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self exchangProduct];
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}
// 发送兑换请求
- (void)exchangProduct
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"exchange";
    param[@"gtype"] = self.oneShopModel.p_id;
    param[@"quantity"] = @([self.buyNumLabel.text integerValue]);
    [self.view makeToastActivity:SHOW_CENTER];
   
    [mgr POST:[BaseURL stringByAppendingString:@"/api/teacher/mobile/exchange/" ] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        [self.view hideToastActivity];
        if ([responseObject[@"retcode"] integerValue] == 0) {
            [self.convertGoodsArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"retlist"]) {
                YjyxExchangeRecordModel *model = [YjyxExchangeRecordModel exchangeRecordModelWithDict:dict];
                if(![model.specific_info isEqual:[NSNull null]]){
                    [self.convertGoodsArr addObject:model];
                }
                
            }
            YjyxConvertDetailController *vc = [[YjyxConvertDetailController alloc] init];
            vc.convertShopArr = self.convertGoodsArr;
            
            [self.navigationController pushViewController:vc animated:YES];
//            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您的充值卡序列号: %@", responseObject[@"retlist"][0][@"specific_info"]] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//            [alertVc addAction:cancelAction];
//            [self presentViewController:alertVc animated:YES completion:nil];
            NSInteger coinNum = [[YjyxOverallData sharedInstance].teacherInfo.coins integerValue];
            NSInteger exchangeCoinNum = [self.requireCoinLabel.text integerValue];
            NSInteger coinsurNum = coinNum - exchangeCoinNum;
            [YjyxOverallData sharedInstance].teacherInfo.coins = [NSString stringWithFormat:@"%ld", (long)coinsurNum];
        }else if ([responseObject[@"retcode"] integerValue] == 1){
            [self.view makeToast:@"未知错误" duration:0.5 position:SHOW_CENTER complete:nil];
        }else if ([responseObject[@"retcode"] integerValue] == 3){
            [self.view makeToast:@"您的金币不足" duration:0.5 position:SHOW_CENTER complete:nil];
        }else if ([responseObject[@"retcode"] integerValue] == 4){
            [self.view makeToast:@"此商品库存不足" duration:0.5 position:SHOW_CENTER complete:nil];
        }else{
            [self.view makeToast:responseObject[@"reason"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    self.webviewHeight.constant = frame.size.height;
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.webviewHeight.constant + self.detail_webview.frame.origin.y);
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (num == 1) {
        num ++;
        return YES;
    }else {
    
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    
}


@end
