//
//  GetTaskViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "GetTaskViewController.h"
#import "GetTaskModel.h"
#import "GetTaskCell.h"
#import "MJRefresh.h"
#import "StudentDetailController.h"


#define ID @"GetTaskCell"
@interface GetTaskViewController ()

@property (nonatomic, strong) NSNumber *lastID;
@property (nonatomic, strong) NSNumber *hasmore;
@property (nonatomic, strong) NSMutableArray *dataSouece;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation GetTaskViewController

- (NSMutableArray *)dataSouece {

    if (!_dataSouece) {
        self.dataSouece = [NSMutableArray array];
    }
    return _dataSouece;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.lastID = @0;
    
    [self readDataFromNet];
    [self refreshAll];
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([GetTaskCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.backgroundColor = COMMONCOLOR;
}

// 刷新
- (void)refreshAll {
    
    // 头部刷新
    [self.tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    // 尾部加载
    [self.tableview addFooterWithTarget:self action:@selector(footerRefresh)];
}

// 刷新头部
- (void)headerRefresh {
    
    self.lastID = @0;
    [self readDataFromNet];
    
}

// 尾部加载
- (void)footerRefresh {
    
    GetTaskModel *model = self.dataSouece.lastObject;
    self.lastID = model.taskid;
    
    if ([self.hasmore isEqual:@0]) {
        self.tableview.footerRefreshingText = @"没有更多了!!!";
    }
    
    [self readDataFromNet];
    
}


- (void)readDataFromNet {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *trailString;
    
    if (self.tip == 0) {
        trailString = @"finishedonly";
    }else {
    
        trailString = @"unfinishedonly";
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettasksforonestudent", @"action", self.stuID, @"suid", self.lastID, @"lastid",trailString, trailString,nil];
    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_SEND_STATISTIC_GET] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *currentArr = [NSMutableArray array];
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            NSLog(@"-----%@", responseObject);
            self.hasmore = responseObject[@"hasmore"];
            for (NSDictionary *dic in responseObject[@"retlist"]) {
                GetTaskModel *model = [[GetTaskModel alloc] init];
                [model initModelWithDic:dic];
                [currentArr addObject:model];

            }
            
            if ([self.lastID isEqual:@0]) {
                [self.dataSouece removeAllObjects];
                [self.dataSouece addObjectsFromArray:currentArr];
                [self.tableview headerEndRefreshing];
            }else {
             
                [self.dataSouece addObjectsFromArray:currentArr];
                [self.tableview footerEndRefreshing];
            }
            
            [self.tableview reloadData];
        }else {
            
            [self.view makeToast:responseObject[@"reason"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.view makeToast:[NSString stringWithFormat:@"数据请求失败, 请检查您的网络"] duration:1.0 position:SHOW_CENTER complete:nil];
        
    }];
    
    
}

#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSouece.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 70;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GetTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    GetTaskModel *model = self.dataSouece[indexPath.row];
    [cell setValueWithModel:model andtip:self.tip];
    
    if (self.tip == 1) {
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    StudentDetailController *stuVC = [[StudentDetailController alloc] init];
    GetTaskModel *model = self.dataSouece[indexPath.row];
    stuVC.taskID = model.taskid;
    stuVC.studentID = self.stuID;
    stuVC.titleName =  [NSString stringWithFormat:@"%@-%@", self.navigationItem.title, model.descriptionText];
    [self.navigationController pushViewController:stuVC animated:YES];
    
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
