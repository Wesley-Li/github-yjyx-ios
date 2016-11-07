//
//  MyMicroMainController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MyMicroMainController.h"
#import "MicroDetailViewController.h"
#import "MyMicroCell.h"
#import "MyMicroModel.h"
#import "ReleaseMicroController.h"
#import "MJRefresh.h"
@interface MyMicroMainController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MicroDetailViewControllerDelegate>

{
    BOOL isSearch;// 搜索
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 我的微课数组
@property (strong, nonatomic) NSMutableArray *myMicroArr;
// 搜索数组
@property (strong, nonatomic) NSMutableArray *seacherArr;

@property (strong, nonatomic) MyMicroModel *model;
@property (strong, nonatomic) NSNumber *last_id;
@property (copy, nonatomic) NSString *searchkeyword;// 搜索关键词
@end

@implementation MyMicroMainController
static NSString *ID = @"CELL";
#pragma mark - 懒加载
- (NSMutableArray *)myMicroArr
{
    if (_myMicroArr == nil) {
        _myMicroArr = [NSMutableArray array];
    }
    return _myMicroArr;
}

- (NSMutableArray *)seacherArr
{
    if (_seacherArr == nil) {
        _seacherArr = [NSMutableArray array];
    }
    return _seacherArr;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.title = @"我的微课";
    self.last_id = @0;
    // UISearch的属性
    self.searchBar.placeholder = @"输入关键字如\"公式 方程\"";;
    self.searchBar.delegate = self;
    [self loadData];
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    [self.tableView  registerNib:[UINib nibWithNibName:NSStringFromClass([MyMicroCell class]) bundle:nil] forCellReuseIdentifier:ID];
    // 设置tableview的属性
    self.tableView.backgroundColor = COMMONCOLOR;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 55;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseBtnClick:) name:@"ReleaseBtnClick" object:nil];
    
    [self loadRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(14.0, 115.0, 221.0, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    [super viewWillDisappear:animated];
}
#pragma mark - 私有方法
- (void)loadRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
- (void)loadNewData
{
    self.last_id = @0;
    [self loadData];
}
- (void)loadMoreData
{
    MyMicroModel *model = self.myMicroArr.lastObject;
    self.last_id = model.m_id;
    [self loadData];
}
- (void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_search";
    param[@"lastid"] = self.last_id;
    if (self.searchkeyword != nil) {
        param[@"searchkeyword"] = self.searchkeyword;
    }
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/yj_lessons/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if([responseObject[@"retcode"] isEqual:@0]){
            NSMutableArray *currentArr = [NSMutableArray array];
            for (NSArray *tempArr in responseObject[@"retlist"]) {
                [currentArr addObject:[MyMicroModel myMicroModelWithArr:tempArr]];
            }
            if ([_last_id isEqual:@0]) {
                self.myMicroArr = currentArr;
            }else{
                [self.myMicroArr addObjectsFromArray:currentArr];
            }
            
            if (isSearch) {
                if (self.myMicroArr.count == 0) {
                    UIView *view = [[UIView alloc] init];
                    view.height = 100;
                    UILabel *label = [[UILabel alloc] init];
                    label.text = @"无搜索结果";
                    [label sizeToFit];
                    
                    label.centerX = self.view.centerX;
                    label.centerY = view.centerY;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    [view addSubview:label];
                    self.tableView.tableHeaderView = view;
                }else {
                
                    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
                }
            }
            
            [self.tableView reloadData];
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [SVProgressHUD dismiss];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
- (void)microDetailViewController:(MicroDetailViewController *)VC andName:(NSString *)name
{
    _model.name = name;
    [self.tableView reloadData];
}
- (void)releaseBtnClick:(NSNotification *)noti
{
    MyMicroModel *model = noti.userInfo[@"model"];
    ReleaseMicroController *vc = [[ReleaseMicroController alloc] init];
    vc.w_id = model.m_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableView数据源放
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_seacherArr != nil) {
        return self.seacherArr.count;
    }else{
    return self.myMicroArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMicroCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.microModel = self.myMicroArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    MyMicroModel *model = self.myMicroArr[indexPath.row];
    _model = model;
    MicroDetailViewController *microDetailVc = [[MicroDetailViewController alloc] init];
    microDetailVc.delegate = self;
    microDetailVc.m_id = model.m_id;
    [self.navigationController pushViewController:microDetailVc animated:YES];
    
}
#pragma mark - UISearchBar的代理方法

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
    self.searchkeyword = searchText;
    isSearch = YES;
    self.last_id = @0;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    
  
}
@end
