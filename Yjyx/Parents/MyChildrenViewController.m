//
//  MyChildrenViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MyChildrenViewController.h"
#import "ChildrenActivity.h"
#import "MyChildrenTableViewCell.h"
#import "CommonWebViewController.h"
#import "MJRefresh.h"
#import "ChildrenResultViewController.h"
#import "YjyxWorkPreviewViewController.h"
#import "YjyxMicroClassViewController.h"
#import "AddChildrenViewController.h"

@interface MyChildrenViewController ()<UIAlertViewDelegate>
{
    ChildrenEntity *currentChildren;//当前选择小孩，默认第一个
    NSString *last_id;
}

@end

@implementation MyChildrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    last_id = @"0";
    segmentedIndex = 0;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    totalAry = [[NSMutableArray alloc] init];
    _activities = [[NSMutableArray alloc] init];
    _childrenAry = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"孩子动态";
    [self loadBackBtn];
    
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;//将跳转页面标志置为空
    if ([YjyxOverallData sharedInstance].parentInfo.childrens.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先关联您的孩子" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"前往", nil];
        [alertView show];
        childrenViews.hidden = YES;
    }else{
        [self setChildrenViews];
        currentChildren = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:0];
    }
    // Do any additional setup after loading the view from its nib.
    
}

//设置小孩
-(void)setChildrenViews
{
    NSMutableArray *segemtedAry = [[NSMutableArray alloc] init];
    for (int i = 0; i < [YjyxOverallData sharedInstance].parentInfo.childrens.count; i++) {
        [segemtedAry addObject:@"1"];
    }
    segmentedControl = [[UISegmentedControl alloc] initWithItems:segemtedAry];
    segmentedControl.frame = CGRectMake(SCREEN_WIDTH/2-30*segemtedAry.count, 6, 60*segemtedAry.count, 30);
    for (int i =0; i< [[YjyxOverallData sharedInstance].parentInfo.childrens count]; i++) {
        ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
        [segmentedControl setTitle:childrenEntity.name forSegmentAtIndex:i];
        [_childrenAry addObject:childrenEntity];
    }
    segmentedControl.tintColor = RGBACOLOR(23, 155, 121, 1);
    [segmentedControl addTarget:self action:@selector(seltectChildren:) forControlEvents:UIControlEventValueChanged];
    if (_childrenAry.count <= 1) {
        childrenViews.hidden = YES;
        _childrenTab.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }else{
        [self.view addSubview:segmentedControl];
        _childrenTab.frame = CGRectMake(0, 46, SCREEN_WIDTH, SCREEN_HEIGHT - 110);
    }
    
    [self setupRefresh];//刷新空间
}


//获取最新小孩信息
-(void)getnewChildrenActivityWihtCid:(NSString *)cid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"20",@"count",@"1",@"direction", cid,@"cids", nil];
    [[YjxService sharedInstance] getchildrenActivity:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [_activities removeAllObjects];
                [totalAry removeAllObjects];
                for (int i = 0; i<[[result objectForKey:@"activities"] count]; i++) {
                    ChildrenActivity *children = [ChildrenActivity wrapChildrenActivityWithDic:[[result objectForKey:@"activities"] objectAtIndex:i]];
                    [_activities addObject:children];
                    [totalAry addObject:children];
                    if (i == [[result objectForKey:@"activities"] count] - 1) {
                        last_id = [NSString stringWithFormat:@"%@",children.activityID];
                    }
                }
                
                ChildrenEntity *childrenEntity = [_childrenAry objectAtIndex:segmentedIndex];
                [_activities removeAllObjects];
                for (ChildrenActivity *entity in totalAry) {
                    if ([entity.cid integerValue] == [childrenEntity.cid integerValue]) {
                        [_activities addObject:entity];
                    }
                }
                segmentedControl.selectedSegmentIndex = segmentedIndex;
                [_childrenTab reloadData];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [self.childrenTab headerEndRefreshing];
    }];
}

//获取老数据
-(void)getoldChildrenActivityWihtCid:(NSString *)cid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"20",@"count",@"0",@"direction", cid,@"cids", nil];
    [[YjxService sharedInstance] getchildrenActivity:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            [_activities removeAllObjects];
            [_activities addObjectsFromArray:totalAry];
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                for (int i = 0; i<[[result objectForKey:@"activities"] count]; i++) {
                    ChildrenActivity *children = [ChildrenActivity wrapChildrenActivityWithDic:[[result objectForKey:@"activities"] objectAtIndex:i]];
                    [_activities addObject:children];
                    [totalAry addObject:children];
                    if (i == [[result objectForKey:@"activities"] count] - 1) {
                        last_id = [NSString stringWithFormat:@"%@",children.activityID];
                    }
                }
                
                ChildrenEntity *childrenEntity = [_childrenAry objectAtIndex:segmentedIndex];
                [_activities removeAllObjects];
                for (ChildrenActivity *entity in totalAry) {
                    if ([entity.cid integerValue] == [childrenEntity.cid integerValue]) {
                        [_activities addObject:entity];
                    }
                }
                segmentedControl.selectedSegmentIndex = segmentedIndex;
                [_childrenTab reloadData];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [self.childrenTab footerEndRefreshing];
    }];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];

    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = NO;
  
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate&UITablviewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_activities count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ChildrenActivity *children = [_activities objectAtIndex:indexPath.row];
    return 63;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    MyChildrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyChildrenTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (_activities.count == 0) {
        return nil;
    }
    ChildrenActivity *children = [_activities objectAtIndex:indexPath.row];
    for (ChildrenEntity *entity in _childrenAry) {
        if ([children.cid integerValue] == [entity.cid integerValue]) {
            [cell.iconImage setImageWithURL:[NSURL URLWithString:entity.childavatar] placeholderImage:[UIImage imageNamed:@"Personal_children.png"]];
            break;
        }
    }
    cell.timelb.text = children.update;
    UILabel *titleLb = [UILabel labelWithFrame:CGRectMake(85, 23, SCREEN_WIDTH - 106 , 21) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:children.title];
    if ([children.finished integerValue] == 1) {
        titleLb.textColor =RGBACOLOR(119, 162, 150, 1);
        cell.finishedImage.hidden = NO;
    }else{
        titleLb.textColor =[UIColor blackColor];
        cell.finishedImage.hidden = YES;
    }
    titleLb.numberOfLines = 0;
    [cell.contentView addSubview:titleLb];
    [titleLb sizeToFit];
    

    if ([children.tasktype integerValue] == 1) {
        [cell.typeImage setImage:[UIImage imageNamed:@"Parent_homework.png"] forState:UIControlStateNormal];
    }else{
        [cell.typeImage setImage:[UIImage imageNamed:@"Parent_weike.png"] forState:UIControlStateNormal];
    }
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildrenActivity *children = [_activities objectAtIndex:indexPath.row];
    if ([children.finished integerValue] ==1) {
        ChildrenResultViewController *result = [[ChildrenResultViewController alloc] init];
        result.childrenCid = children.cid;
        result.taskResultId = children.activityID;
        result.navigationItem.title = [[children.title componentsSeparatedByString:@"|"] objectAtIndex:0];
        [self.navigationController pushViewController:result animated:YES];
    }
    
    
    if ([children.tasktype integerValue] == 1&&[children.finished integerValue] == 0) {//作业预览
        YjyxWorkPreviewViewController *result = [[YjyxWorkPreviewViewController alloc] init];
        result.previewRid = children.rid;
        result.navigationItem.title = children.title;
        [self.navigationController pushViewController:result animated:YES];
        
    }
    
    if ([children.tasktype integerValue] == 2&&[children.finished integerValue] == 0) {//微课预览
        YjyxMicroClassViewController *result = [[YjyxMicroClassViewController alloc] init];
        result.previewRid = children.rid;
        result.navigationItem.title = children.title;
        [self.navigationController pushViewController:result animated:YES];

    }
}

#pragma mark -MyEvent
-(void)seltectChildren:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    segmentedIndex = index;
    
    NSMutableArray *cids = [[NSMutableArray alloc] init];
    ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:segmentedIndex];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:childrenEntity.cid forKey:@"id"];
    [dic setObject:@"0" forKey:@"last_id"];
    [cids addObject:dic];
    [self getnewChildrenActivityWihtCid:[cids JSONString]];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.childrenTab addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.childrenTab headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.childrenTab addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.childrenTab.headerPullToRefreshText = @"下拉可以刷新了";
    self.childrenTab.headerReleaseToRefreshText = @"松开马上刷新了";
    self.childrenTab.headerRefreshingText = @"正在帮你刷新中...";
    
    self.childrenTab.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.childrenTab.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.childrenTab.footerRefreshingText = @"正在帮你加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
   
    NSMutableArray *cids = [[NSMutableArray alloc] init];
    ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:segmentedIndex];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:childrenEntity.cid forKey:@"id"];
    [dic setObject:@"0" forKey:@"last_id"];
    [cids addObject:dic];
    [self getnewChildrenActivityWihtCid:[cids JSONString]];
    
}

- (void)footerRereshing
{
    NSMutableArray *cids = [[NSMutableArray alloc] init];
    
    ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:segmentedIndex];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:childrenEntity.cid forKey:@"id"];
    [dic setObject:last_id forKey:@"last_id"];
    [cids addObject:dic];
    
    [self getoldChildrenActivityWihtCid:[cids JSONString]];

}

#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AddChildrenViewController *vc = [[AddChildrenViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
