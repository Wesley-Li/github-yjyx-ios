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
#import "YjyxWorkPreviewViewController.h"
#import "YjyxMicroClassViewController.h"

@interface YjyxOneSubjectViewController ()<SearchViewDelegate, WorkDetailCellDelegate>

@property (strong, nonatomic) NSMutableArray *allWorkArray;

@property (strong, nonatomic) NSNumber *lastid;

@property (strong, nonatomic) YjyxSearchView *searchV;

@property (strong, nonatomic) UIWindow *wds;

@property (strong, nonatomic) NSNumber *beginTime;
@property (strong, nonatomic) NSNumber *endTime;
@property (strong, nonatomic) NSNumber *workType;

@property (strong, nonatomic) NSNumber *hasmore;

@property (strong, nonatomic) NSIndexPath *selIndexPath;
@end

@implementation YjyxOneSubjectViewController
static NSString *ID = @"CELL";
#pragma mark - 懒加载
- (NSMutableArray *)allWorkArray
{
    if(_allWorkArray == nil){
        _allWorkArray = [NSMutableArray array];
    }
    return _allWorkArray;
}
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
    [self allWorkArray];
    [self loadData];
    [self loadRightNavItem];
    [self loadRefresh];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    //  注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxWorkDetailCell class]) bundle:nil] forCellReuseIdentifier:ID];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    if(_jumpType == 1){
        NSLog(@"%ld", _selIndexPath.row);
        YjyxTodayWorkModel *model = self.allWorkArray[_selIndexPath.row];
        model.finished = @1;
        _jumpType = 0;
        [self loadData];
        [self.tableView reloadRowsAtIndexPaths:@[_selIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
//    [self.view  makeToastActivity:SHOW_CENTER];
    [SVProgressHUD show];
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
        NSLog(@"%@", responseObject);
        [self.view hideToastActivity];
        if ([responseObject[@"retcode"] isEqual:@0]) {
            self.hasmore = responseObject[@"hasmore"];
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
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        [SVProgressHUD dismiss];
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
//    NSLog(@"%ld", _wds.subviews.count);
    
    if (self.wds.subviews.count == 0) {
        [self.navigationController.navigationBar addSubview:self.wds];
        [_wds addSubview:self.searchV];
        self.wds.height = SCREEN_HEIGHT - 64;
    }else{
        self.wds.hidden = YES;
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
    if([self.hasmore isEqual:@0]){
        self.tableView.footerRefreshingText = @"没有更多了";
    }
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allWorkArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YjyxWorkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.delegate = self;
    cell.OneSubjectModel = self.allWorkArray[indexPath.row];
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxTodayWorkModel *model = self.allWorkArray[indexPath.row];
    
    return model.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld", _selIndexPath.row);
    // 已完成
    YjyxTodayWorkModel *model = self.allWorkArray[indexPath.row];
    YjyxWorkDetailController *workDetailVc = [[YjyxWorkDetailController alloc] init];
    workDetailVc.title = model.task_description;
    workDetailVc.taskType = model.tasktype;
    workDetailVc.t_id = model.t_id;
    // 做普通作业
    YjyxWorkPreviewViewController *doingVc = [[YjyxWorkPreviewViewController alloc] init];
    doingVc.taskid = model.task_id;
    doingVc.examid = model.task_relatedresourceid;
    doingVc.title = model.task_description;
    // 做微课作业
    YjyxMicroClassViewController *microVc = [[YjyxMicroClassViewController alloc] init];
    microVc.taskid = model.task_id;
    microVc.lessonid = model.task_relatedresourceid;
    microVc.title = model.task_description;
    
    if ([model.finished isEqual:@1]) {
        NSLog(@"%@", self.subjectid);
        workDetailVc.subject_id = self.subjectid;
         [self.navigationController pushViewController:workDetailVc animated:YES];
    }else{
        self.selIndexPath = indexPath;
        if ([model.tasktype integerValue] == 1) {
            [self.navigationController pushViewController:doingVc animated:YES];
        }else{
            [self.navigationController pushViewController:microVc animated:YES];
        }
        
    }
}
#pragma mark - WorkDetailCellDelegate代理方法
- (void)workDetailCell:(YjyxWorkDetailCell *)cell doingBtnClicked:(UIButton *)btn
{
    self.selIndexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    NSLog(@"%ld", self.selIndexPath.row);
}
#pragma mark - SearchViewDelegate代理方法
- (void)searchView:(YjyxSearchView *)view searchBtnIsClickAndBeginTime:(NSNumber *)beginT endTime:(NSNumber *)endT andWorkType:(NSNumber *)workType
{
    self.beginTime = beginT;
    self.endTime = endT;
    self.workType = workType;
    self.lastid = @0;
    [self loadData];
    [self siftWithTime:nil];
    
}
@end
