//
//  TaskDetailTableViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskDetailTableViewController.h"
#import "TaskModel.h"
#import "StuConditionTableViewCell.h"
#import "TaskConditionTableViewCell.h"
#import "BlankFillModel.h"
#import "ChoiceModel.h"
#import "FinshedModel.h"
#import "PNChart.h"
#import "TCustomView.h"
#import "UIImageView+WebCache.h"
#import "StudentDetailViewController.h"
#import "NextTableViewController.h"

#define stuCondition @"stuConditionCell"
#define taskConditon @"taskConditonCell"

@interface TaskDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *choiceDataSource;
@property (nonatomic, strong) NSMutableArray *blankFillDataSource;
@property (nonatomic, strong) NSMutableArray *finishedArr;
@property (nonatomic, strong) NSMutableArray *unfinishedArr;

@property (nonatomic, assign) NSInteger choiceTaskCellHeight;
@property (nonatomic, assign) NSInteger blankfillTaskCellHeight;
@property (nonatomic, assign) NSInteger finishedCellHeight;
@property (nonatomic, assign) NSInteger unfinishedCellHeight;

@property (nonatomic, strong) StuConditionTableViewCell *stuCell;


@property (nonatomic)BOOL showmoreBtn;
@property (nonatomic)BOOL unShowmoreBtn;

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
    
    self.showmoreBtn = YES;
    self.unShowmoreBtn = YES;
    self.title = self.taskModel.t_description;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self readDataFromNetWork];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskConditionTableViewCell" bundle:nil] forCellReuseIdentifier:taskConditon];
    //    [self.tableView registerNib:[UINib nibWithNibName:@"StuConditionTableViewCell" bundle:nil] forCellReuseIdentifier:stuCondition];
    [self.tableView registerClass:[StuConditionTableViewCell class] forCellReuseIdentifier:stuCondition];
    self .automaticallyAdjustsScrollViewInsets = YES;
}

// 网络请求
- (void)readDataFromNetWork {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettasksubmitdetail", @"action", self.taskModel.t_id, @"taskid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:T_SESSIONID forHTTPHeaderField:@"sessionid"];

    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_SCAN_THE_TASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
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
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if (_choiceDataSource.count == 0 || _blankFillDataSource.count == 0) {
        return 2;
    }
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_choiceDataSource.count != 0 && _blankFillDataSource.count == 0) {
        if (indexPath.row == 0) {
            self.tcell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
            _tcell.descriptionLabel.text = @"选择题正确率";
            [self cell:_tcell addSubViewsWithChoiceArr:self.choiceDataSource];
            return _tcell;
        }else {
            
           
            self.stuCell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
            
           
            
            
            
            self.stuCell.descriptionLabel.text = @"作业上交情况";
            self.stuCell.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            self.stuCell.submitLabel.text = [NSString stringWithFormat:@"已交作业的同学数(%ld/%ld)", self.finishedArr.count, self.unfinishedArr.count + self.finishedArr.count];
            self.stuCell.unsubmitLabel.text =[NSString stringWithFormat:@"未交作业的同学数(%ld/%ld)", self.unfinishedArr.count, self.unfinishedArr.count + self.finishedArr.count];
            
            self.stuCell.submitLabel.font = [UIFont fontWithName:@"Arial" size:14];
            self.stuCell.unsubmitLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            
            self.stuCell.showView1.tag = 201;
            // 设置选中未选中
            [self addshowMoreStuFinished];
            
            [self cell: _stuCell  addSubViewsWithfinishedfillArr:self.finishedArr];
            [self cell:_stuCell addSubViewsWithUnfinishedfillArr:self.unfinishedArr];
            //            self.stuCell.userInteractionEnabled = NO;
            //             [_stuCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [self.stuCell.showmoreBtn addTarget:self action:@selector(showMoreStuWithFinishedArr:) forControlEvents:UIControlEventTouchUpInside];
            [self.stuCell.showUnsubmitBtn addTarget:self action:@selector(showMoreStuWithUnFinishedArr) forControlEvents:UIControlEventTouchUpInside];
            
            return self.stuCell;
            
        }
    }else if (_blankFillDataSource != 0 && _choiceDataSource == 0) {
        if (indexPath.row == 0) {
            self.tcell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
            [self cell:_tcell addSubViewsWithBlankfillArr:self.blankFillDataSource];
            _tcell.descriptionLabel.text = @"填空题正确率";
            return _tcell;
        }else {
            
            self.stuCell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
            _stuCell.descriptionLabel.text = @"作业上交情况";
            self.stuCell.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            return _stuCell;
        }
        
    }else {
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            self.tcell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
            
            if (indexPath.row == 0) {
                //            cell.choiceArr = self.choiceDataSource;
                _tcell.descriptionLabel.text = @"选择题正确率";
                
                [self cell:_tcell addSubViewsWithChoiceArr:self.choiceDataSource];
                //            [cell setValuesWithChoiceModelArr:self.choiceDataSource];
                return _tcell;
            }else {
                //            cell.blankArr = self.blankFillDataSource;
                [self cell:_tcell addSubViewsWithBlankfillArr:self.blankFillDataSource];
                _tcell.descriptionLabel.text = @"填空题正确率";
                return _tcell;
                
            }
            
        }else {
            
            self.stuCell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
            _stuCell.descriptionLabel.text = @"作业上交情况";
            self.stuCell.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            return _stuCell;
            
        }
        
    }
    
    
    /*
     
     TaskConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskConditon forIndexPath:indexPath];
     TCustomView *view = [[[NSBundle mainBundle] loadNibNamed:@"TCustomView" owner:nil options:nil] lastObject];
     
     view.taskidlabel.text = @"测试";
     [cell addSubview:view];
     */
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //cell  不可点击事件
    [_stuCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    self.showmoreBtn = !self.showmoreBtn;
    //    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    //    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    //
    
}

- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithChoiceArr:(NSMutableArray *)arr {
    
    CGSize size = CGSizeMake(10, 25);// 初始位置
    CGFloat padding = 5;// 间距
    CGFloat TWidth = 40;
    CGFloat Theight = 60;


    
    //    NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.tag = 200 + i;
        taskView.frame = CGRectMake(size.width, size.height, TWidth, Theight);
        
        size.width += TWidth + padding;
        
        if (cell.bg_view.width - size.width < TWidth + padding) {
            // 换行
            size.width = 10;
            
            // 再做一步判断,即刚好排一排,或者剩余的空间不够排一个,但是已经排完,此时就不用换行了
            if (arr.count - i > 1) {
                size.height += Theight;
            }
            
        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        ChoiceModel *model = self.choiceDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TWidth, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, TWidth, TWidth)];
        imageView.image = [UIImage imageNamed:@"corect_pic"];
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(0, 20, TWidth, TWidth);
        NSString *titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
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
        
        [cell.bg_view addSubview:taskView];
    }
    self.choiceTaskCellHeight = size.height + 80 + 30;
    
}

- (void)handleButton {
    
    NSLog(@"点击了题目");

    self.choiceTaskCellHeight = size.height + 60 + 30;
}


// 点击选择题
- (void)handleButton:(UIButton *)sender {
    
    
    NextTableViewController *NextVC = [[NextTableViewController alloc] init];
    
    NextVC.taskid = self.taskModel.t_id;
    NextVC.qtype = @1;
    NextVC.qid = [self.choiceDataSource[sender.tag - 300] b_id];

    [self.navigationController pushViewController:NextVC animated:YES];
}

- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithBlankfillArr:(NSMutableArray *)arr{
    
    CGSize size = CGSizeMake(10, 25);
    CGFloat padding = 5;
    
    CGFloat TWidth = 40;
    CGFloat Theight = 60;
    
    //      NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, TWidth, Theight);
        
        size.width += TWidth + padding;
        
        if (cell.bg_view.width - size.width < TWidth + padding) {
            // 换行
            size.width = 10;
            size.height += Theight;
        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        BlankFillModel *model = self.blankFillDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TWidth, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, TWidth, TWidth)];
        imageView.image = [UIImage imageNamed:@"corect_pic"];
        UIButton *blankfillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        blankfillBtn.frame = CGRectMake(0, 20, TWidth, TWidth);
        NSString *titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
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
        
        [cell.bg_view addSubview:taskView];
    }
    self.blankfillTaskCellHeight = size.height + 80 + 30;
    
    
    
}

- (void)buttonClick {
    
    NSLog(@"点击了填空题");
    self.blankfillTaskCellHeight = size.height + 60 + 30;

}

// 点击填空题
- (void)blankfillBtnClick:(UIButton *)sender {


    NextTableViewController *NextVC = [[NextTableViewController alloc] init];
    NextVC.taskid = self.taskModel.t_id;

    NextVC.qtype = @2;
    NextVC.qid = [self.blankFillDataSource[sender.tag - 200] b_id];

    [self.navigationController pushViewController:NextVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_blankFillDataSource.count == 0 && _choiceDataSource != 0) {
        if (indexPath.row == 0) {
            return _choiceTaskCellHeight;
        }else {
            
            CGFloat height = 185;
            CGFloat viewW = self.view.frame.size.width;
            if (_finishedArr.count != 0) {
                if (!self.showmoreBtn) {
                    NSInteger row = ((NSInteger)_finishedArr.count * (60 + 10) + 10 )/ (viewW - 40) + 0.9;
                    height = height + row * 80;
                }
                
            }
            if (_unfinishedArr.count != 0) {
                height += 165;
                if (!self.unShowmoreBtn) {
                    NSInteger row = ((NSInteger)_unfinishedArr.count * (60 + 10) + 10) / (viewW - 40) + 0.9;
                    height = height + row * 80;
                }
            }
            
            return height;
        }
        
    }else if (_blankFillDataSource.count != 0 && _choiceDataSource == 0) {
        
        if (indexPath.row == 0) {
            return _blankfillTaskCellHeight;
        }else {
            
            CGFloat height = 185;
            CGFloat viewW = self.view.frame.size.width;
            if (_finishedArr.count != 0) {
                if (!self.showmoreBtn) {
                    NSInteger row = ((NSInteger)_finishedArr.count * (60 + 10) + 10) / (viewW - 40) + 0.9;
                    height = height + row * 80;
                }
                
            }
            if (_unfinishedArr.count != 0) {
                height += 165;
                if (!self.unShowmoreBtn) {
                    NSInteger row = ((NSInteger)_unfinishedArr.count * (60 + 10))+ 10 / (viewW - 40) + 0.9;
                    height = height + row * 80;
                }
            }
            
            return height;
        }
        
    }
    
    if (indexPath.row == 0) {
        return _choiceTaskCellHeight;
    }else if (indexPath.row == 1){
        
        return _blankfillTaskCellHeight;
    }
    else {
        CGFloat height = 185;
        CGFloat viewW = self.view.frame.size.width;
        if (_finishedArr.count != 0) {
            if (!self.showmoreBtn) {
                NSInteger row = ((NSInteger)_finishedArr.count * (60 + 10) + 10 )/ (viewW - 40) + 0.9;
                height = height + row * 80;
            }
            
        }
        if (_unfinishedArr.count != 0) {
            height += 165;
            if (!self.unShowmoreBtn) {
                NSInteger row =((NSInteger)_unfinishedArr.count * (60 + 10)) + 10 / (viewW - 40) + 0.9;
                height = height + row * 80;
            }
        }
        
        return height;
    }
    
    
    
}
//上交作业的同学数
- (void)cell:(StuConditionTableViewCell *)cell addSubViewsWithfinishedfillArr:(NSMutableArray *)arr{
    _stuCell.showView1.backgroundColor = [UIColor whiteColor];
       NSInteger row = ((NSInteger)_finishedArr.count * (60 + 10) + 10) / (self.view.frame.size.width - 40) + 0.9;
    if (row-1> 0) {
        self.stuCell.showmoreBtn.hidden = NO;
    }else{
        self.stuCell.showmoreBtn.hidden = YES;
    }
    
    CGSize size = CGSizeMake(10, 5);
    CGFloat padding = 5;
    
    CGFloat FWidth = 60;
    CGFloat Fheight = 80;
    NSLog(@"%@",_finishedArr);
    
    [cell.showView1.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]] && ![obj isKindOfClass:[UILabel class]] && ![obj isKindOfClass:[UIButton class]] && obj != cell.line1) {
            [(UIView *)obj removeFromSuperview];
        }
    }];
//    if (!self.showmoreBtn) {
    
//        //TODO: 要显示数组的个数
//        
//        num = 8;
//    } else {
//        num = 4;
//    }
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height + 20, FWidth, Fheight);
        
        size.width += FWidth + padding;
        
        if (cell.showView1.width - size.width < FWidth + padding) {
            size.height += Fheight + padding;
            size.width = 10;
            //            return ;
        }
        
        FinshedModel * model = self.finishedArr[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, FWidth, 10)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FWidth, FWidth)];
        
                if ([model.ImageAvatar isEqual:[NSNull null]]) {
                    imageView.image = [UIImage imageNamed:@"pic"];
                }else {
        
                    [imageView setImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"pic"]];
                }
//        imageView.image = [UIImage imageNamed:@"pic"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 5, FWidth, FWidth);
                NSString *titleString = [NSString stringWithFormat:@"%@", model.Name ];
        
                [button setTitle:[NSString stringWithFormat:@"%@", titleString] forState:UIControlStateNormal];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(buttonfinishedImgClick:) forControlEvents:UIControlEventTouchUpInside];
        
                label.text = [NSString stringWithFormat:@"%@",model.Name ];
//        label.text= @"丁三";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Arial" size:10];
        [taskView addSubview:label];
        [taskView addSubview:imageView];
        [taskView addSubview:button];
        
        [cell.showView1 addSubview:taskView];
    }
    [self.stuCell.contentView addSubview:self.stuCell.showmoreBtn];
    
    
}

//未上交作业的同学数
- (void) cell : (StuConditionTableViewCell *)cell addSubViewsWithUnfinishedfillArr:(NSMutableArray *)arr{
    _stuCell.showView2.backgroundColor = [UIColor whiteColor];
    
    NSInteger row = ((NSInteger)_unfinishedArr.count * (60 + 10) + 10) / (self.view.frame.size.width - 40) + 0.9;
    if (row-1> 0) {
        self.stuCell.showUnsubmitBtn.hidden = NO;
    }else{
        self.stuCell.showUnsubmitBtn.hidden = YES;
    }
    
    CGSize size = CGSizeMake(10, 5);
    CGFloat padding = 5;
    
    CGFloat FWidth = 60;
    CGFloat Fheight = 80;
    //    NSLog(@"%@",_unfinishedArr);
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, FWidth, Fheight);
        
        size.width += FWidth + padding;
        
        if (cell.showView1.width - size.width < FWidth + padding) {
            
            return ;
        }
        
        FinshedModel * model = self.unfinishedArr[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, FWidth, 10)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, FWidth, FWidth)];
        
        if ([model.ImageAvatar isEqual:[NSNull null]]) {
            imageView.image = [UIImage imageNamed:@"pic"];
        }else {
            
            [imageView setImageWithURL:[NSURL URLWithString:model.ImageAvatar] placeholderImage:[UIImage imageNamed:@"pic"]];
        }
        imageView.image = [UIImage imageNamed:@"pic"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 5, FWidth, FWidth);
        button.tag = 201 + i;
        [button addTarget:self action:@selector(buttonUnfinishedImgClick) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%@",model.Name ];
        //        label.text= @"丁三";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Arial" size:10];
        [taskView addSubview:label];
        [taskView addSubview:imageView];
        [taskView addSubview:button];
        
        [cell.showView2 addSubview:taskView];
    }
    
    
    
    if (!self.unShowmoreBtn) {
        
       
        
        [self.stuCell.showUnsubmitBtn setImage:[UIImage imageNamed:@"list_btn_shutdown.png"] forState:UIControlStateNormal];
        
        
        
        NSInteger row = ((NSInteger)_unfinishedArr.count * (60 + 10) + 10) / (self.view.frame.size.width - 40) + 0.9;
        
        
        CGFloat height =  (row-1) * 85 + 85;
        
        if (row -1 > 0){
            
            self.stuCell.showView1.frame = CGRectMake(10, 40, self.view.frame.size.width-20,height);

            
        }else{
            height = 85;
            self.stuCell.showView1.frame = CGRectMake(10, 40, self.view.frame.size.width-20,height);

            
        }

        self.stuCell.showView1.backgroundColor = [UIColor whiteColor];
        
        
    } else {
        //        self.stuCell.showUnsubmitBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 25, 120, 50, 30);
        self.stuCell.showView2.frame = CGRectMake(10, CGRectGetMaxY(self.stuCell.showView1.frame)+50, self.view.frame.size.width-20, 100);
        [self.stuCell.showUnsubmitBtn setImage:[UIImage imageNamed:@"list_btn_More.png"] forState:UIControlStateNormal];
    }
    
    
    NSLog(@"  %f     %f   %f",self.stuCell.showView1.frame.origin.y,self.stuCell.showView2.frame.origin.y,self.stuCell.showUnsubmitBtn.frame.origin.y);
    
    
    //    self.stuCell.showView2.frame = CGRectMake(10, CGRectGetMaxY(self.stuCell.showView1.frame)+50, self.view.frame.size.width-20, 100);
    
    self.stuCell.showUnsubmitBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 25, CGRectGetMaxY(self.stuCell.showView2.frame)+10, 50, 30);
    self.unfinishedCellHeight =   self.stuCell.showView2.frame.size.height + 40 ;
    
    
    [self.stuCell.contentView addSubview:self.stuCell.showUnsubmitBtn];
    
    
}
- (void) buttonfinishedImgClick:(UIButton *)sender{
    
    NSLog(@"点击了头像");
    StudentDetailViewController * StudentVC = [[StudentDetailViewController  alloc]init];
    //TODO:界面跳转需传值
    //    StudentVC.finshedModel = _finishedArr[sender.tag - 200];
    //    StudentVC.taskID  = self.taskModel.t_id;
    //    NSLog(@"%@-------",StudentVC);
    //    NSLog(@"%@====",self.taskModel.t_id);
    
    [self.navigationController pushViewController:StudentVC animated:YES];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
}
- (void)buttonUnfinishedImgClick{
    
    //     [self.stuCell.showView2 makeToast:@"该学生没完成作业" duration:1.0 position:SHOW_CENTER complete:nil];
    
}

- (void)showMoreStuWithFinishedArr:(NSMutableArray *)arr {
    
    
    self.showmoreBtn = !self.showmoreBtn;
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addshowMoreStuFinished {
    if (!self.showmoreBtn) {
        //        [self.stuCell.showmoreBtn removeFromSuperview];
        
        
        [self.stuCell.showmoreBtn setImage:[UIImage imageNamed:@"list_btn_shutdown.png"] forState:UIControlStateNormal];
        
        //TODO:   Y值需要计算
        
        NSInteger row = ((NSInteger)_finishedArr.count * (60 + 10) + 10) / (self.view.frame.size.width - 40) + 0.9;
        
        
        CGFloat height =  (row-1) * 85 + 85;
        
        if (row -1 > 0){
            
            self.stuCell.showView1.frame = CGRectMake(10, 40, self.view.frame.size.width-20,height);
            
            
        }else{
            height = 85;
            self.stuCell.showView1.frame = CGRectMake(10, 40, self.view.frame.size.width-20,height);
            
            
        }
        NSLog(@"%f******",height-35);
        
        //        self.stuCell.showView2.frame = CGRectMake(10, CGRectGetMaxY(self.stuCell.showView1.frame)+50, self.view.frame.size.width-20, 100);
        //        self.stuCell.showView2.frame = CGRectMake(10,  CGRectGetMaxY(self.stuCell.showView1.frame)+50, self.view.frame.size.width-20, 200);
        
        self.stuCell.showView1.backgroundColor = [UIColor whiteColor];
    } else {
        
        [self.stuCell.showmoreBtn setImage:[UIImage imageNamed:@"list_btn_More.png"] forState:UIControlStateNormal];
        
        self.stuCell.showView1.frame = CGRectMake(10, 40, self.view.frame.size.width-40, 100);
        //        [self.stuCell addSubview:self.stuCell.showView1];
        //        self.stuCell.showView2.frame = CGRectMake(10, CGRectGetMaxY(self.stuCell.showView1.frame)+50, self.view.frame.size.width-20, 100);
        
        
    }
    
    self.stuCell.showmoreBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 25, CGRectGetMaxY(self.stuCell.showView1.frame)+15, 50, 30);
    
    
    self.finishedCellHeight =   self.stuCell.showView1.frame.size.height + 40 ;
    
    
}

- (void)showMoreStuWithUnFinishedArr{
    self.unShowmoreBtn=!self.unShowmoreBtn;
    //    [self addshowMoreUnStuFinished];
    [self.tableView reloadData];
}

//- (void)addshowMoreUnStuFinished {
//   
//}

@end
