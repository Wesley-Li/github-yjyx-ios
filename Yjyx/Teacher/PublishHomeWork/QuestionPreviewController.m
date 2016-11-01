//
//  QuestionPreviewController.m
//  Yjyx
//
//  Created by liushaochang on 16/6/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "QuestionPreviewController.h"
#import "ChaperContentItem.h"
#import "QuestionPreviewCell.h"
#import "QuestionDataBase.h"
#import "ReleaseHomeWorkController.h"
#import "YjyxWrongSubModel.h"
#import "ChaperContentItem.h"
#import "OneSubjectController.h"
#define kIndentifier @"fhdsjfhdskjhf"
@interface QuestionPreviewController ()<UITableViewDelegate, UITableViewDataSource, QuestionPreviewCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *configurePublishBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDic;
@property (strong, nonatomic) NSMutableArray *tempArray;// 删除题目时的临时数组
@property (strong, nonatomic) UIButton *reuqireBtn;

@property (weak, nonatomic) IBOutlet UIButton *allRequireBtn;
@property (weak, nonatomic) IBOutlet UIButton *rebackBtn;

@end

@implementation QuestionPreviewController


- (NSMutableArray *)selectArr {

    if (!_selectArr) {
        self.selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
- (NSMutableArray *)tempArray {

    if (!_tempArray) {
        self.tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    if(self.isMoved == 1){
        _model.tag = _preSelIndexPath.row + 200;
        [self.tempArray addObject:_model];
        // 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkTheNum" object:self];
    }
    [self seperatePart];
    [self saveDataToTemp];
    if(self.selectArr.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.selectArr = [[QuestionDataBase shareDataBase] selectAllTempQuestion];
    [self.tableView reloadData];
    NSLog(@"%@", self.selectArr);
}

// 选择和填空分开
- (void)seperatePart {

    NSMutableArray *tempChoiceArr = [NSMutableArray array];
    NSMutableArray *tempBlankfillArr = [NSMutableArray array];
    
    for (int i = 0; i < _selectArr.count; i++) {
        if ([self.selectArr[i] isKindOfClass:[ChaperContentItem class]]) {
            ChaperContentItem *item = self.selectArr[i];
            if ([item.subject_type isEqualToString:@"1"]) {
                [tempChoiceArr addObject:item];
            }else if ([item.subject_type isEqualToString:@"2"]) {
                [tempBlankfillArr addObject:item];
            }
            
            
        }else{
            YjyxWrongSubModel *model = self.selectArr[i];
            if (model.questiontype == 1) {
                [tempChoiceArr addObject:model];
            }else if (model.questiontype == 2) {
            
                [tempBlankfillArr addObject:model];
            }
            
        }

    }
     NSLog(@"%@", self.selectArr);
    [self.selectArr removeAllObjects];
   
    [self.selectArr addObjectsFromArray:tempChoiceArr];
    [self.selectArr addObjectsFromArray:tempBlankfillArr];
     NSLog(@"%@", self.selectArr);
    
}

// 插入数据库
- (void)saveDataToTemp {

    [[QuestionDataBase shareDataBase] deleteTemptable];
    for (int i = 0; i < self.selectArr.count; i++) {
        if ([self.selectArr[i] isKindOfClass:[ChaperContentItem class]]) {
            ChaperContentItem *item = self.selectArr[i];
            [[QuestionDataBase shareDataBase] insertTemp:item];
        }else if ([self.selectArr[i] isKindOfClass:[YjyxWrongSubModel class]]) {
            YjyxWrongSubModel *item = self.selectArr[i];
            [[QuestionDataBase shareDataBase] insertTemp:item];
            
        }
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预览作业";
  
    [self loadBackBtn];
    self.configurePublishBtn.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    self.cellHeightDic = [NSMutableDictionary dictionary];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.scrollIndicatorInsets =  UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionPreviewCell" bundle:nil] forCellReuseIdentifier:kIndentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellHeightChange:) name:@"QuestionPreviewCellHeight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTheDeletequestionNum) name:@"checkTheNum" object:nil];
    
    self.allRequireBtn.layer.cornerRadius = 5;
    self.allRequireBtn.layer.borderColor = TEACHERCOLOR.CGColor;
    self.allRequireBtn.layer.borderWidth = 1;
    self.allRequireBtn.layer.masksToBounds = YES;
    
//    if (self.tempArray.count == 0) {
//        [self.rebackBtn setBackgroundImage:[UIImage imageNamed:@"reback_icon_de"] forState:UIControlStateNormal];
//        self.rebackBtn.userInteractionEnabled = NO;
//    }else {
//        
//        [self.rebackBtn setBackgroundImage:[UIImage imageNamed:@"reback_icon"] forState:UIControlStateNormal];
//        self.rebackBtn.userInteractionEnabled = YES;
//    }
//
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[QuestionDataBase shareDataBase] deleteQuestionTable];
    for (int i = 0; i < _selectArr.count; i++) {
        if ([self.selectArr[i] isKindOfClass:[ChaperContentItem class]]) {
            ChaperContentItem *item = self.selectArr[i];
            [[QuestionDataBase shareDataBase] insertQuestion:item];
        }else{
            YjyxWrongSubModel *model = self.selectArr[i];
            [[QuestionDataBase shareDataBase] insertWrong:model];
            
        }
    }
  [super viewWillDisappear:animated];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.selectArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QuestionPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    
    ChaperContentItem *item = self.selectArr[indexPath.row];
    cell.chaperItem = item;
    [cell setValueWithModel:item];
    
    cell.questionNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.deleteBtn.tag = indexPath.row + 200;
    cell.upButton.tag = indexPath.row + 400;
    cell.downButton.tag = indexPath.row + 600;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.upButton addTarget:self action:@selector(upButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)cellHeightChange:(NSNotification *)sender {

    QuestionPreviewCell *cell = [sender object];
    if (![self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height) {
        
        [self.cellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] floatValue];
    if (height == 0) {
        return 300;
    }
    return height;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneSubjectController *vc = [[OneSubjectController alloc] init];
    vc.selIndexPath = indexPath;
    vc.is_select = 1;
    if ([self.selectArr[indexPath.row] isKindOfClass:[YjyxWrongSubModel class]]) {
        YjyxWrongSubModel *model = self.selectArr[indexPath.row];
        
        NSString *str = @"choice";
        if (model.questiontype == 2) {
            str = @"blankfill";
        }
        vc.qtype = str;
        vc.w_id = [NSString stringWithFormat:@"%ld", (long)model.questionid];
    
        vc.wrongSubjectModel = model;
        
    }else{
        ChaperContentItem *model = self.selectArr[indexPath.row];
       
        NSString *str = @"choice";
        if ([model.subject_type isEqualToString:@"2"]) {
            str = @"blankfill";
        }
        vc.qtype = str;
        vc.w_id = [NSString stringWithFormat:@"%ld", (long)model.t_id];
     
        vc.chaperContentModel = model;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - delete
- (void)deleteBtnClick:(UIButton *)sender {
    
    
    if ([self.selectArr[sender.tag - 200] isKindOfClass:[ChaperContentItem class]]) {
        ChaperContentItem *model = self.selectArr[sender.tag - 200];
        model.tag = sender.tag;
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", (long)model.t_id] andQuestionType:model.subject_type andJumpType:@"1"];
        [self.selectArr removeObject:model];
        [self.tempArray addObject:model];
        // 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkTheNum" object:self];

    }else{
        YjyxWrongSubModel *model = self.selectArr[sender.tag - 200];
        model.tag = sender.tag;
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", (long)model.t_id] andQuestionType:[NSString stringWithFormat:@"%ld", model.questiontype] andJumpType:@"1"];
        [self.selectArr removeObject:model];
        [self.tempArray addObject:model];
        // 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkTheNum" object:self];

    }
   
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if ([[[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"1"] count] ==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    [self.tableView reloadData];
    
}

#pragma mark - 需要过程
// 全部需要解题步骤按钮的点击
- (IBAction)allRequireBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.allRequireBtn.backgroundColor = TEACHERCOLOR;
        for (int i = 0; i < _selectArr.count; i++) {
            if ([self.selectArr[i] isKindOfClass:[ChaperContentItem class]]) {
                ChaperContentItem *item = self.selectArr[i];
                item.isRequireProcess = YES;
            }else{
                YjyxWrongSubModel *model = self.selectArr[i];
                model.isRequireProcess = YES;
                
            }
        }
    }else{
        self.allRequireBtn.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < _selectArr.count; i++) {
            if ([self.selectArr[i] isKindOfClass:[ChaperContentItem class]]) {
                ChaperContentItem *item = self.selectArr[i];
                item.isRequireProcess = NO;
            }else{
                YjyxWrongSubModel *model = self.selectArr[i];
                model.isRequireProcess = NO;
                
            }
        }
    }
    [self.tableView reloadData];

    
}

// 恢复被删除的题目
- (IBAction)rebackBtnClick:(UIButton *)sender {
    if (self.tempArray.count != 0) {
        if ([self.tempArray.lastObject isKindOfClass:[ChaperContentItem class]]) {
            ChaperContentItem *model = self.tempArray.lastObject;
            NSInteger row = model.tag - 200;
            [self.selectArr insertObject:model atIndex:row];
            [self.tempArray removeLastObject];
            [[QuestionDataBase shareDataBase] insertQuestion:model];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:indexPath];
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
            
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //        [self.tableView reloadData];
        }else {
            
            YjyxWrongSubModel *model = self.tempArray.lastObject;
            NSInteger row = model.tag - 200;
            [self.selectArr insertObject:model atIndex:row];
            [self.tempArray removeLastObject];
            [[QuestionDataBase shareDataBase] insertWrong:model];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:indexPath];
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //        [self.tableView reloadData];
            
        }

    }else {
    
        [self.rebackBtn setBackgroundImage:[UIImage imageNamed:@"reback_icon_de"] forState:UIControlStateNormal];
        self.rebackBtn.userInteractionEnabled = NO;

        
    }
    if(self.tempArray.count == 0){
        [self.rebackBtn setBackgroundImage:[UIImage imageNamed:@"reback_icon_de"] forState:UIControlStateNormal];
        self.rebackBtn.userInteractionEnabled = NO;
    }
    
}

#pragma mark - 上移
- (void)upButtonClick:(UIButton *)sender {

    if (sender.tag - 400 != 0) {
        ChaperContentItem *item1 = self.selectArr[sender.tag - 400];
        ChaperContentItem *item2 = self.selectArr[sender.tag - 400 - 1];
        if (![item1.subject_type isEqualToString:item2.subject_type]) {
            [self.view makeToast:@"单选题要和填空题分开哦!" duration:1.0 position:SHOW_CENTER complete:nil];
        }else {
            NSUInteger index1 = sender.tag - 400;
            NSUInteger index2 = sender.tag - 400 - 1;
            [self.selectArr exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
            [[QuestionDataBase shareDataBase] deleteTemptable];
            for (ChaperContentItem *item in self.selectArr) {
                [[QuestionDataBase shareDataBase] insertTemp:item];
            }
            NSIndexPath *indexpath1 = [NSIndexPath indexPathForRow:index1 inSection:0];
            NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:index2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath1, indexpath2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }

    }else {
    
        [self.view makeToast:@"已经排在最前面了" duration:1 position:SHOW_CENTER complete:nil];
    }
    
}
#pragma mark - 下移
- (void)downButtonClick:(UIButton *)sender {

    if (sender.tag - 600 != self.selectArr.count - 1) {
        ChaperContentItem *item1 = self.selectArr[sender.tag - 600];
        ChaperContentItem *item2 = self.selectArr[sender.tag - 600 + 1];
        if (![item1.subject_type isEqualToString:item2.subject_type]) {
            [self.view makeToast:@"单选题要和填空题分开哦!" duration:1.0 position:SHOW_CENTER complete:nil];
        }else {
            NSUInteger index1 = sender.tag - 600;
            NSUInteger index2 = sender.tag - 600 + 1;
            [self.selectArr exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
            [[QuestionDataBase shareDataBase] deleteTemptable];
            
            for (ChaperContentItem *item in self.selectArr) {
                [[QuestionDataBase shareDataBase] insertTemp:item];
            }
            NSIndexPath *indexpath1 = [NSIndexPath indexPathForRow:index1 inSection:0];
            NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:index2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath1, indexpath2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    }else {
    
        [self.view makeToast:@"已经排在最后面了" duration:1 position:SHOW_CENTER complete:nil];
        
    }
    
}

#pragma mark - push
- (IBAction)configureBtnClick:(UIButton *)sender {
    
    ReleaseHomeWorkController *releaseVC = [[ReleaseHomeWorkController alloc] init];
    releaseVC.selectArr = self.selectArr;
    [self.navigationController pushViewController:releaseVC animated:YES];
    
}

#pragma mark - QuestionPreviewCellDelegate代理方法
- (void)questionPreviewCell:(QuestionPreviewCell *)cell isRequireProBtnClicked:(UIButton *)btn
{
    if(btn.selected == NO){
        self.allRequireBtn.selected = NO;
        self.allRequireBtn.backgroundColor = [UIColor whiteColor];
    }
}

- (void)checkTheDeletequestionNum {
    NSLog(@"执行了");
    if (self.tempArray.count != 0) {
        [self.rebackBtn setBackgroundImage:[UIImage imageNamed:@"reback_icon"] forState:UIControlStateNormal];
        self.rebackBtn.userInteractionEnabled = YES;
    }else {
        [self.rebackBtn setBackgroundImage:[UIImage imageNamed:@"reback_icon_de"] forState:UIControlStateNormal];
        self.rebackBtn.userInteractionEnabled = NO;
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
