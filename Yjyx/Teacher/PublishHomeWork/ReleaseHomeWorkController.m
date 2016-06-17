//
//  ReleaseHomeWorkController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseHomeWorkController.h"
#import "StuDataBase.h"
#import "PostStudentCell.h"
#import "StuClassEntity.h"

#import "StudentEntity.h"
@interface ReleaseHomeWorkController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *homeWorkNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 获取班级信息
@property (strong, nonatomic) NSMutableArray *classArr;
// 保存所有学生信息
@property (strong, nonatomic) NSMutableArray *stuArr;
// 保存班级里的学生信息
@property (strong, nonatomic) NSMutableArray *classStuArr;
@end

@implementation ReleaseHomeWorkController
static NSString *ID = @"CELL";
#pragma mark - 懒加载
- (NSMutableArray *)classArr
{
    if (_classArr == nil) {
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
#pragma mark - view的生命属性
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classArr = [[StuDataBase shareStuDataBase] selectAllClass];
    for (StuClassEntity *stuClassModel in self.classArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuClassModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            [self.stuArr addObject:stuModel];
            [tempArr addObject:stuModel];
        }
        [self.classStuArr addObject:tempArr];
    }
   
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PostStudentCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClicked:) name:@"FirstCellClicked" object:nil];
    self.tableView.bounces = NO;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)cellClicked:(NSNotification *)noti{
    UIButton *sender = noti.userInfo[@"BtnIsSelect"];
    NSIndexPath *indexpath = noti.userInfo[@"ClickIsSection"];
    for (StudentEntity *stuModel in self.classStuArr[indexpath.section]) {
       
        stuModel.isSelect = sender.isSelected;
    }
    [self.tableView reloadData];
}
#pragma mark - UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.classStuArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    StuClassEntity *stuClassModel = self.classArr[section];
    if (stuClassModel.isExpanded) {
        return [self.classArr[section] memberlist].count + 1;
    }else{
    return 1;
    }
}
- (PostStudentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostStudentCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    StuClassEntity *stuClassModel = self.classArr[indexPath.section];
    if (indexPath.row == 0) {
        cell.stuClassModel = stuClassModel;
    }else{

        StudentEntity *stuModel = self.stuArr[indexPath.row - 1];
        NSLog(@"%@,%zd",stuModel, stuModel.isSelect);
        cell.studentModel = stuModel;
    }
    cell.backgroundColor = COMMONCOLOR;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StuClassEntity *stuClassModel = self.classArr[indexPath.section];
    if (indexPath.row == 0) {
         stuClassModel.isExpanded = !stuClassModel.isExpanded;
        
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (NSInteger i = 0;i < stuClassModel.memberlist.count ; i++) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
        }
        if (stuClassModel.isExpanded) {
          
            [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
- (IBAction)goSure:(UIButton *)sender {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (StudentEntity *stuModel in self.stuArr) {
        if(stuModel.isSelect == YES){
            [tempArr addObject:stuModel];
            NSLog(@"%@", stuModel.realname);
        }
    }
    [SVProgressHUD showWithStatus:@"正在发布..."];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"asign_exam_task";
    pamar[@"questionlist"] = @"";
    NSMutableArray *pamarArr = [NSMutableArray array];
    for (StudentEntity *stuModel in tempArr) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:stuModel.user_id];
        [arr addObject:stuModel.realname];
        [pamarArr addObject:arr];
    }
    NSLog(@"%@", pamarArr);
    pamar[@"recipients"] = pamarArr;
    pamar[@"name"] = self.homeWorkNameTextField.text;
    pamar[@"desc"] = self.descriptionTextField.text;
    pamar[@"suggestspendtime"] = self.timeTextField.text;
    [mgr POST:[BaseURL stringByAppendingString:TEACHER_RELEASE_CONNECT_POST] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if([responseObject[@"retcode"] isEqual:@0]){
            [SVProgressHUD showWithStatus:@"发布成功"];
        }else{
            [SVProgressHUD showWithStatus:@"发布失败"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}
@end
