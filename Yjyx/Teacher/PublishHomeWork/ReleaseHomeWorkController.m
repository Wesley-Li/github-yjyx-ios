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
#import "ChaperContentItem.h"
#import "QuestionDataBase.h"
#import "StuTaskTableViewController.h"
#import "YjyxWrongSubModel.h"
#import "StudentEntity.h"
#import "StuGroupEntity.h"
@interface ReleaseHomeWorkController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *homeWorkNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 题目列表
@property (nonatomic, strong) NSMutableArray *questionList;

// 获取班级信息
@property (strong, nonatomic) NSMutableArray *classArr;
// 获取群组信息
@property (strong, nonatomic) NSMutableArray *groupArr;
// 保存所有学生信息
@property (strong, nonatomic) NSMutableArray *stuArr;
// 保存班级里的学生信息
@property (strong, nonatomic) NSMutableArray *classStuArr;
// 保存群组里的学生信息
@property (strong, nonatomic) NSMutableArray *groupStuArr;
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
- (NSMutableArray *)groupStuArr
{
    if (_groupStuArr == nil) {
        _groupStuArr = [NSMutableArray array];
    }
    return _groupStuArr;
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
    self.groupArr = [[StuDataBase shareStuDataBase] selectAllGroup];
    self.navigationItem.title = @"发布作业";
    NSLog(@"%@", self.classArr);
    for (StuClassEntity *stuClassModel in self.classArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuClassModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            [self.stuArr addObject:stuModel];
            [tempArr addObject:stuModel];
        }
        [self.classStuArr addObject:tempArr];
    }
    for (StuGroupEntity *stuGroupModel in self.groupArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuGroupModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            [self.stuArr addObject:stuModel];
            [tempArr addObject:stuModel];
        }
        [self.groupStuArr addObject:tempArr];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PostStudentCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClicked:) name:@"FirstCellClicked" object:nil];
    self.tableView.bounces = NO;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    
     [_homeWorkNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [_descriptionTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)cellClicked:(NSNotification *)noti{
    UIButton *sender = noti.userInfo[@"BtnIsSelect"];
    NSIndexPath *indexpath = noti.userInfo[@"ClickIsSection"];
    NSLog(@"%zd, %zd", indexpath.section, indexpath.row);
    if (indexpath.section < _classArr.count) {
        StuClassEntity *classEntity = _classArr[indexpath.section];
        if (indexpath.row == 0) {
            classEntity.isSelect = !classEntity.isSelect;
            NSMutableArray *tempArr = self.classStuArr[indexpath.section];
            for (NSInteger i = 0; i < tempArr.count; i++) {
                StudentEntity *stuModel = tempArr[i];
                stuModel.isSelect = sender.isSelected;
            }
        }else{
           StudentEntity *studentModel = _classStuArr[indexpath.section][indexpath.row - 1];
            studentModel.isSelect = !studentModel.isSelect;
            if (sender.selected == NO) {
                classEntity.isSelect = NO;
            }
        }
    }else{
        StuGroupEntity *groupEntity = _groupArr[indexpath.section - _classArr.count];
        if (indexpath.row == 0) {
            groupEntity.isSelect = !groupEntity.isSelect;
            NSMutableArray *tempArr = self.groupStuArr[indexpath.section - _classArr.count];
            for (NSInteger i = 0; i < tempArr.count; i++) {
                StudentEntity *stuModel = tempArr[i];
                stuModel.isSelect = sender.isSelected;
            }
        }else{
            StudentEntity *studentModel = _groupStuArr[indexpath.section - _classArr.count][indexpath.row - 1];
            studentModel.isSelect = !studentModel.isSelect;
            if (sender.selected == NO) {
                groupEntity.isSelect = NO;
            }
        }
    }
  
        
  
    [self.tableView reloadData];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if([textField isEqual:_homeWorkNameTextField]){
            if (toBeString.length > 100) {
                [self.view makeToast:@"作业名称最多只能输入100个字" duration:1.0 position:SHOW_TOP complete:nil];
                textField.text = [toBeString substringToIndex:100];
            }
        }else if([textField isEqual:_descriptionTextField]){
            if (toBeString.length > 500) {
                [self.view makeToast:@"作业描述最多只能输入500个字" duration:1.0 position:SHOW_TOP complete:nil];
                    textField.text = [toBeString substringToIndex:500];
                }
        }
    }
        
  }
}

#pragma mark - UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.classStuArr.count + self.groupStuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section < self.classArr.count) {
        StuClassEntity *stuClassModel = self.classArr[section];
        if (stuClassModel.isExpanded) {
            return [self.classArr[section] memberlist].count + 1;
        }else{
            return 1;
        }
    }else{
        StuGroupEntity *stuGroupModel = self.groupArr[section - _classArr.count];
        if (stuGroupModel.isExpanded) {
            return [self.groupArr[section - _classArr.count] memberlist].count + 1;
        }else{
            return 1;
        }
    }
}

- (PostStudentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostStudentCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section < _classArr.count) {
        if (indexPath.row == 0) {
            StuClassEntity *stuClassModel = self.classArr[indexPath.section];
            cell.stuClassModel = stuClassModel;
        }else{
            NSMutableArray *arr =  self.classStuArr[indexPath.section];
            StudentEntity *stuModel =  arr[indexPath.row - 1];
            NSLog(@"%@,%zd",stuModel, stuModel.isSelect);
            cell.studentModel = stuModel;
            
        }
       
    }else {
        if (indexPath.row == 0) {
            StuGroupEntity *stuGroupModel = self.groupArr[indexPath.section - _classArr.count];
            cell.stuGroupModel = stuGroupModel;
        }else{
            NSMutableArray *arr =  self.groupStuArr[indexPath.section - _classArr.count];
            StudentEntity *stuModel =  arr[indexPath.row - 1];
            NSLog(@"%@,%zd",stuModel, stuModel.isSelect);
            cell.studentModel = stuModel;
        }
        
    }
    cell.backgroundColor = COMMONCOLOR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.classArr.count) {
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

    }else{
        StuGroupEntity *stuGroupModel = self.groupArr[indexPath.section - _classArr.count];
        if (indexPath.row == 0) {
            stuGroupModel.isExpanded = !stuGroupModel.isExpanded;
            
            NSMutableArray *indexPathArray = [NSMutableArray array];
            for (NSInteger i = 0;i < stuGroupModel.memberlist.count ; i++) {
                [indexPathArray addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
            }
            if (stuGroupModel.isExpanded) {
                
                [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (IBAction)goSure:(UIButton *)sender {
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *IDArr = [NSMutableArray array];
    for (StudentEntity *stuModel in self.stuArr) {
        if(stuModel.isSelect == YES){
            if(stuModel.user_id == nil){
                [SVProgressHUD showErrorWithStatus:@"发布失败"];
                return;
            }
            if(![IDArr containsObject:stuModel.user_id]){
            [tempArr addObject:stuModel];
            [IDArr addObject:stuModel.user_id];
            NSLog(@"%@", stuModel.realname);
            }
        }
    }
    NSString *nameStr = [self.homeWorkNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([nameStr isEqualToString:@""]) {
        [self.view makeToast:@"请输入作业名称" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    if (tempArr.count == 0) {
        [self.view makeToast:@"请勾选需要发布的学生" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在发布..."];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 入参
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"asign_exam_task";
    
    // 题目列表
    NSMutableArray *choiceArr = [NSMutableArray array];
    NSMutableArray *blankfillArr = [NSMutableArray array];
    for (ChaperContentItem *model in self.selectArr) {
        if ([model.subject_type isEqualToString:@"1"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:model.t_id], @"id", [NSNumber numberWithInteger:model.level], @"level", model.isRequireProcess == YES ? @1 : @0, @"requireprocess", nil];
            [choiceArr addObject:dic];
        }else if ([model.subject_type isEqualToString:@"2"]) {
        
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:model.t_id], @"id", [NSNumber numberWithInteger:model.level], @"level", model.isRequireProcess == YES ? @1 : @0, @"requireprocess", nil];
            [blankfillArr addObject:dic];

        }
    }
    // 没有对应的类型就不传
    if (choiceArr.count == 0 && blankfillArr.count != 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"blankfill", blankfillArr, nil];
        self.questionList = [NSMutableArray arrayWithObjects:arr, nil];
        
    }else if (choiceArr.count != 0 && blankfillArr.count == 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"choice", choiceArr, nil];
        self.questionList = [NSMutableArray arrayWithObjects:arr, nil];
    }else {
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"choice", choiceArr, nil];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"blankfill", blankfillArr, nil];
        self.questionList = [NSMutableArray arrayWithObjects: arr1, arr2, nil];
    
    }
    
    // 学生列表
    NSMutableArray *pamarArr = [NSMutableArray array];
    for (StudentEntity *stuModel in tempArr) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:stuModel.user_id];
        [arr addObject:stuModel.realname];
        [pamarArr addObject:arr];
    }

    pamar[@"recipients"] = [pamarArr JSONString];
    pamar[@"name"] = self.homeWorkNameTextField.text;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
    
    NSInteger seconds=[timeZone secondsFromGMTForDate:[NSDate date]];
    
    NSDate *newDate=[[NSDate date] dateByAddingTimeInterval:seconds];
    NSString *dateStr = [fmt stringFromDate:newDate];
    
    NSLog(@"%@--%@", [NSDate date], dateStr);
    NSString *descStr = [NSString stringWithFormat:@"%@ 作业", dateStr];
    NSString *descTempStr = [self.descriptionTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    pamar[@"desc"] = [descTempStr isEqualToString:@""] ? descStr : self.descriptionTextField.text;
    pamar[@"suggestspendtime"] = [self.timeTextField.text isEqualToString:@""] ? @"30" : self.timeTextField.text;
    pamar[@"questionlist"] = [self.questionList JSONString];

    NSLog(@"%@", pamar);
    
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    coverView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:coverView];
    [mgr POST:[BaseURL stringByAppendingString:TEACHER_RELEASE_CONNECT_POST] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject[@"msg"] );
        if([responseObject[@"retcode"] isEqual:@0]){
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [[QuestionDataBase shareDataBase] deleteQuestionTable];
            [SVProgressHUD dismissWithDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 跳转到学生作业列表
                StuTaskTableViewController *stuTaskVC = [[StuTaskTableViewController alloc] init];
                [self.navigationController pushViewController:stuTaskVC animated:YES];
            });
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [coverView removeFromSuperview];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [coverView removeFromSuperview];
    }];
}




@end
