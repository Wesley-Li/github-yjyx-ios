//
//  YjyxOneSubjectViewController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxOneSubjectViewController.h"
#import "YjyxTodayWorkModel.h"
#import "YjyxWorkDetailCell.h"
#import "MJRefresh.h"
#import "YjyxSearchView.h"
#import "YjyxWorkDetailController.h"
@interface YjyxOneSubjectViewController ()<SearchViewDelegate>

@property (strong, nonatomic) NSMutableArray *allWorkArray;

@property (strong, nonatomic) NSNumber *lastid;

@property (strong, nonatomic) YjyxSearchView *searchV;

@property (strong, nonatomic) UIWindow *wds;

@property (strong, nonatomic) NSNumber *beginTime;
@property (strong, nonatomic) NSNumber *endTime;
@property (strong, nonatomic) NSNumber *workType;
@end

@implementation YjyxOneSubjectViewController
static NSString *ID = @"CELL";
#pragma mark - 懒加载
- (YjyxSearchView *)searchV
{
    if (_searchV == nil) {
        YjyxSearchView *searchV = [YjyxSearchView searchView];
        searchV.delegate = self;
        _searchV = searchV;
        searchV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    }
    return _searchV;
}
- (UIWindow *)wds
{
    if (_wds == nil) {
         UIWindow *wds = [[UIWindow alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44) ];
         _wds = wds;
        _wds.backgroundColor = [UIColor clearColor];
       
        _wds.windowLevel = UIWindowLevelStatusBar;
//        [self.navigationController.navigationBar addSubview:_wds];
    }
    return _wds;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastid = @0;
    [self loadBackBtn];
    self.title = self.navTitle;
    [self loadData];
    [self loadRightNavItem];
    [self loadRefresh];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //  注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxWorkDetailCell class]) bundle:nil] forCellReuseIdentifier:ID];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.wds.height = 0;
    [self.searchV removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  私有方法
// 请求数据
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"list_tasks_to_me";
    param[@"lastid"] = self.lastid;
    param[@"subjectid"] = self.subjectid;
    param[@"finished"] = self.workType;
    param[@"createtimebefore"] = self.endTime;
    param[@"createtimeafter"] = self.beginTime;
    NSLog(@"%@, %@, %@", self.workType, self.beginTime, self.endTime);
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"retlist"]) {
                [tempArr addObject:[YjyxTodayWorkModel todayWorkModelWithDict:dict]];
            }
            if ([self.lastid isEqual:@0]) {
                self.allWorkArray = tempArr;
            }else{
                [self.allWorkArray addObjectsFromArray:tempArr];
            }
            if(self.allWorkArray.count == 0){
                [SVProgressHUD showInfoWithStatus:@"暂无作业..."];
            }
            [self.tableView reloadData];
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
- (void)loadRightNavItem
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(siftWithTime:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}
- (void)siftWithTime:(UIButton *)searchBtn
{
    
    self.wds.hidden = NO;
    NSLog(@"%ld", _wds.subviews.count);
    if (self.wds.subviews.count == 0) {
        [self.navigationController.navigationBar addSubview:self.wds];
        [_wds addSubview:self.searchV];
        self.wds.height = SCREEN_HEIGHT - 64;
    }else{
        
        [self.searchV removeFromSuperview];
        self.wds.height = 0;
    }

}
- (void)loadRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadOldData)];
}
- (void)loadNewData
{
    self.lastid = @0;
    [self loadData];
}
- (void)loadOldData
{
    YjyxTodayWorkModel *model = self.allWorkArray.lastObject;
    self.lastid = model.t_id;
    [self loadData];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allWorkArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YjyxWorkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.OneSubjectModel = self.allWorkArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxTodayWorkModel *model = self.allWorkArray[indexPath.row];
    YjyxWorkDetailController *workDetailVc = [[YjyxWorkDetailController alloc] init];
    workDetailVc.t_title = model.task_description;
    workDetailVc.t_id = model.t_id;
    [self.navigationController pushViewController:workDetailVc animated:YES];
    
}
#pragma mark - SearchViewDelegate代理方法
- (void)searchView:(YjyxSearchView *)view searchBtnIsClickAndBeginTime:(NSNumber *)beginT endTime:(NSNumber *)endT andWorkType:(NSNumber *)workType
{
    self.beginTime = beginT;
    self.endTime = endT;
    self.workType = workType;
    [self siftWithTime:nil];
    [self loadData];
}
@end
