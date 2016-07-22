//
//  YjyxShopDisplayController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxShopDisplayController.h"
#import "YjyxShopDetailCell.h"
#import "YjyxTeacherShopModel.h"
#import "YjyxOneShopDetailController.h"
#import "YjyxExchangeRecordViewController.h"
@interface YjyxShopDisplayController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;

@property (strong, nonatomic) NSMutableArray *allProductArr; // 保存所有商品的数组
@property (weak, nonatomic) IBOutlet UILabel *myCoinLabel;
@end

@implementation YjyxShopDisplayController
 static NSString *ID = @"CELL";
- (NSMutableArray *)allProductArr
{
    if(_allProductArr == nil){
        _allProductArr = [NSMutableArray array];
    }
    return _allProductArr;
}
#pragma mark - view的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.navigationItem.title = @"金币商城";
    
    self.convertBtn.layer.borderColor = RGBACOLOR(66.0, 66.0, 66.0, 1).CGColor;
    self.convertBtn.layer.borderWidth = 1;
    self.convertBtn.layer.cornerRadius = 3;
    
    // 请求数据
    [self loadData];
   // 初始化collectionView
    [self setupCollectionView];
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxShopDetailCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(14.0, 115.0, 221.0, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.myCoinLabel.text = [YjyxOverallData sharedInstance].teacherInfo.coins;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"list_effective_goods_types";
   NSLog(@"%@", [BaseURL stringByAppendingString:[NSString stringWithFormat:@"%@?action=%@", @"/api/teacher/exchange_withdraw/", @"list_effective_goods_types"]]);
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/exchange_withdraw/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        for (NSDictionary *dict in responseObject[@"retlist"]) {
            YjyxTeacherShopModel *model = [YjyxTeacherShopModel teacherShopModelWithDict:dict];
            [self.allProductArr addObject:model];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    CGFloat itemW = (SCREEN_WIDTH - 1) / 2;
    layout.itemSize = CGSizeMake(itemW, 155);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    self.collectionView.backgroundColor = COMMONCOLOR;
}
// 获取更多积分方法的点击
- (IBAction)receivedMoreScoreBtnClick:(UIButton *)sender {
    
}
// 兑换记录按钮的点击
- (IBAction)convertBtnClick:(UIButton *)sender {
    YjyxExchangeRecordViewController *vc = [[YjyxExchangeRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDataSource数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allProductArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxShopDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    YjyxTeacherShopModel *model = self.allProductArr[indexPath.row];
    cell.productModel = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxTeacherShopModel *model = self.allProductArr[indexPath.row];
    YjyxOneShopDetailController *VC = [[YjyxOneShopDetailController alloc] init];
    VC.oneShopModel = model;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
