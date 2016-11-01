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
#import "YjyxDoingWorkController.h"
#import "YjyxHomeAdModel.h"
#import "YjyxHomeAdCell.h"
#import "YjyxHomeAdController.h"
@interface YjyxHomeWorkController ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIImageView *navBarHairlineImageView;
}
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

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (strong, nonatomic) NSMutableArray *wrongArr; //  错题榜数据
@property (strong, nonatomic) AFHTTPSessionManager *mgr;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stuPushSwitch) name:@"ChildActivityNotification" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"作业";
    self.preBtn = _homeWorkBtn;
    self.view.backgroundColor = COMMONCOLOR;
    [self setupCollectionView];
    [self addSubviews];
//    [self workData];
    [self loadAdData];
  
    [self wrongWorkData];
    

  
    // 注册cell
    [self.workTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeWorkCell class]) bundle:nil] forCellReuseIdentifier:WORKID];
    [self.workTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxWorkDetailCell class]) bundle:nil] forCellReuseIdentifier:DETAILID];
    [self.wrongWorkTableV registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeWorkCell class]) bundle:nil] forCellReuseIdentifier:WORKID];
    
    // 注册公告cell
    [self.collectView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxHomeAdCell class]) bundle:nil] forCellWithReuseIdentifier:HomeADID];
    
    if (((AppDelegate *)SYS_DELEGATE).isComeFromNoti == YES) {
        [self getRemote];
    }
    
//    self.workTableV.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //再定义一个imageview来等同于这个黑线
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
    [super viewWillAppear:animated];
    
    // 自动刷新
    [self loadAdData];
    
    self.navigationController.navigationBarHidden = NO;
    NSLog(@"will%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));
    
    if(self.homeAdArray.count != 1 && self.homeAdArray.count != 0 && self.timer == nil){
        self.timer = nil;
        self.AdNumPageControl.currentPage = 0;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.collectView.contentOffset = CGPointMake(50 * self.homeAdArray.count * SCREEN_WIDTH, 0);
    }
    navBarHairlineImageView.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self workData];
    self.workTableV.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    NSLog(@"did%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));

    
}
- (void)viewWillDisappear:(BOOL)animated
{
//    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
//    [self.workTableV headerEndRefreshing];
    navBarHairlineImageView.hidden = NO;
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
    [super viewDidDisappear:animated];
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
    self.mgr = mgr;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"get_my_notice";
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/yj_notice/" ] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] integerValue] == 0) {
            [self.homeAdArray removeAllObjects];
            for (NSDictionary *dict in responseObject[@"retlist"]) {
                YjyxHomeAdModel *model = [YjyxHomeAdModel homeAdModelWithDict:dict];
                [self.homeAdArray addObject:model];
            }
            if (self.homeAdArray.count == 0) {
                self.bgImageView.hidden = NO;
            }else{
                self.bgImageView.hidden = YES;
            }
            [self.collectView reloadData];
            self.AdNumPageControl.numberOfPages = self.homeAdArray.count;
            self.AdNumPageControl.currentPage = 0;
            if(self.homeAdArray.count != 1 && self.homeAdArray.count != 0 && self.timer == nil){
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
            self.timer = timer;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }
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
    
    if(index > self.homeAdArray.count * 99 - 1){
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
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 169);
   
    self.collectView.pagingEnabled = YES;
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.backgroundColor = COMMONCOLOR;
    
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
    UITableView *workTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollV.height) style:UITableViewStyleGrouped];
    
    self.workTableV = workTableV;
    
//    self.workTableV.backgroundColor = [UIColor lightGrayColor];
    workTableV.delegate = self;
    workTableV.dataSource = self;
    [self.scrollV addSubview:workTableV];
    self.workTableV.tableFooterView = [[UIView alloc] init];
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    headV.backgroundColor = [UIColor whiteColor];
    self.workTableV.tableHeaderView = headV;
    self.workTableV.sectionHeaderHeight = 0;
    self.workTableV.sectionFooterHeight = 0;
   
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
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.workTableV headerEndRefreshing];
            
//            NSLog(@"---%@",  NSStringFromUIEdgeInsets(self.workTableV.contentInset));
//        });
        
        NSLog(@"++++%@", NSStringFromUIEdgeInsets(self.workTableV.contentInset));
        if(self.workTableV.contentInset.top < -1){
            self.workTableV.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
        }
        
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
//            [cell setContentWithModel:model];
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
            YjyxHomeDataModel *homeDataM = self.subjectTypeArr[indexPath.section];
            YjyxTodayWorkModel *model = homeDataM.todaytasks[indexPath.row - 1];
            return model.height;
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
            YjyxDoingWorkController *doingVc = [[YjyxDoingWorkController alloc] init];
            doingVc.desc = model.resourcename;
            doingVc.workTitle = model.task_description;
            doingVc.taskid = model.task_id;
            doingVc.examid = model.task_relatedresourceid;
            doingVc.type = @1;
            // 未完成之微课作业
            YjyxMicroClassViewController *microVc = [[YjyxMicroClassViewController alloc] init];
            microVc.workDesc = model.task_description;
            microVc.taskid = model.task_id;
            microVc.lessonid = model.task_relatedresourceid;
            microVc.title = model.resourcename;
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:self.workTableV]){
        if(self.subjectTypeArr.count - 1 == section){
            return 0;
        }else{
            return 10;
        }
    }else{
        return 0;
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
    NSLog(@"%@", model.detail_page);
    if (![model.detail_page isEqual:[NSNull null]] && ![model.detail_page isEqualToString:@""] && model.detail_page != nil) {
        YjyxHomeAdController *vc = [[YjyxHomeAdController alloc] init];
        vc.page_detail = model.detail_page;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


// 获取远程推送消息
- (void)getRemote {

     NSDictionary *userInfo = ((AppDelegate *)SYS_DELEGATE).remoteNoti;
    if ([userInfo[@"type"] isEqualToString:@"newtask"]) {// 新作业
        
        if ([userInfo[@"tasktype"] integerValue] ==1) {
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
        }else{
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
        }
        [YjyxOverallData sharedInstance].taskid = userInfo[@"taskid"];
        [YjyxOverallData sharedInstance].examid = userInfo[@"rid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildActivityNotification" object:nil];
        
    }else if ([userInfo[@"type"] isEqualToString:@"hastentask"]) {
        
        if ([userInfo[@"tasktype"] integerValue] ==1) {
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEWHOME;
        }else{
            [YjyxOverallData sharedInstance].pushType = PUSHTYPE_PREVIEMICRO;
        }
        [YjyxOverallData sharedInstance].taskid = userInfo[@"taskid"];
        [YjyxOverallData sharedInstance].examid = userInfo[@"rid"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildActivityNotification" object:nil];
        
        
    }

}


// 响应推送消息
-(void)stuPushSwitch {
    ((AppDelegate *)SYS_DELEGATE).isComeFromNoti = nil;
        switch ([YjyxOverallData sharedInstance].pushType) {
            case 1:{
                YjyxWorkPreviewViewController *result = [[YjyxWorkPreviewViewController alloc] init];
                result.taskid = [YjyxOverallData sharedInstance].taskid;
                result.examid = [YjyxOverallData sharedInstance].examid;
                result.navigationItem.title = @"预览作业";
                [result setHidesBottomBarWhenPushed:YES];
                [((AppDelegate *)SYS_DELEGATE).tabBarVc.selectedViewController pushViewController:result animated:YES];
                [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
            }
                
                break;
                
            case 2:{
                YjyxMicroClassViewController *result = [[YjyxMicroClassViewController alloc] init];
                result.taskid = [YjyxOverallData sharedInstance].taskid;
                result.lessonid = [YjyxOverallData sharedInstance].examid;
                result.navigationItem.title = @"预览作业";
                [result setHidesBottomBarWhenPushed:YES];
                [((AppDelegate *)SYS_DELEGATE).tabBarVc.selectedViewController pushViewController:result animated:YES];
                [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
            }
                break;
                
                
            default:
                break;
        }

    
}


@end
