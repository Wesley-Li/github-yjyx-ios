//
//  TaskDetailTableViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskDetailTableViewController.h"
#import "TaskModel.h"

#import "TaskConditionTableViewCell.h"
#import "StuConditionCell.h"
#import "SubmitCell.h"
#import "UnSubmitCell.h"

#import "BlankFillModel.h"
#import "ChoiceModel.h"
#import "FinshedModel.h"

#import "UIImageView+WebCache.h"
#import "StudentDetailController.h"
#import "NextTableViewController.h"

#import "ReleaseMicroController.h"

#define stuCondition @"stuConditionCell"
#define taskConditon @"taskConditonCell"
#define submit @"submitCell"
#define unSubmit @"unSubmitcell"

@interface TaskDetailTableViewController ()<UnSubmitCellDelegate>

{
    CGFloat headerHeight;
}

@property (nonatomic, strong) NSMutableArray *choiceDataSource;
@property (nonatomic, strong) NSMutableArray *blankFillDataSource;
@property (nonatomic, strong) NSMutableArray *finishedArr;
@property (nonatomic, strong) NSMutableArray *unfinishedArr;

@property (nonatomic, assign) CGFloat choiceTaskCellHeight;
@property (nonatomic, assign) CGFloat blankfillTaskCellHeight;
@property (nonatomic, assign) CGFloat submitCellHeight;
@property (nonatomic, assign) CGFloat unsubmitCellHeight;

@property (nonatomic, assign) BOOL finishExpand;
@property (nonatomic, assign) BOOL unfinishExpand;

@property (nonatomic, strong) TaskConditionTableViewCell *tcell;


@end

@implementation TaskDetailTableViewController



//选择题
- (NSMutableArray *)choiceDataSource {
    
    if (!_choiceDataSource) {
        self.choiceDataSource = [NSMutableArray array];
    }
    return _choiceDataSource;
}
//填空题
- (NSMutableArray *)blankFillDataSource {
    
    if (!_blankFillDataSource) {
        self.blankFillDataSource = [NSMutableArray array];
    }
    return _blankFillDataSource;
}
//作业上交情况
- (NSMutableArray *)finishedArr{
    if (!_finishedArr) {
        self.finishedArr = [NSMutableArray array];
    }
    return _finishedArr;
}
//作业未交情况
- (NSMutableArray *)unfinishedArr{
    if (!_unfinishedArr) {
        self.unfinishedArr = [NSMutableArray array];
    }
    return _unfinishedArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerHeight = 50;
    
    self.finishExpand = NO;
    self.unfinishExpand = NO;
    
    self.title = self.taskModel.resourcename;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 244,1);
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    
//    [self readDataFromNetWork];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskConditionTableViewCell" bundle:nil] forCellReuseIdentifier:taskConditon];
    [self.tableView registerNib:[UINib nibWithNibName:@"StuConditionCell" bundle:nil] forCellReuseIdentifier:stuCondition];
    [self.tableView registerNib:[UINib nibWithNibName:@"SubmitCell" bundle:nil] forCellReuseIdentifier:submit];
    [self.tableView registerNib:[UINib nibWithNibName:@"UnSubmitCell" bundle:nil] forCellReuseIdentifier:unSubmit];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

    self.tableView.tableFooterView = footerView;
    
    UIButton *addStuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addStuBtn setImage:[UIImage imageNamed:@"add_homework"] forState:UIControlStateNormal];
    [addStuBtn setTitle:@"添加学生" forState:UIControlStateNormal];
    addStuBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    addStuBtn.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    addStuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [addStuBtn setTitleColor:RGBACOLOR(19.0, 127.0, 223.0, 1)  forState:UIControlStateNormal];
    [footerView addSubview:addStuBtn];
    [addStuBtn addTarget:self action:@selector(addReleaseStu:) forControlEvents:UIControlEventTouchUpInside];
    [addStuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView).with.offset(-10);
        make.centerY.equalTo(footerView);
        make.height.mas_equalTo(25);
    }];
    
    self .automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readDataFromNetWork];
}
- (void)addReleaseStu:(UIButton *)btn
{
    [SVProgressHUD showWithStatus:@"正在拼命加载学生数据"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"get_onetask_append_suids", @"action", self.taskModel.t_id, @"taskid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:@"/api/teacher/mobile/general_task/"] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            [SVProgressHUD dismiss];
            NSLog(@"%@", responseObject);
            if([responseObject[@"retcode"] integerValue] == 0){
            NSArray *stuArr = responseObject[@"data"][@"studentuids"];
            NSLog(@"%@", [UIApplication sharedApplication].keyWindow);
            if (stuArr.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有可追加的学生"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                NSLog(@"%@", @"哈哈");
            }else{
                ReleaseMicroController *vc = [[ReleaseMicroController alloc] init];
                vc.releaseType = 2;
                vc.addStuArr = stuArr;
                vc.taskModel = _taskModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            NSString *str = responseObject[@"msg"] == nil ? responseObject[@"reason"] : responseObject[@"msg"];
            [SVProgressHUD showWithStatus:str];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

        [SVProgressHUD showWithStatus:error.localizedDescription];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}
// 网络请求
- (void)readDataFromNetWork {
    
    [SVProgressHUD showWithStatus:@"正在拼命加载数据"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettasksubmitdetail", @"action", self.taskModel.t_id, @"taskid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_SCAN_THE_TASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            [self.blankFillDataSource removeAllObjects];
            [self.choiceDataSource removeAllObjects];
            [self.finishedArr removeAllObjects];
            [self.unfinishedArr removeAllObjects];
            // 填空
            for (NSDictionary *dic in [responseObject[@"questionstats"] objectForKey:@"blankfill"]) {
                BlankFillModel *model = [[BlankFillModel alloc] init];
                [model initBlankFillModelWithDic:dic];
                [self.blankFillDataSource addObject:model];
            }
            // 选择
            for (NSDictionary *dic in [responseObject[@"questionstats"] objectForKey:@"choice"]) {
                ChoiceModel *model = [[ChoiceModel alloc] init];
                [model initChoiceModelWithDic:dic];
                [self.choiceDataSource addObject:model];
            }
            //上交作业情况
            for (NSDictionary *dic in responseObject[@"submit"]) {
                FinshedModel *model = [[FinshedModel alloc] init];
                [model initFinshedModelWithDic:dic];
                [self.finishedArr addObject:model];
            }
            //未提交作业的情况
            for(NSDictionary  * dic in responseObject[@"unsubmit"]){
                FinshedModel *model = [[FinshedModel alloc] init];
                [model initFinshedModelWithDic:dic];
                [self.unfinishedArr addObject:model];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismissWithDelay:0.1];

        }else {
        
            [self.view makeToast:@"获取作业失败" duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:@"获取作业失败" duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
    }];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}
- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        // 选择题
        
        self.tcell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
        [_tcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.choiceDataSource.count == 0) {
            self.tcell.contentView.hidden = YES;
        }else {
            self.tcell.contentView.hidden = NO;
        }
        
        _tcell.descriptionLabel.text = @"选择题正确率";
        [self cell:_tcell addSubViewsWithChoiceArr:self.choiceDataSource];
        
        

        return _tcell;
        
    }else if (indexPath.row == 1) {
        
        // 填空题
        
        self.tcell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
        [_tcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.blankFillDataSource.count == 0) {
            self.tcell.contentView.hidden = YES;
        }else {
        
            self.tcell.contentView.hidden = NO;
        }
        
        [self cell:_tcell addSubViewsWithBlankfillArr:self.blankFillDataSource];
        _tcell.descriptionLabel.text = @"填空题正确率";
        

        return _tcell;
        
        
    }else if (indexPath.row == 2) {
        
        // 作业上交情况
        
        StuConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    
    }else if (indexPath.row == 3) {
        
        // 已上交学生
        
        SubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:submit forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.finishedArr.count == 0) {
            cell.contentView.hidden = YES;
        }else {
        
            cell.contentView.hidden = NO;
        }
        
        [cell.showMoreBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        cell.showMoreBtn.selected = self.finishExpand ? YES : NO;
        
        [self cell:cell addSubViewsWithFinishedArr:_finishedArr];

        
        return cell;
        
    
    }else {
        
        // 未上交学生
        
        UnSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:unSubmit forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        if (self.unfinishedArr.count == 0) {
            cell.contentView.hidden = YES;
        }else {
            cell.contentView.hidden = NO;
        }
        
        [cell.showMoreBtn addTarget:self action:@selector(unfinishShowMore:) forControlEvents:UIControlEventTouchUpInside];
        cell.showMoreBtn.selected = self.unfinishExpand ? YES : NO;
        
        [self cell:cell addSubViewsWithUnfinishedArr:_unfinishedArr];
        

        return cell;

        
    }
    
    
    
    


}

- (void)showMore:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.finishExpand = sender.selected ? YES : NO;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    if (self.finishExpand == NO) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)unfinishShowMore:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.unfinishExpand = sender.selected ? YES : NO;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    if (self.unfinishExpand == NO) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - 返回高度的方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.row == 0) {
        
        if (self.choiceDataSource.count == 0) {
            
            return 0;
        }else {
        
            return _choiceTaskCellHeight;
        }
        
        
    }else if (indexPath.row == 1) {
        
        if (self.blankFillDataSource.count == 0) {
            return 0;
        }else {
            
            return _blankfillTaskCellHeight;
        }
    
        
    }else if (indexPath.row == 2) {
    
        return headerHeight;
        
    }else if (indexPath.row == 3) {
    
        if (self.finishedArr.count == 0) {
            return 0;
        }else {
            
            return _submitCellHeight;
        }
        
    }else {
        
        if (self.unfinishedArr.count == 0) {
            return 0;
        }else {
        
            return _unsubmitCellHeight;
        }
    
        
    }
    
}





#pragma mark - 选择题cell赋值方法
- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithChoiceArr:(NSMutableArray *)arr {
    
    
    // 清空上次添加的所有子视图
    for (UIView *view in [cell.BGVIEW subviews]) {
        [view removeFromSuperview];
    }
    
    CGSize size = CGSizeMake(10, 0);// 初始位置
    CGFloat padding = 10;// 间距
    NSInteger num = 6;
    
    CGFloat tWidth = (cell.BGVIEW.width - padding *(num + 1)) / num;
    
    CGFloat tHeigh = tWidth + 20;
    
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.tag = 200 + i;
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (cell.BGVIEW.width - size.width <= 0) {
            // 换行
            size.width = 10;
            
            // 再做一步判断,即刚好排一排,或者剩余的空间不够排一个,但是已经排完,此时就不用换行了
            if (arr.count - i > 1) {
                size.height += tHeigh + 10;
            }
            
        }
        
        // taskView.backgroundColor = [UIColor redColor];
        ChoiceModel *model = self.choiceDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tWidth, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, tWidth, tWidth)];
        imageView.image = [UIImage imageNamed:@"corect_pic"];
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(0, 20, tWidth, tWidth);
        
        NSString *titleString;
        if (_finishedArr.count == 0 || [model.C_count floatValue] == 0) {
            titleString = [NSString stringWithFormat:@"0%%"];
        }else {
        
            titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
        }
        
        
        [choiceBtn setTitle:[NSString stringWithFormat:@"%@", titleString] forState:UIControlStateNormal];
        choiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [choiceBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        choiceBtn.tag = 300 + i;
        
        
        [choiceBtn addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:label];
        [taskView addSubview:imageView];
        [taskView addSubview:choiceBtn];
        
        [cell.BGVIEW addSubview:taskView];
    }
    self.choiceTaskCellHeight = size.height + tHeigh + 70;
    
}

#pragma mark - 点击选择题方法
- (void)handleButton:(UIButton *)sender {
    
    
    NextTableViewController *NextVC = [[NextTableViewController alloc] init];
    
    NextVC.taskid = self.taskModel.t_id;
    NextVC.qtype = @1;
    NextVC.qid = [self.choiceDataSource[sender.tag - 300] b_id];
    NextVC.currentNumber = sender.tag - 300 + 1;
    NextVC.totalNumber = self.choiceDataSource.count;
    NextVC.C_count = [self.choiceDataSource[sender.tag - 300] C_count];
    NextVC.W_count = [self.choiceDataSource[sender.tag - 300] W_count];
    
    [self.navigationController pushViewController:NextVC animated:YES];
}

#pragma mark - 填空题cell赋值方法
- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithBlankfillArr:(NSMutableArray *)arr{
    
    // 清空上次添加的所有子视图
    for (UIView *view in [cell.BGVIEW subviews]) {
        [view removeFromSuperview];
    }
    
    CGSize size = CGSizeMake(10, 0);
    CGFloat padding = 10;
    
    NSInteger num = 6;
    
    CGFloat tWidth = (cell.BGVIEW.width - padding *(num + 1)) / num;
    
    
    
    CGFloat tHeigh = tWidth + 20;
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (cell.BGVIEW.width - size.width <= 0) {
            // 换行
            size.width = 10;
            if (arr.count - i > 1) {
                size.height += tHeigh + 10;
            }

        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        BlankFillModel *model = self.blankFillDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tWidth, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, tWidth, tWidth)];
        imageView.image = [UIImage imageNamed:@"corect_pic"];
        UIButton *blankfillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        blankfillBtn.frame = CGRectMake(0, 20, tWidth, tWidth);
        
        
        NSString *titleString;
        if (_finishedArr.count == 0 || [model.C_count floatValue] == 0) {
            titleString = [NSString stringWithFormat:@"0%%"];
        }else {
            
            titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
        }

        
        [blankfillBtn setTitle:[NSString stringWithFormat:@"%@", titleString] forState:UIControlStateNormal];
        blankfillBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [blankfillBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        blankfillBtn.tag = 200 + i;
        [blankfillBtn addTarget:self action:@selector(blankfillBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:label];
        [taskView addSubview:imageView];
        [taskView addSubview:blankfillBtn];
        
        [cell.BGVIEW addSubview:taskView];
    }
    self.blankfillTaskCellHeight = size.height + tHeigh + 70;
    
    
    
}

#pragma mark - 点击填空题方法
- (void)blankfillBtnClick:(UIButton *)sender {
    
    
    NextTableViewController *NextVC = [[NextTableViewController alloc] init];
    NextVC.taskid = self.taskModel.t_id;
    
    NextVC.qtype = @2;
    NextVC.qid = [self.blankFillDataSource[sender.tag - 200] b_id];
    NextVC.currentNumber = sender.tag - 200 + 1;
    NextVC.totalNumber = self.blankFillDataSource.count;
    NextVC.C_count = [self.blankFillDataSource[sender.tag - 200] C_count];
    NextVC.W_count = [self.blankFillDataSource[sender.tag - 200] W_count];
    [self.navigationController pushViewController:NextVC animated:YES];
    
}

#pragma mark - 已上交作业cell赋值方法
- (void)cell:(SubmitCell *)cell addSubViewsWithFinishedArr:(NSMutableArray *)arr {
    
    // 清空上次添加的所有子视图
    for (UIView *view in [cell.BGVIEW subviews]) {
        [view removeFromSuperview];
    }
    
    cell.submitLabel.text = [NSString stringWithFormat:@"已交作业的同学数(%ld/%ld)", (unsigned long)_finishedArr.count, (unsigned long)_unfinishedArr.count + (unsigned long)_finishedArr.count];
    
    CGSize size = CGSizeMake(10, 0);
    CGFloat padding = 10;
    
    NSInteger num = 6;
    
    CGFloat tWidth = (SCREEN_WIDTH - 20 - padding *(num + 1)) / num;
    CGFloat tHeigh = tWidth + 20;
    
    NSInteger tempCount;
    if (arr.count > num ) {
        cell.showMoreBtn.hidden = NO;
        if (cell.showMoreBtn.selected == NO) {
            tempCount = num;
        }else {
        
            tempCount = arr.count;
        }
    }else {
        cell.showMoreBtn.hidden = YES;
        tempCount = arr.count;
    }
    
    for (int i = 0; i < tempCount; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (SCREEN_WIDTH - 20 - size.width <= 0) {
            // 换行
            size.width = 10;
            if (tempCount - i > 1) {
                size.height += tHeigh + 10;
            }

        }
        
        FinshedModel *model = _finishedArr[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        imageBtn.layer.cornerRadius = tWidth / 2;
        imageBtn.layer.masksToBounds = YES;
        
        if ([model.ImageAvatar isEqual:[NSNull null]]) {
//            [imageBtn setImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"student_p"] forState:UIControlStateNormal];
        }else {
            
//            [imageBtn setImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
            [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"student_p"]];
        }
        
        
        imageBtn.tag = 200 + i;
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%@", model.Name];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:label];
        [taskView addSubview:imageBtn];
        
        [cell.BGVIEW addSubview:taskView];
    }
    
    
    self.submitCellHeight = size.height + tHeigh + 30 + 30;
    
}

#pragma mark - 未上交作业cell赋值方法
- (void)cell:(UnSubmitCell *)cell addSubViewsWithUnfinishedArr:(NSMutableArray *)arr {
    
    // 清空上次添加的所有子视图
    for (UIView *view in [cell.BGVIEW subviews]) {
        [view removeFromSuperview];
    }
    
    cell.submitLabel.text = [NSString stringWithFormat:@"未交作业的同学数(%ld/%ld)", (unsigned long)_unfinishedArr.count, (unsigned long)_unfinishedArr.count + (unsigned long)_finishedArr.count];
    
    CGSize size = CGSizeMake(10, 0);
    CGFloat padding = 10;
    
    NSInteger num = 6;
   
    CGFloat tWidth = (SCREEN_WIDTH - 20 - padding *(num + 1)) / num;
    
    CGFloat tHeigh = tWidth + 20;
    
    NSInteger tempCount;
    if (arr.count > num ) {
        cell.showMoreBtn.hidden = NO;
        if (cell.showMoreBtn.selected == NO) {
            tempCount = num;
        }else {
            
            tempCount = arr.count;
        }
    }else {
        cell.showMoreBtn.hidden = YES;
        tempCount = arr.count;
    }
    
    for (int i = 0; i < tempCount; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        [cell.BGVIEW addSubview:taskView];
        taskView.frame = CGRectMake(size.width, size.height, tWidth , tHeigh);
        size.width += tWidth + padding;
        if (SCREEN_WIDTH - 20 - size.width <= 0) {
            // 换行
            size.width = 10;
            if (tempCount - i > 1) {
                size.height += tHeigh + 10;
            }

        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        FinshedModel *model = _unfinishedArr[i];
      
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        imageBtn.layer.cornerRadius = tWidth / 2;
        imageBtn.layer.masksToBounds = YES;

        
        if ([model.ImageAvatar isEqual:[NSNull null]]) {
            [imageBtn setImage:[UIImage imageNamed:@"student_p"] forState:UIControlStateNormal];
        }else {
            
            [imageBtn setImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"student_p"]];
            
        }
        
        
        imageBtn.tag = 200 + i;
        
        label.text = [NSString stringWithFormat:@"%@", model.Name];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];

        [taskView addSubview:label];
        [taskView addSubview:imageBtn];
        

    }
    self.unsubmitCellHeight = size.height + tHeigh + 30 + 30;
    
    

}



#pragma mark - 点击已交头像进入详情
- (void)imageBtnClick:(UIButton *)sender {
    
    StudentDetailController *stuDetailVC = [[StudentDetailController alloc] init];
    FinshedModel *model = _finishedArr[sender.tag - 200];
    stuDetailVC.studentID = model.studentID;
    stuDetailVC.taskID = self.taskModel.t_id;
    stuDetailVC.titleName = model.Name;
    [self.navigationController pushViewController:stuDetailVC animated:YES];
    
}


#pragma mark - UnSubmitCellDelegate
- (void)UnSubmitCell:(UnSubmitCell *)cell speedSubmitBtnIsClicked:(UIButton *)submitBtn
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"hastentask";
    param[@"taskid"] = self.taskModel.t_id;
    NSMutableArray *stuArr = [NSMutableArray array];
    for (FinshedModel *model in self.unfinishedArr) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:model.studentID forKey:@"id"];
        [tempDict setObject:model.Name forKey:@"name"];
        [stuArr addObject:tempDict];
    }
    NSLog(@"%@", stuArr);
    param[@"students"] = [stuArr JSONString];
    [mgr POST:[BaseURL stringByAppendingString:@"/api/teacher/mobile/task/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"已下发催交通知"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"下发催交通知失败,请重试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

@end
