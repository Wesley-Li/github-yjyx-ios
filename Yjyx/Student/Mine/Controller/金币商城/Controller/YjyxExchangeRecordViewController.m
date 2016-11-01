//
//  YjyxExchangeRecordViewController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxExchangeRecordViewController.h"
#import "YjyxExchangeRecordCell.h"
#import "YjyxExchangeRecordModel.h"
#import "MJRefresh.h"
@interface YjyxExchangeRecordViewController ()

@property (strong, nonatomic) NSMutableArray *productRecordArr;
@property (strong, nonatomic) NSNumber *lastid;

@property (strong, nonatomic) NSMutableArray *tempArr;
@end

@implementation YjyxExchangeRecordViewController
static NSString *ID = @"cell";
- (NSMutableArray *)productRecordArr
{
    if (_productRecordArr == nil) {
        _productRecordArr = [NSMutableArray array];
    }
    return _productRecordArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.navigationItem.title = @"兑换记录";
//    self.tableView.rowHeight = 130;
    self.lastid = @0;
    [self loadData];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxExchangeRecordCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0 , 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    [self setupRefresh];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewDidDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---coninset %@",  NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSLog(@"---offset %@", NSStringFromCGPoint(self.tableView.contentOffset));
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"coninset %@",  NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSLog(@"offset %@", NSStringFromCGPoint(self.tableView.contentOffset));
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
    param[@"action"] = @"m_list_exchange_history";
    param[@"lastid"] = self.lastid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/exchange_withdraw/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] integerValue] == 0){
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"retlist"]) {
                [tempArr addObject:[YjyxExchangeRecordModel exchangeRecordModelWithDict:dict]];
            }
//            self.tempArr = tempArr;
//            if([self.lastid isEqual:@0]){
//                self.productRecordArr = tempArr;
//            }else{
                [self.productRecordArr addObjectsFromArray:tempArr];
//            }
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
        if(self.productRecordArr.count == 0){
            [SVProgressHUD showInfoWithStatus:@"暂没有兑换记录"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [self.tableView  reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
- (void)setupRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
//    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
-(void)loadNewData{
    self.lastid = @0;
    [self loadData];
}
- (void)loadMoreData
{
    if(self.tempArr.count == 0){
        self.tableView.footerRefreshingText = @"没有更多了";
        [self.tableView footerEndRefreshing];
        return;
    }
    self.lastid = [self.productRecordArr.lastObject p_id];
    [self loadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.productRecordArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YjyxExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    YjyxExchangeRecordModel *model = self.productRecordArr[indexPath.row];
    cell.recordModel = model;
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YjyxExchangeRecordModel *model = self.productRecordArr[indexPath.row];
//    return model.cellHeight;
    return 120;
}

@end
