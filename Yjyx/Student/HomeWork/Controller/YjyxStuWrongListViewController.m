//
//  YjyxStuWrongListViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuWrongListViewController.h"
#import "YjyxStuWrongListModel.h"
#import "YjyxStuWrongListCell.h"

#import "MJRefresh.h"


#import "ChildrenVideoViewController.h"
#import "YjyxMemberDetailViewController.h"
#import "ProductEntity.h"

#define ID @"YjyxStuWrongListCell"
@interface YjyxStuWrongListViewController ()


@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *heightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillExpandDic;
@property (nonatomic, strong) NSArray *tempArr;// 截取临时入参数组
@property (strong, nonatomic) ProductEntity *entity;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger count;


@end

@implementation YjyxStuWrongListViewController

- (NSMutableArray *)dataSource {
 
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.heightDic = [NSMutableDictionary dictionary];
    self.blankfillExpandDic = [NSMutableDictionary dictionary];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // 注册加载完成高度的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableviewCellHeight:) name:@"WEBVIEW_HEIGHT" object:nil];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxStuWrongListCell class]) bundle:nil] forCellReuseIdentifier:ID ];
    // 上拉加载
    [self loadRefresh];
}

- (void)loadRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (void)loadMoreData
{
    NSLog(@"********%ld", self.index);
    if (self.index == [[self.targetlist JSONValue] count] - 1) {
        self.tableView.footerRefreshingText = @"没有更多了";
        [self.tableView footerEndRefreshing];
    }else if([[self.targetlist JSONValue] count] - 1 - self.index < 20) {
        self.count = [[self.targetlist JSONValue] count] - 1 - self.index;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.index, self.count)];
        self.tempArr = [[self.targetlist JSONValue] objectsAtIndexes:indexSet];
        [self getDataFromNet];
    }else {
    
        self.count = 20;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.index, self.count)];
        self.tempArr = [[self.targetlist JSONValue] objectsAtIndexes:indexSet];
        [self getDataFromNet];

    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.index = 0;
    self.count = 20;
    if ([[self.targetlist JSONValue] count] - self.index < 20) {
        self.count = [[self.targetlist JSONValue] count] - self.index;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.index, self.count)];
    self.tempArr = [[self.targetlist JSONValue] objectsAtIndexes:indexSet];

    if(_openMember == 1){
        
        [self getDataFromNet];
        
    }else {
    
        [self getDataFromNet];
    }
    
    
}

- (void)refreshTableviewCellHeight:(NSNotification *)sender {

    YjyxStuWrongListCell *cell = [sender object];
    
    if (![self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
    {
        [self.heightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
    }

 
    
}


- (void)getDataFromNet {
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getonesubjectfailedquestion", @"action", self.subjectid, @"subjectid", [self.tempArr JSONString], @"targetlist", nil];
    NSLog(@"%@", param);
    [manager GET:[BaseURL stringByAppendingString:STUDENT_GET_WRONG_LIST_GET] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            NSLog(@"======%ld", [responseObject[@"data"] count]);
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                YjyxStuWrongListModel *model = [[YjyxStuWrongListModel alloc] init];
                [model initModelWithDic:dic];
                [self.dataSource addObject:model];
            }

            self.dataSource = (NSMutableArray *)[[self.dataSource reverseObjectEnumerator] allObjects];
            NSLog(@"----%@", self.dataSource);
            self.index = self.dataSource.count - 1;
            if (self.index == [[self.targetlist JSONValue] count] - 1) {
                self.tableView.footerRefreshingText = @"没有更多了";
            }
            

        }else {
        
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
       [self.tableView reloadData];
       [self.tableView footerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"%@", error.localizedDescription);

        [self.view makeToast:@"数据请求失败,请检查您的网络" duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    
    if (height == 0) {
        
        return 300;
        
    }else {
        
        return height;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YjyxStuWrongListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    
    if (!cell.solutionBtn.hidden) {
        [cell.solutionBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell.expandBtn addTarget:self action:@selector(changeCellHeight:) forControlEvents:UIControlEventTouchUpInside];
    cell.expandBtn.selected = [[self.blankfillExpandDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue];
    
    NSString *expand = [self.blankfillExpandDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    
    if (expand == nil) {
        cell.expandBtn.selected = NO;
    }else {
        cell.expandBtn.selected = [expand boolValue];
    }
    if (_dataSource.count) {
        
        YjyxStuWrongListModel *model = self.dataSource[indexPath.row];
        
        [cell setSubviewsWithModel:model];

    }
    
    return cell;
}

- (void)changeCellHeight:(UIButton *)sender {
    
    YjyxStuWrongListCell *cell = (YjyxStuWrongListCell *)sender.superview.superview.superview;
    cell.expandBtn.selected = !cell.expandBtn.selected;
    
    if (cell.expandBtn.selected == YES) {
        [self.blankfillExpandDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
    }else {
        [self.blankfillExpandDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)playVideo:(UIButton *)sender {

    YjyxStuWrongListCell *cell = (YjyxStuWrongListCell *)sender.superview.superview.superview;
    YjyxStuWrongListModel *model = self.dataSource[cell.tag];
    NSLog(@"%@,%@", model.videoUrl, model.explanation);
    if (model.videoUrl == nil && model.explanation == nil) {
        [self getMemberInfo];
        // 非会员
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"查看解题方法需要会员权限，是否前往试用或成为会员?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 跳转至会员页面
            YjyxMemberDetailViewController *vc = [[YjyxMemberDetailViewController alloc] init];
            vc.productEntity = self.entity;
            vc.jumpType = 1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }else {
        ChildrenVideoViewController *vc = [[ChildrenVideoViewController alloc] init];
        vc.URLString = model.videoUrl;
        vc.explantionStr = model.explanation;
        vc.title = @"详解";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
// 获取会员信息
- (void)getMemberInfo
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"getonememproductinfo";
    param[@"subjectid"] = self.subjectid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/mobile/m_product/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] integerValue] == 0) {
            ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:responseObject];
            self.entity = entity;
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
