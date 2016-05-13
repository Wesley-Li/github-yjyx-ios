//
//  StuTaskTableViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StuTaskTableViewController.h"
#import "TaskListTableViewCell.h"
#import "TaskModel.h"
#import "TaskDetailTableViewController.h"
#import "MJRefresh.h"


#define kk @"Task"
@interface StuTaskTableViewController ()
@property (nonatomic, strong) NSNumber *direction;//0,1
@property (nonatomic, strong) NSNumber *last_id;
@property (nonatomic, strong) NSNumber *hasmore;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation StuTaskTableViewController

- (NSMutableArray *)dataSource {

    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.direction = @1;
    self.last_id = @0;
    // 配置导航栏
    self.title = @"学生作业";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self readDataFromNetWork];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskListTableViewCell" bundle:nil]forCellReuseIdentifier:kk];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 网络请求
- (void)readDataFromNetWork {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getstudenttasks", @"action", @"20", @"count", self.direction, @"direction", self.last_id, @"last_id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:T_SESSIONID forHTTPHeaderField:@"sessionid"];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_GET_ALL_TASKLIST_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"%@", responseObject);
        
//        if (responseObject[@"retcode"] == 0) {
            self.hasmore = responseObject[@"hasmore"];
            for (NSDictionary *dic in responseObject[@"tasks"]) {
                TaskModel *model = [[TaskModel alloc] init];
                [model initTaskModelWithDic:dic];
                [self.dataSource addObject:model];
            }
        
        [self.tableView reloadData];
//        }else {
        
//            [self.view makeToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] duration:1.0 position:SHOW_CENTER complete:nil];
//        }
//        NSLog(@"%@", self.dataSource);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kk forIndexPath:indexPath];
    TaskModel *model = self.dataSource[indexPath.row];
    
    NSLog(@"%@", model);
    
    [cell setValueWithTaskModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TaskDetailTableViewController *taskDetailVC = [[TaskDetailTableViewController alloc] init];
    taskDetailVC.taskModel = self.dataSource[indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
   
    [self.navigationController pushViewController:taskDetailVC animated:YES];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在帮你刷新中...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在帮你加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    NSMutableArray *cids = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[YjyxOverallData sharedInstance].parentInfo.childrens count]; i++) {
        ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:childrenEntity.cid forKey:@"id"];
        [dic setObject:@"0" forKey:@"last_id"];
        [cids addObject:dic];
    }
    [self getnewChildrenActivityWihtCid:[cids JSONString]];
    
}

- (void)footerRereshing
{
    NSMutableArray *cids = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[YjyxOverallData sharedInstance].parentInfo.childrens count]; i++) {
        ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:childrenEntity.cid forKey:@"id"];
        [dic setObject:last_id forKey:@"last_id"];
        [cids addObject:dic];
    }
    [self getoldChildrenActivityWihtCid:[cids JSONString]];
    
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
