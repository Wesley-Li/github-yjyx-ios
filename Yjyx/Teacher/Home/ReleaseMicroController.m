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
#import "StuGroupEntity.h"
#import "StuTaskTableViewController.h"
#import "TaskModel.h"
@interface ReleaseMicroController ()<UITableViewDelegate, UITableViewDataSource, ReleaseStudentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *classArr;
// 群组学生
@property (strong, nonatomic) NSMutableArray *groupArr;
// 保存所有学生信息
@property (strong, nonatomic) NSMutableArray *stuArr;
// 保存班级里的学生信息
@property (strong, nonatomic) NSMutableArray *classStuArr;
// 保存群组里的学生信息
@property (strong, nonatomic) NSMutableArray *groupStuArr;

// 任务描述
@property (copy, nonatomic) NSString *descripStr;
@property (copy, nonatomic) NSString *timeStr;
@end

@implementation ReleaseMicroController
static NSString *DescID = @"DescriptionCell";
static NSString *FinishTimeID = @"FinishTimeCell";
static NSString *StudentID = @"StudentCell";
#pragma mark - 懒加载
//- (NSMutableArray *)classArr
//{
//    if(_classArr == nil){
//        _classArr = [NSMutableArray array];
//    }
//    return _classArr;
//}
- (NSMutableArray *)stuArr
{
    if (_stuArr == nil) {
        _stuArr = [NSMutableArray array];
    }
    return _stuArr;
}
//- (NSMutableArray *)groupArr
//{
//    if(_groupArr == nil){
//        _groupArr = [NSMutableArray array];
//    }
//    return _groupArr;
//}
- (NSMutableArray *)groupStuArr
{
    if (_groupStuArr == nil) {
        _groupStuArr = [NSMutableArray array];
    }
    return _groupStuArr;
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
    if(self.w_id != nil || [_taskModel.tasktype isEqual:@2]){
         self.navigationItem.title = @"发布微课";
    }else{
        self.navigationItem.title = @"发布作业";
    }
    NSMutableArray *newClassArr = [NSMutableArray array];
    for (StuClassEntity *stuClassModel in self.classArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuClassModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            if(self.releaseType == 2){
                if([self.addStuArr containsObject:num]){
                    [self.stuArr addObject:stuModel];
                    [tempArr addObject:stuModel];
                }
            }else{
                [self.stuArr addObject:stuModel];
                [tempArr addObject:stuModel];
            }
        }
        if(self.releaseType == 2){
            if(tempArr.count != 0){
                [newClassArr addObject:stuClassModel];
                [self.classStuArr addObject:tempArr];
            }
            
        }else{
            [self.classStuArr addObject:tempArr];
        }
    }
    if(self.releaseType == 2){
        self.classArr = newClassArr;
    }
    NSMutableArray *newGroupArr = [NSMutableArray array];
    for (StuGroupEntity *stuGroupModel in self.groupArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuGroupModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            if(self.releaseType == 2){
                if([self.addStuArr containsObject:num]){
                    [self.stuArr addObject:stuModel];
                    [tempArr addObject:stuModel];
                }
            }else{
                [self.stuArr addObject:stuModel];
                [tempArr addObject:stuModel];
            }
        }
        if(self.releaseType == 2){
            if(tempArr.count != 0){
                [newGroupArr addObject:stuGroupModel];
                [self.groupStuArr addObject:tempArr];
            }
           
        }else{
            [self.groupStuArr addObject:tempArr];
        }
    }
    if(self.releaseType == 2){
        self.groupArr = newGroupArr;
    }
    [self loadBackBtn];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseDescrpitionCell class]) bundle:nil] forCellReuseIdentifier:DescID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseFinishTimeCell class]) bundle:nil] forCellReuseIdentifier:FinishTimeID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseStudentCell class]) bundle:nil] forCellReuseIdentifier:StudentID];
    self.tableView.sectionFooterHeight = 0;
//    self.tableView.sectionHeaderHeight = 10;
    if(self.releaseType == 2){
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, -49, 0);

    }
    
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
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -49, 0);
    
    //  键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
#pragma mark - 私有方法

- (void)loadData
{
    self.classArr = [[StuDataBase shareStuDataBase] selectAllClass];
    self.groupArr = [[StuDataBase shareStuDataBase] selectAllGroup];
    NSLog(@"%@", self.groupArr);
}
- (void)releaseBtnClicked
{

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
    if (self.releaseType == 2) {
        param[@"action"] = @"task_append_students";
    }else{
        param[@"action"] = @"add_task";
    }
    NSLog(@"%@", [pamarArr JSONString]);
    param[@"recipients"] = [pamarArr JSONString];
    if(self.releaseType == 1){
        param[@"tasktype"] = @"exam";
        param[@"examid"] = self.examid;
    }else if(self.releaseType == 2){
        param[@"tasktype"] = _taskModel.tasktype;
        param[@"taskid"] = _taskModel.t_id;
        param[@"relatedresourceid"] = _taskModel.relatedresourceid;
        
    }else{
        param[@"tasktype"] = @"lesson";
        param[@"lessonid"] = self.w_id;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
    
    NSInteger seconds=[timeZone secondsFromGMTForDate:[NSDate date]];
    
    NSDate *newDate=[[NSDate date] dateByAddingTimeInterval:seconds];
    NSString *dateStr = [fmt stringFromDate:newDate];
    
    NSLog(@"%@--%@", [NSDate date], dateStr);
    ReleaseDescrpitionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.classArr.count + self.groupArr.count + 1]];
    ReleaseFinishTimeCell *timecell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.classArr.count + self.groupArr.count ]];
    self.descripStr = cell.descriptionTextField.text;
    self.timeStr = timecell.timeLabel.text;
     NSString *descStr = [NSString stringWithFormat:@"%@ 微课", dateStr];
    if(self.releaseType == 1){
       descStr = [NSString stringWithFormat:@"%@ 作业", dateStr];
    }
    NSString *descTempStr = [self.descripStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.releaseType != 2) {
        param[@"desc"] = [descTempStr isEqualToString:@""] ? descStr : self.descripStr;
    }
    
    
    NSString *numstr = [self.timeStr stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(numstr.length > 0 ){
        [SVProgressHUD showWithStatus:@"输入的建议完成时间包含特殊字符"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    NSLog(@"%@", self.timeStr);
    if (self.releaseType != 2) {
        if([self.timeStr integerValue] == 0 && ![self.timeStr isEqualToString:@""]){
            [SVProgressHUD showWithStatus:@"建议完成时间必须大于0"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
             return;
        }
    
        param[@"suggestspendtime"] = [self.timeStr isEqualToString:@""] ? @"30" : self.timeStr;
    }
    
    NSLog(@"%@", param);
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    coverView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:coverView];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [SVProgressHUD showWithStatus:@"正在发布..."];
    [mgr POST:[BaseURL stringByAppendingString:@"/api/teacher/mobile/general_task/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject[@"reason"]);
        if([responseObject[@"retcode"] isEqual:@0]){
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            if (self.releaseType == 2) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                // 跳转到学生作业列表
                StuTaskTableViewController *stuTaskVC = [[StuTaskTableViewController alloc] init];
                [self.navigationController pushViewController:stuTaskVC animated:YES];
            }
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [coverView removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showSuccessWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [coverView removeFromSuperview];
    }];
}


#pragma mark - UITableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.releaseType == 2){
        return self.classArr.count + self.groupArr.count;
    }else{
        return self.classArr.count + self.groupArr.count + 2;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == self.classArr.count + self.groupArr.count || section == self.classArr.count + self.groupArr.count + 1){
        return 1;
    }else if(section < self.classArr.count){
        StuClassEntity *classEntity = self.classArr[section];
        if (classEntity.isExpanded) {
//            return classEntity.memberlist.count + 1;
            return [self.classStuArr[section] count] + 1;
        }else{
            return 1;
        }
    }else{
        StuGroupEntity *groupEntity = self.groupArr[section - _classArr.count];
        if (groupEntity.isExpanded) {
//            return groupEntity.memberlist.count + 1;
            return [self.groupStuArr[section - _classArr.count] count] + 1;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.classArr.count + self.groupArr.count ){
        ReleaseFinishTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:FinishTimeID];
        self.timeStr = cell.timeLabel.text;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone; 
        return cell;
   }else if(indexPath.section == self.classArr.count + self.groupArr.count + 1){
        ReleaseDescrpitionCell *cell = [tableView dequeueReusableCellWithIdentifier:DescID];
        self.descripStr = cell.descriptionTextField.text;
        return cell;
    } else if(indexPath.section < self.classArr.count){
        ReleaseStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:StudentID];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.classEntity = _classArr[indexPath.section];
            cell.backgroundColor = [UIColor whiteColor];
        }else{
        
            NSMutableArray *arr =  self.classStuArr[indexPath.section];
            StudentEntity *stuModel =  arr[indexPath.row - 1];
            cell.stuEntity = stuModel;
            cell.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
            
        }
 
        return cell;
    }else{
        ReleaseStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:StudentID];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.groupEntity = _groupArr[indexPath.section - _classArr.count];
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            
            NSMutableArray *arr =  self.groupStuArr[indexPath.section -  _classArr.count];
            StudentEntity *stuModel =  arr[indexPath.row - 1];
            cell.stuEntity = stuModel;
            cell.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
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
            for (NSNumber *num in self.classStuArr[indexPath.section]) {
                [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
            }
//            for (NSNumber *num in classEntity.memberlist) {
//                [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
//            }
            [self.tableView insertRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationNone];
        }else{
            NSMutableArray *tempArr = [NSMutableArray array];
            NSInteger i = 1;
            for (NSNumber *num in self.classStuArr[indexPath.section]) {
                [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
            }
//            for (NSNumber *num in classEntity.memberlist) {
//                [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
//            }
            [self.tableView deleteRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if(indexPath.row == 0 && indexPath.section < self.classArr.count + self.groupArr.count){
            StuGroupEntity *groupEntity = self.groupArr[indexPath.section - _classArr.count];
            groupEntity.isExpanded = !groupEntity.isExpanded;
            if (groupEntity.isExpanded) {
                NSMutableArray *tempArr = [NSMutableArray array];
                NSInteger i = 1;
                for (NSNumber *num in self.groupStuArr[indexPath.section - _classArr.count]) {
                    [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
                }
//                for (NSNumber *num in groupEntity.memberlist) {
//                    [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
//                }
                [self.tableView insertRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationNone];
            }else{
                    NSMutableArray *tempArr = [NSMutableArray array];
                    NSInteger i = 1;
                for (NSNumber *num in self.groupStuArr[indexPath.section - _classArr.count]) {
                    [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
                }
//                    for (NSNumber *num in groupEntity.memberlist) {
//                        [tempArr addObject:[NSIndexPath indexPathForRow:i++ inSection:indexPath.section]];
//                    }
                    [self.tableView deleteRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationNone];
                }
        
    }
    if(indexPath.section < self.classArr.count + self.groupArr.count){
         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if(self.releaseType == 2){
            return 49;
        }else{
            return 0;
        }
        
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if(self.releaseType == 2){
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 49)];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = @"将作业布置给:";
            [infoLabel sizeToFit];
            infoLabel.x = 20;
            infoLabel.centerY = headerView.height / 2;
            infoLabel.font = [UIFont systemFontOfSize:16];
            
            
            infoLabel.textColor = [UIColor blackColor];
            
            [headerView addSubview:infoLabel];
            
            return headerView;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
#pragma mark - ReleaseStudentCell代理方法
- (void)releaseStudentCell:(ReleaseStudentCell *)cell allBtnSelectedClicked:(UIButton *)btn
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSMutableArray *tempArr = [NSMutableArray array];
    if (indexpath.section < _classArr.count) {
        tempArr = self.classStuArr[indexpath.section];
        StuClassEntity *classEntity = self.classArr[indexpath.section];
        classEntity.isSelect = btn.selected;
        
    }else{
        tempArr = self.groupStuArr[indexpath.section - _classArr.count];
        StuGroupEntity *groupEntity = self.groupArr[indexpath.section - _classArr.count];
        groupEntity.isSelect = btn.selected;
    }
    
        for (NSInteger i = 0; i < tempArr.count; i++) {
            StudentEntity *stuModel = tempArr[i];
            stuModel.isSelect = btn.isSelected;
        }
        
        [self.tableView reloadData];
  
}
- (void)releaseStudentCell:(ReleaseStudentCell *)cell isSelectedClicked:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld, %ld", indexPath.row, indexPath.section);
    if (btn.selected == NO) {
        ReleaseStudentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        if (indexPath.section < _classArr.count) {
            NSLog(@"%@", cell.classEntity);
            StuClassEntity *classEntity = self.classArr[indexPath.section];
            classEntity.isSelect = NO;
            
        }else{
            StuGroupEntity *groupEntity = self.groupArr[indexPath.section - _classArr.count];
            groupEntity.isSelect = NO;
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.classArr.count + self.groupArr.count + 1]];
    NSLog(@"%@", NSStringFromCGRect(cell.frame));
        CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        NSInteger padding = 0;
        if(cell.frame.origin.y > SCREEN_HEIGHT - 64 - rect.size.height - cell.frame.size.height){
            padding = cell.frame.origin.y - (SCREEN_HEIGHT - 64 - rect.size.height) + cell.frame.size.height;
            if (cell.frame.origin.y > SCREEN_HEIGHT - 64) {
                padding = rect.size.height;
            }
        }
        NSLog(@"%ld", padding);
        self.view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT /2 - padding);
    
    }];
   
  
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
//    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
           self.view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT/ 2);
        }];
//
  
}
         
@end
