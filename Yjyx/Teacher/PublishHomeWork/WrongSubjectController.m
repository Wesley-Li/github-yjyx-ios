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
@interface WrongSubjectController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (strong, nonatomic) NSMutableArray *wrongSubjectArr;
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
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WrongSubjectCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -49, 0);
    
}
- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 私有方法
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
            [self.tableView  reloadData];
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (IBAction)selectedBtnClick:(id)sender {
}

#pragma mark - UITableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wrongSubjectArr.count;
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
@end
