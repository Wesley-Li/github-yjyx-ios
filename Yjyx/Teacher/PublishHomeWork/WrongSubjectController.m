//
//  WrongSubjectController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongSubjectController.h"
#import "WrongSubjectCell.h"
#import "YjyxWrongSubModel.h"
#import "OneSubjectController.h"
#import "WrongDataBase.h"
#import "QuestionDataBase.h"
#import "MJRefresh.h"
@interface WrongSubjectController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
// 错题数组
@property (strong, nonatomic) NSMutableArray *wrongSubjectArr;
@property (strong, nonatomic) NSMutableArray *questionArr;
// 返回数据的最大个数
@property (assign, nonatomic) NSInteger count;
// 判断还有没有数据
@property (assign, nonatomic) NSInteger index;
@end

@implementation WrongSubjectController
static NSString *ID = @"cell";
#pragma mark - 懒加载
- (NSMutableArray *)wrongSubjectArr
{
    if(_wrongSubjectArr == nil){
        _wrongSubjectArr = [NSMutableArray array];
    }
    return _wrongSubjectArr;
}
#pragma mark - view的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // 重写导航栏的返回按钮
    [self loadBackBtn];
    // 加载错题数据
    [self loadData];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WrongSubjectCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -49, 0);
    // 注册通知 接收添加按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnIsSelected) name:@"BUTTON_IS_SELEND" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnNoSelected) name:@"BUTTON_NO_SELEND" object:nil];

    // 集成下拉刷新控件
    [self loadRefresh];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    
    // 底部button标题赋值
    NSMutableArray *tempArr = [[WrongDataBase shareDataBase] selectAllQuestion];
    NSMutableArray *currentArr = [[QuestionDataBase shareDataBase] selectAllQuestion];
    _questionArr = currentArr;
    self.selectedBtn.titleLabel.text = [NSString stringWithFormat:@"点击预览作业(已选%ld题)", tempArr.count + _questionArr.count] ;
    [self.selectedBtn setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", tempArr.count + currentArr.count] forState:UIControlStateNormal];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
#pragma mark - 私有方法
- (void)loadRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
- (void)loadMoreData
{
     _index -= 20;
    if(_index < 0){
        [self.tableView footerEndRefreshing];
        return;
    }
    if (_index >= 20) {
        _count += 20;
    }else{
        _count = _index + _count;
    }
    [self.tableView footerEndRefreshing];
}
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_get_most_failed_questions";
    [mgr GET:[BaseURL stringByAppendingString:SEARCH_WRONG_CONNET_GET] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if([responseObject[@"retcode"] isEqual:@0]){
//            [responseObject[@"retlist"] writeToFile:@"/Users/wangdapeng/Desktop/文件/9.plist" atomically:YES];
            NSArray *tempArr = responseObject[@"retlist"];
            for (NSDictionary *dict in tempArr) {
                YjyxWrongSubModel *model = [YjyxWrongSubModel wrongSubjectModelWithDict:dict];
                [self.wrongSubjectArr addObject:model];
            }
            _index = _wrongSubjectArr.count;
            if(_wrongSubjectArr.count < 20){
                _count = _wrongSubjectArr.count;
                
            }else{
                _count = 20;
            }
            [self.tableView  reloadData];
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
    }];
}
- (void)btnIsSelected
{
    NSMutableArray *tempArr = [[WrongDataBase shareDataBase] selectAllQuestion];
    self.selectedBtn.titleLabel.text = [NSString stringWithFormat:@"点击预览作业(已选%ld题)", tempArr.count + _questionArr.count] ;
    [self.selectedBtn setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", tempArr.count + _questionArr.count] forState:UIControlStateNormal];
}
- (void)btnNoSelected
{
    NSMutableArray *tempArr = [[WrongDataBase shareDataBase] selectAllQuestion];
    self.selectedBtn.titleLabel.text = [NSString stringWithFormat:@"点击预览作业(已选%ld题)", tempArr.count + _questionArr.count] ;
    [self.selectedBtn setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", tempArr.count + _questionArr.count] forState:UIControlStateNormal];
    
}
- (IBAction)selectedBtnClick:(id)sender {
}

#pragma mark - UITableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WrongSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YjyxWrongSubModel *model = self.wrongSubjectArr[indexPath.row];
    cell.wrongSubModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxWrongSubModel *model = self.wrongSubjectArr[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxWrongSubModel *model = self.wrongSubjectArr[indexPath.row];
    OneSubjectController *vc = [[OneSubjectController alloc] init];
    vc.wrongSubjectModel = model;
    NSString *str = @"choice";
    if (model.questiontype == 2) {
        str = @"blankfill";
    }
    vc.qtype = str;
    vc.w_id = [NSString stringWithFormat:@"%ld", model.questionid];
    vc.is_select = model.isSelected ? 1 : 0;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
