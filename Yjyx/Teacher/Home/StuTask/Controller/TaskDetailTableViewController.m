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

#define stuCondition @"stuConditionCell"
#define taskConditon @"taskConditonCell"
#define submit @"submitCell"
#define unSubmit @"unSubmitcell"

@interface TaskDetailTableViewController ()

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
    
    self.title = self.taskModel.t_description;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 244,1);
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    
    [self readDataFromNetWork];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskConditionTableViewCell" bundle:nil] forCellReuseIdentifier:taskConditon];
    [self.tableView registerNib:[UINib nibWithNibName:@"StuConditionCell" bundle:nil] forCellReuseIdentifier:stuCondition];
    [self.tableView registerNib:[UINib nibWithNibName:@"SubmitCell" bundle:nil] forCellReuseIdentifier:submit];
    [self.tableView registerNib:[UINib nibWithNibName:@"UnSubmitCell" bundle:nil] forCellReuseIdentifier:unSubmit];
    
   
    self .automaticallyAdjustsScrollViewInsets = YES;
}

// 网络请求
- (void)readDataFromNetWork {
    
    [SVProgressHUD showWithStatus:@"正在拼命加载数据"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettasksubmitdetail", @"action", self.taskModel.t_id, @"taskid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_SCAN_THE_TASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
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
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            [SVProgressHUD dismissWithDelay:1.0];

        }else {
        
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
    }];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
        
        [self cell:cell addSubViewsWithFinishedArr:_finishedArr];

        
        return cell;
        
    
    }else {
        
        // 未上交学生
        
        UnSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:unSubmit forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.unfinishedArr.count == 0) {
            cell.contentView.hidden = YES;
        }else {
            cell.contentView.hidden = NO;
        }
        
        [self cell:cell addSubViewsWithUnfinishedArr:_unfinishedArr];
        

        return cell;

        
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
    
    //    NSLog(@"%@", self.choiceArr);
    
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
        if (_finishedArr.count == 0) {
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
    
    //      NSLog(@"%@", self.choiceArr);
    
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
        if (_finishedArr.count == 0) {
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
    
    //      NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (SCREEN_WIDTH - 20 - size.width <= 0) {
            // 换行
            size.width = 10;
            if (arr.count - i > 1) {
                size.height += tHeigh + 10;
            }

        }
        
        FinshedModel *model = _finishedArr[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        
        if ([model.ImageAvatar isEqual:[NSNull null]]) {
//            [imageBtn setImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
        }else {
            
//            [imageBtn setImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
            [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
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
    
    // 判断显示更多按钮是否需要显示
    
    
    cell.showMoreBtn.hidden = YES;
    
    
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
    
    //      NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        [cell.BGVIEW addSubview:taskView];
        taskView.frame = CGRectMake(size.width, size.height, tWidth , tHeigh);
        
        NSLog(@"%f", size.width );
        size.width += tWidth + padding;
        if (SCREEN_WIDTH - 20 - size.width <= 0) {
            // 换行
            size.width = 10;
            if (arr.count - i > 1) {
                size.height += tHeigh + 10;
            }

        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        FinshedModel *model = _unfinishedArr[i];
      
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        
        if ([model.ImageAvatar isEqual:[NSNull null]]) {
            [imageBtn setImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
        }else {
            
            [imageBtn setImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
            
        }
        
        
        imageBtn.tag = 200 + i;
//        [imageBtn addTarget:self action:@selector(unImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%@", model.Name];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];

        [taskView addSubview:label];
        [taskView addSubview:imageBtn];
        
//        [cell.bg_view addSubview:taskView];
    }
    self.unsubmitCellHeight = size.height + tHeigh + 30 + 30;
    cell.showMoreBtn.hidden = YES;
    

}



#pragma mark - 点击已交头像进入详情
- (void)imageBtnClick:(UIButton *)sender {
    
    StudentDetailController *stuDetailVC = [[StudentDetailController alloc] init];
    FinshedModel *model = _finishedArr[sender.tag - 200];
    stuDetailVC.finshedModel = model;
    stuDetailVC.taskID = self.taskModel.t_id;
    
    [self.navigationController pushViewController:stuDetailVC animated:YES];
    
}

#pragma mark - 点击未交头像进入详情
//- (void)unImageBtnClick:(UIButton *)sender {
//    
//    StudentDetailViewController *stuDetailVC = [[StudentDetailViewController alloc] init];
//    FinshedModel *model = _unfinishedArr[sender.tag - 200];
//    stuDetailVC.finshedModel = model;
//    stuDetailVC.taskID = self.taskModel.t_id;
//    
//    [self.navigationController pushViewController:stuDetailVC animated:YES];
//    
//    
//}


@end
