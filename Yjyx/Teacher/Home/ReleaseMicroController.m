//
//  ReleaseMicroController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseMicroController.h"
#import "StuDataBase.h"
#import "ReleaseStudentCell.h"
#import "ReleaseDescrpitionCell.h"
#import "ReleaseFinishTimeCell.h"
#import "StuClassEntity.h"
#import "StudentEntity.h"
@interface ReleaseMicroController ()<UITableViewDelegate, UITableViewDataSource, ReleaseStudentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *classArr;

// 保存所有学生信息
@property (strong, nonatomic) NSMutableArray *stuArr;
// 保存班级里的学生信息
@property (strong, nonatomic) NSMutableArray *classStuArr;

// 任务描述
@property (copy, nonatomic) NSString *descripStr;
@property (copy, nonatomic) NSString *timeStr;
@end

@implementation ReleaseMicroController
static NSString *DescID = @"DescriptionCell";
static NSString *FinishTimeID = @"FinishTimeCell";
static NSString *StudentID = @"StudentCell";
#pragma mark - 懒加载
- (NSMutableArray *)classArr
{
    if(_classArr == nil){
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}
- (NSMutableArray *)stuArr
{
    if (_stuArr == nil) {
        _stuArr = [NSMutableArray array];
    }
    return _stuArr;
}

- (NSMutableArray *)classStuArr
{
    if (_classStuArr == nil) {
        _classStuArr = [NSMutableArray array];
    }
    return _classStuArr;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"发布微课";
    
    for (StuClassEntity *stuClassModel in self.classArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuClassModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            [self.stuArr addObject:stuModel];
            [tempArr addObject:stuModel];
        }
        [self.classStuArr addObject:tempArr];
    }
    [self loadBackBtn];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseDescrpitionCell class]) bundle:nil] forCellReuseIdentifier:DescID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseFinishTimeCell class]) bundle:nil] forCellReuseIdentifier:FinishTimeID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseStudentCell class]) bundle:nil] forCellReuseIdentifier:StudentID];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.rowHeight = 55;
    
    // 设置footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footerView.backgroundColor = COMMONCOLOR;
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtn.backgroundColor = RGBACOLOR(0, 128.0, 255.0, 1);
    releaseBtn.width = SCREEN_WIDTH - 20;
    releaseBtn.height = 49;
    releaseBtn.centerX = footerView.centerX;
    releaseBtn.centerY = footerView.height / 2;
    releaseBtn.layer.cornerRadius = 5;
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    releaseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [releaseBtn addTarget:self action:@selector(releaseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [releaseBtn setTintColor:[UIColor whiteColor]];
    [footerView addSubview:releaseBtn];
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
- (void)loadData
{
    self.classArr = [[StuDataBase shareStuDataBase] selectAllClass];
}
- (void)releaseBtnClicked
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (StudentEntity *stuModel in self.stuArr) {
        if(stuModel.isSelect == YES){
            [tempArr addObject:stuModel];
            NSLog(@"%@", stuModel.realname);
        }
    }
    // 学生列表
    NSMutableArray *pamarArr = [NSMutableArray array];
    for (StudentEntity *stuModel in tempArr) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:stuModel.user_id];
        [arr addObject:stuModel.realname];
        [pamarArr addObject:arr];
    }
    if(pamarArr.count == 0){
        [self.view makeToast:@"请勾选需要发布的学生" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"add_task";
    NSLog(@"%@", [pamarArr JSONString]);
    param[@"recipients"] = [pamarArr JSONString];
    param[@"tasktype"] = @"lesson";
    param[@"lessonid"] = self.w_id;
    param[@"desc"] = self.descripStr;
    param[@"suggestspendtime"] = [self.timeStr isEqualToString:@""] ? @"30" : self.timeStr;

    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    [mgr POST:[BaseURL stringByAppendingString:@"/api/teacher/mobile/general_task/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject[@"reason"]);
        if([responseObject[@"retcode"] isEqual:@0]){
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showSuccessWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
   
    }];
}
#pragma mark - UITableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.classArr.count + 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == self.classArr.count || section == self.classArr.count + 1){
        return 1;
    }else{
        StuClassEntity *classEntity = self.classArr[section];
        if (classEntity.isExpanded) {
            return classEntity.memberlist.count + 1;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.classArr.count ){
        ReleaseFinishTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:FinishTimeID];
        self.timeStr = cell.timeLabel.text;
        return cell;
    }else if(indexPath.section == self.classArr.count + 1){
        ReleaseDescrpitionCell *cell = [tableView dequeueReusableCellWithIdentifier:DescID];
        self.descripStr = cell.descriptionTextField.text;
        return cell;
    }else{
        ReleaseStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:StudentID];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.classEntity = _classArr[indexPath.section];
            
        }else{
        
            NSMutableArray *arr =  self.classStuArr[indexPath.section];
            StudentEntity *stuModel =  arr[indexPath.row - 1];
            cell.stuEntity = stuModel;
        }
 
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 0 && indexPath.section < self.classArr.count) {
       StuClassEntity *classEntity = self.classArr[indexPath.section];
        classEntity.isExpanded = !classEntity.isExpanded;
        if (classEntity.isExpanded) {
            NSMutableArray *tempArr = [NSMutableArray array];
            NSInteger i = 1;
            for (NSNumber *num in classEntity.memberlist) {
                [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
            }
            [self.tableView insertRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationNone];
        }else{
            NSMutableArray *tempArr = [NSMutableArray array];
            NSInteger i = 1;
            for (NSNumber *num in classEntity.memberlist) {
                [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
            }
            [self.tableView deleteRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mrak - ReleaseStudentCell代理方法
- (void)releaseStudentCell:(ReleaseStudentCell *)cell allBtnSelectedClicked:(UIButton *)btn
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
        NSMutableArray *tempArr = self.classStuArr[indexpath.section];
        for (NSInteger i = 0; i < tempArr.count; i++) {
            StudentEntity *stuModel = tempArr[i];
            stuModel.isSelect = btn.isSelected;
        }
        
        [self.tableView reloadData];
  
}

@end
