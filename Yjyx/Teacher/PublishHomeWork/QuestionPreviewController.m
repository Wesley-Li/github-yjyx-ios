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
    
    NSLog(@"%@", self.selectArr);
    
    self.configurePublishBtn.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
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
    ChaperContentItem *item = self.selectArr[indexPath.row];
    [cell setValueWithModel:item];
    
    cell.questionNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.deleteBtn.tag = indexPath.row + 200;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChaperContentItem *item = self.selectArr[indexPath.row];
    return item.cellHeight - 40;
}

#pragma mark - delete
- (void)deleteBtnClick:(UIButton *)sender {

    ChaperContentItem *model = self.selectArr[sender.tag - 200];
    [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", model.t_id] andQuestionType:model.subject_type];
    [self.selectArr removeObject:model];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if ([[[QuestionDataBase shareDataBase] selectAllQuestion] count] ==0) {
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
