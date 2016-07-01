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
@interface QuestionPreviewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *configurePublishBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;




@end

@implementation QuestionPreviewController


- (NSMutableArray *)selectArr {

    if (!_selectArr) {
        self.selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览作业";
    NSLog(@"%@", self.selectArr);
    [self loadBackBtn];
    self.configurePublishBtn.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.scrollIndicatorInsets =  UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionPreviewCell" bundle:nil] forCellReuseIdentifier:kIndentifier];
    
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.selectArr[indexPath.row] isKindOfClass:[ChaperContentItem class]]) {
        ChaperContentItem *item = self.selectArr[indexPath.row];
        [cell setValueWithModel:item];
    }else{
        YjyxWrongSubModel *model = self.selectArr[indexPath.row];
        [cell setWrongWithModel:self.selectArr[indexPath.row]];
        
    }
    
    
    cell.questionNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.deleteBtn.tag = indexPath.row + 200;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChaperContentItem *item = self.selectArr[indexPath.row];
    return item.cellHeight - 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneSubjectController *vc = [[OneSubjectController alloc] init];
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
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", (long)model.t_id] andQuestionType:model.subject_type andJumpType:@"1"];
        [self.selectArr removeObject:model];
    }else{
        YjyxWrongSubModel *model = self.selectArr[sender.tag - 200];
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", (long)model.t_id] andQuestionType:[NSString stringWithFormat:@"%ld", model.questiontype] andJumpType:@"1"];
        [self.selectArr removeObject:model];
    }
   
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if ([[[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"1"] count] ==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    [self.tableView reloadData];
    
}

#pragma mark - push
- (IBAction)configureBtnClick:(UIButton *)sender {
    
    ReleaseHomeWorkController *releaseVC = [[ReleaseHomeWorkController alloc] init];
    
    [self.navigationController pushViewController:releaseVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
