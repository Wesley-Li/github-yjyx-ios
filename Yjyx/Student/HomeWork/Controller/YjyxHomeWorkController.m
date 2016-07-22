//
//  YjyxHomeWorkController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeWorkController.h"
#import "Masonry.h"
#import "YjyxHomeDataModel.h"
#import "YjyxHomeWorkCell.h"
#import "YjyxWorkDetailCell.h"
#import "YjyxTodayWorkModel.h"
#import "MJRefresh.h"
#import "YjyxHomeWrongModel.h"
#import "YjyxOneSubjectViewController.h"
#import "YjyxStuWrongListViewController.h"
#import "YjyxWorkDetailController.h"
#import "YjyxWorkPreviewViewController.h"
#import "YjyxMicroClassViewController.h"
@interface YjyxHomeWorkController ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *clickBtn;

@property (weak, nonatomic) IBOutlet UIButton *homeWorkBtn;
@property (strong, nonatomic) UIButton *preBtn;

@property (weak, nonatomic) UIScrollView *scrollV;
@property (weak, nonatomic) UITableView *workTableV;
@property (weak, nonatomic) UITableView *wrongWorkTableV;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (strong, nonatomic) NSMutableArray *subjectTypeArr; // 科目类型数组

@property (strong, nonatomic) NSMutableArray *wrongArr; //  错题榜数据
@end

@implementation YjyxHomeWorkController
static NSString *WORKID = @"workID";
static NSString *DETAILID = @"detailID";
#pragma mark - 懒加载

- (NSMutableArray *)subjectTypeArr
{
    if(_subjectTypeArr == nil){
        _subjectTypeArr = [NSMutableArray array];
    }
    return _subjectTypeArr;
}
- (NSMutableArray *)wrongArr
{
    if(_wrongArr == nil){
        _wrongArr = [NSMutableArray array];
    }
    return _wrongArr;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"作业";
    self.preBtn = _homeWorkBtn;
    self.view.backgroundColor = COMMONCOLOR;
    [self addSubviews];
    [self workData];
    [self wrongWorkData];
    [self loadRefresh];
    // 注册cell
    [self.workTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeWorkCell class]) bundle:nil] forCellReuseIdentifier:WORKID];
    [self.workTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxWorkDetailCell class]) bundle:nil] forCellReuseIdentifier:DETAILID];
    [self.wrongWorkTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeWorkCell class]) bundle:nil] forCellReuseIdentifier:WORKID];


}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.workTableV.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollV.height);
    self.wrongWorkTableV.frame  = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollV.height);
}
- (void)viewWillAppear:(BOOL)animated
{
    // 自动刷新
//    [self.workTableV headerBeginRefreshing];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
- (void)loadRefresh
{
    [self.workTableV addHeaderWithTarget:self action:@selector(workData)];
    [self.wrongWorkTableV addHeaderWithTarget:self action:@selector(wrongWorkData)];
    
}
- (void)addSubviews
{
    // 添加scrollView
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    self.scrollV = scrollV;
    [self.view addSubview:scrollV];
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-49);
        make.top.equalTo(self.homeWorkBtn.mas_bottom).with.offset(2);
    }];
    // 设置scrollView属性
    scrollV.backgroundColor = [UIColor redColor];
    scrollV.alwaysBounceVertical = NO;
    scrollV.pagingEnabled = YES;
    scrollV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, scrollV.height);
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.delegate = self;
    scrollV.bounces = NO;
    // 添加作业tableView
    UITableView *workTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollV.height) style:UITableViewStylePlain];
    
    self.workTableV = workTableV;
//    self.workTableV.backgroundColor = [UIColor lightGrayColor];
    workTableV.delegate = self;
    workTableV.dataSource = self;
    [self.scrollV addSubview:workTableV];
    self.workTableV.tableFooterView = [[UIView alloc] init];
    // 添加错题榜的tableview
    UITableView *wrongWorkTableV = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollV.height) style:UITableViewStylePlain];
//    self.wrongWorkTableV.backgroundColor = [UIColor lightGrayColor];
    self.wrongWorkTableV = wrongWorkTableV;
    wrongWorkTableV.delegate = self;
    wrongWorkTableV.dataSource = self;
    [self.scrollV addSubview:wrongWorkTableV];
    self.wrongWorkTableV.tableFooterView = [[UIView alloc] init];
}
// 作业列表的数据请求
- (void)workData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_gettaskhomepagedata";
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
//        NSLog(@"%@", responseObject[@"retlist"][0][@"name"]);
        if([responseObject[@"retcode"] isEqual:@0]){
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"retlist"]) {
            YjyxHomeDataModel *model = [YjyxHomeDataModel homeDataModelWithDict:dict];
            [tempArr addObject:model];

        }
        self.subjectTypeArr = tempArr;
        [self.workTableV reloadData];
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
        [self.workTableV headerEndRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
         [self.workTableV headerEndRefreshing];
    }];
}
// 错题榜的数据请求
- (void)wrongWorkData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"getfailedquestionhomepagedata";
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/stats/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] isEqual:@0]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [tempArr addObject:[YjyxHomeWrongModel homeWrongModelWithDict:dict]];
            }
            self.wrongArr = tempArr;
            [self.wrongWorkTableV reloadData];
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
        [self.wrongWorkTableV headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        [self.wrongWorkTableV headerEndRefreshing];
    }];
}
// 作业/错题榜按钮的点击
- (IBAction)workBtnClick:(UIButton *)sender {
   self.preBtn.selected = NO;
    sender.selected = YES;
    self.preBtn = sender;
    self.clickBtn.centerX = sender.centerX;
    [self scrollToViewWithClick:sender];
}

- (void)scrollToViewWithClick:(UIButton *)btn{
//    if(btn.tag == 2){
//        [self wrongWorkTableV];
//    }
    [self.scrollV setContentOffset:CGPointMake(SCREEN_WIDTH * (btn.tag - 1), 0) animated:YES];
    
}
#pragma mark - UITableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:_workTableV]){
    return self.subjectTypeArr.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_workTableV]) {
        YjyxHomeDataModel *model = self.subjectTypeArr[section];
//        NSLog(@"%ld", model.todaytasks.count + 1);
        return model.todaytasks.count + 1;
    }else{
//        NSLog(@"%ld", self.wrongArr.count);
    return self.wrongArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_workTableV]) {
        if (indexPath.row == 0) {
            YjyxHomeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:WORKID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.homeWorkModel = self.subjectTypeArr[indexPath.section];
       
            return cell;
        }else{
            YjyxWorkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DETAILID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
            YjyxHomeDataModel *homeDataM = self.subjectTypeArr[indexPath.section];
            YjyxTodayWorkModel *model = homeDataM.todaytasks[indexPath.row - 1];
            cell.todayWorkModel = model;
            return cell;
        }
    }else{
    
        YjyxHomeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:WORKID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.homeWrongModel = self.wrongArr[indexPath.row];
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.workTableV]){
    if(indexPath.row == 0){
        return 90;
    }else{
        return 65;
    }
    }else{
        return 80;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.workTableV]) { // 点中作业
        if(indexPath.row == 0){
            YjyxOneSubjectViewController *VC = [[YjyxOneSubjectViewController alloc] init];
            YjyxHomeDataModel *model = self.subjectTypeArr[indexPath.section];
            VC.navTitle = model.name;
            VC.subjectid = model.s_id;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            // 已完成
            YjyxHomeDataModel *homeDataM = self.subjectTypeArr[indexPath.section];
            YjyxTodayWorkModel *model = homeDataM.todaytasks[indexPath.row - 1];
            YjyxWorkDetailController *workDetailVc = [[YjyxWorkDetailController alloc] init];
            workDetailVc.title = model.task_description;
            workDetailVc.taskType = model.tasktype;
            workDetailVc.t_id = model.t_id;
            // 未完成之普通作业
            YjyxWorkPreviewViewController *doingVc = [[YjyxWorkPreviewViewController alloc] init];
            doingVc.taskid = model.task_id;
            doingVc.examid = model.task_relatedresourceid;
            doingVc.title = model.task_description;
            // 未完成之微课作业
            YjyxMicroClassViewController *microVc = [[YjyxMicroClassViewController alloc] init];
            microVc.taskid = model.task_id;
            microVc.lessonid = model.task_relatedresourceid;
            microVc.title = model.task_description;
            
            if ([model.finished isEqual:@1]) {
                [self.navigationController pushViewController:workDetailVc animated:YES];
            }else{
                if ([model.tasktype integerValue] == 1) {
                    [self.navigationController pushViewController:doingVc animated:YES];
                }else{
                    [self.navigationController pushViewController:microVc animated:YES];
                }
                
            }
        }

    }else{// 点击了错题榜
        YjyxHomeWrongModel *model = self.wrongArr[indexPath.row];
        
        YjyxStuWrongListViewController *vc = [[YjyxStuWrongListViewController alloc] init];
        vc.navigationItem.title = model.subjectname;
        vc.subjectid  = model.subjectid;
        vc.targetlist = [model.failedquestions JSONString];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark -ScrollView的代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.scrollV]) {
        return;
    }
    CGPoint offsetP = scrollView.contentOffset;
    NSInteger index = (offsetP.x + SCREEN_WIDTH * 0.5) / SCREEN_WIDTH;
//    NSLog(@"%ld", index);
    for (UIView *view in self.btnView.subviews) {
        if(view.tag == index + 1){
            [self workBtnClick:((UIButton *)view)];
            break;
        }
    }
}

@end
