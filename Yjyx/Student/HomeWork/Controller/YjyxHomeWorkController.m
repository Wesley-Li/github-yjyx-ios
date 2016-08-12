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

#import "YjyxHomeAdModel.h"
#import "YjyxHomeAdCell.h"
#import "YjyxHomeAdController.h"
@interface YjyxHomeWorkController ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *clickBtn;

@property (weak, nonatomic) IBOutlet UIButton *homeWorkBtn;
@property (strong, nonatomic) UIButton *preBtn;

@property (weak, nonatomic) UIScrollView *scrollV;
@property (weak, nonatomic) UITableView *workTableV;
@property (weak, nonatomic) UITableView *wrongWorkTableV;
@property (weak, nonatomic) IBOutlet UIView *btnView;

// 公告
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (strong, nonatomic) NSMutableArray *homeAdArray;
@property (weak, nonatomic) IBOutlet UIPageControl *AdNumPageControl;
@property (weak, nonatomic) NSTimer *timer;


@property (strong, nonatomic) NSMutableArray *wrongArr; //  错题榜数据
@end

@implementation YjyxHomeWorkController
static NSString *WORKID = @"workID";
static NSString *DETAILID = @"detailID";
static NSString *HomeADID = @"HomeADID";
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
- (NSMutableArray *)homeAdArray
{
    if (_homeAdArray == nil) {
        _homeAdArray = [NSMutableArray array];
    }
    return _homeAdArray;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"作业";
    self.preBtn = _homeWorkBtn;
    self.view.backgroundColor = COMMONCOLOR;
    [self setupCollectionView];
    [self addSubviews];
    [self workData];
    [self loadAdData];
  
    [self wrongWorkData];

    // 注册cell
    [self.workTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeWorkCell class]) bundle:nil] forCellReuseIdentifier:WORKID];
    [self.workTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxWorkDetailCell class]) bundle:nil] forCellReuseIdentifier:DETAILID];
    [self.wrongWorkTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeWorkCell class]) bundle:nil] forCellReuseIdentifier:WORKID];
    
    // 注册公告cell
    [self.collectView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeAdCell class]) bundle:nil] forCellWithReuseIdentifier:HomeADID];
    
//    self.workTableV.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);


}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"subview1%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));
    self.workTableV.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollV.height);
    self.wrongWorkTableV.frame  = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollV.height);
    NSLog(@"subview2%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));
    
}
- (void)viewWillAppear:(BOOL)animated
{
    // 自动刷新
    [self.workTableV headerBeginRefreshing];
    self.navigationController.navigationBarHidden = NO;
    NSLog(@"will%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));
    if(self.homeAdArray.count != 0){
        self.timer = nil;
        self.AdNumPageControl.currentPage = 0;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.collectView.contentOffset = CGPointMake(50 * self.homeAdArray.count * SCREEN_WIDTH, 0);
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"did%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
// 加载刷新控件
- (void)loadRefresh
{
    [self.workTableV addHeaderWithTarget:self action:@selector(workData)];
    [self.wrongWorkTableV addHeaderWithTarget:self action:@selector(wrongWorkData)];
    
}
// 请求公告数据
- (void)loadAdData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"get_my_notice";
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/yj_notice/" ] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] integerValue] == 0) {
            for (NSDictionary *dict in responseObject[@"retlist"]) {
                YjyxHomeAdModel *model = [YjyxHomeAdModel homeAdModelWithDict:dict];
                [self.homeAdArray addObject:model];
            }
            [self.collectView reloadData];
            self.AdNumPageControl.numberOfPages = self.homeAdArray.count;
            self.AdNumPageControl.currentPage = 0;
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
            self.timer = timer;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            self.collectView.contentOffset = CGPointMake(50 * self.homeAdArray.count * SCREEN_WIDTH, 0);
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}
//  自动滚动
- (void)autoScroll
{
    NSInteger index = self.collectView.contentOffset.x / SCREEN_WIDTH;
//    NSLog(@"%ld", index);
    
    if(index > self.homeAdArray.count * 99){
        index = -1;
    }
    [self.collectView setContentOffset:CGPointMake((index + 1) * SCREEN_WIDTH, 0) animated:YES];
    self.AdNumPageControl.currentPage = ((index + 1) % self.homeAdArray.count);
    
}
// 初始化collectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectView.collectionViewLayout = layout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 160);
   
    self.collectView.pagingEnabled = YES;
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.backgroundColor = [UIColor grayColor];
    
}
- (void)addSubviews
{
    // 添加scrollView
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.autoresizingMask = 0;
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
//        NSLog(@"%@", responseObject);
//        NSLog(@"%@", responseObject[@"retlist"][0][@"name"]);
        if([responseObject[@"retcode"] isEqual:@0]){
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"retlist"]) {
            YjyxHomeDataModel *model = [YjyxHomeDataModel homeDataModelWithDict:dict];
            [tempArr addObject:model];

        }
        [self loadRefresh];
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
            cell.tag = indexPath.section;
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
                YjyxHomeDataModel *model = self.subjectTypeArr[indexPath.section];
                workDetailVc.subject_id = model.s_id;
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
        if(model.failedquestions.count == 0){
            return;
        }
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
        if([scrollView isEqual:self.collectView]){
//            NSLog(@"%f", scrollView.contentOffset.x);
            
            NSInteger index = (scrollView.contentOffset.x ) / SCREEN_WIDTH;
//            NSLog(@"%ld", index);
            self.AdNumPageControl.currentPage = index % self.homeAdArray.count;
        }
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
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if([scrollView isEqual:self.collectView]){
//        NSLog(@"%f", scrollView.contentOffset.x);
//        
//       NSInteger index = (scrollView.contentOffset.x + SCREEN_WIDTH / 2) / SCREEN_WIDTH;
//        NSLog(@"%ld", index);
//        self.AdNumPageControl.currentPage = index % 2;
//    }
//}
#pragma mark - collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeAdArray.count * 100;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxHomeAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeADID forIndexPath:indexPath];
    cell.model = self.homeAdArray[indexPath.row % self.homeAdArray.count];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxHomeAdModel *model = self.homeAdArray[indexPath.row % self.homeAdArray.count];
    if (![model.detail_page isEqual:[NSNull null]]) {
        YjyxHomeAdController *vc = [[YjyxHomeAdController alloc] init];
        vc.page_detail = model.detail_page;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
