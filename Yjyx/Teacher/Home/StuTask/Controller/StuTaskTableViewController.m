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
#import "TeacherHomeViewController.h"



#define kk @"Task"
@interface StuTaskTableViewController ()
@property (nonatomic, strong) NSNumber *direction;//0,1
@property (nonatomic, strong) NSNumber *last_id;
@property (nonatomic, strong) NSNumber *hasmore;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat cellHeight;


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
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.direction = @1;
    self.last_id = @0;
    // 配置导航栏
    self.title = @"学生作业";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    
    [self readDataFromNetWork];
    [self refreshAll];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskListTableViewCell" bundle:nil]forCellReuseIdentifier:kk];
    
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 刷新
- (void)refreshAll {

    // 头部刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    // 尾部加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

// 刷新头部
- (void)headerRefresh {

    self.direction = @1;
    self.last_id = @0;
    [self readDataFromNetWork];
}

// 尾部加载
- (void)footerRefresh {

    TaskModel *model = self.dataSource.lastObject;
    self.direction = @0;
    self.last_id = model.t_id;
    
    if ([self.hasmore isEqual:@0]) {
        self.tableView.footerRefreshingText = @"没有更多了!!!";
//        [self.tableView setFooterHidden:YES];
    }
    
    [self readDataFromNetWork];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//
//{
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset) );
//}
// 网络请求
- (void)readDataFromNetWork {
    
    [SVProgressHUD showWithStatus:@"正在拼命加载数据"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getstudenttasks", @"action", @"10", @"count", self.direction, @"direction", self.last_id, @"last_id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_GET_ALL_TASKLIST_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        // 创建临时数组
        NSMutableArray *currentArr = [NSMutableArray array];
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            self.hasmore = responseObject[@"hasmore"];
            for (NSDictionary *dic in responseObject[@"tasks"]) {
                TaskModel *model = [[TaskModel alloc] init];
                [model initTaskModelWithDic:dic];
                [currentArr addObject:model];
            }
            
            // 判断刷新还是加载
            if ([self.direction isEqual:@1] && [self.last_id isEqual:@0]) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:currentArr];
                [self.tableView headerEndRefreshing];
            }else {
            
                [self.dataSource addObjectsFromArray:currentArr];
                [self.tableView footerEndRefreshing];
                
                
            }
        
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            [SVProgressHUD dismissWithDelay:0.8];

        }else {
        
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:0.8];

        }
//        NSLog(@"%@", self.dataSource);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
        [self.tableView headerEndRefreshing];
    }];
    
}

- (void)goBack {

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kk forIndexPath:indexPath];
    TaskModel *model = self.dataSource[indexPath.row];
    
//    NSLog(@"%@", model);
    
    [cell setValueWithTaskModel:model];
    
//    self.cellHeight = cell.height;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    TaskModel *model = self.dataSource[indexPath.row];
    
    
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TaskDetailTableViewController *taskDetailVC = [[TaskDetailTableViewController alloc] init];
    taskDetailVC.taskModel = self.dataSource[indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
   
    [self.navigationController pushViewController:taskDetailVC animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
