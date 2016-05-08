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
#import "PNChart.h"

#define stuCondition @"stuConditionCell"
@interface TaskDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *choiceDataSource;
@property (nonatomic, strong) NSMutableArray *blankFillDataSource;

@end

@implementation TaskDetailTableViewController

- (NSMutableArray *)choiceDataSource {

    if (!_choiceDataSource) {
        self.choiceDataSource = [NSMutableArray array];
    }
    return _choiceDataSource;
}

- (NSMutableArray *)blankFillDataSource {

    if (!_blankFillDataSource) {
        self.blankFillDataSource = [NSMutableArray array];
    }
    return _blankFillDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.taskModel.t_description;
    
    [self readDataFromNetWork];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskConditionTableViewCell" bundle:nil] forCellReuseIdentifier:stuCondition];
    
}

// 网络请求
- (void)readDataFromNetWork {

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettasksubmitdetail", @"action", self.taskModel.t_id, @"taskid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_SCAN_THE_TASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"%@", responseObject);
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
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stuCondition  forIndexPath:indexPath];
    
    cell.choiceArr = self.choiceDataSource;
    cell.descriptionLabel.text = @"选择题正确率";
    
    [self cell:cell addSubViewsWithChoiceArr:self.choiceDataSource];
    [cell setValuesWithChoiceModelArr:self.choiceDataSource];
    
    return cell;
}

- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithChoiceArr:(NSMutableArray *)arr {

    CGSize size = CGSizeMake(5, 50);
    CGFloat padding = 5;
    CGFloat width = cell.bg_label.width;
    CGFloat TWidth = 60;
    CGFloat Theight = 80;
    
//    NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < arr.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        size.width += TWidth + padding;
        
        if (width - size.width < TWidth + padding) {
            size.height += Theight;
        }
        taskView.frame = CGRectMake(size.width, size.height, TWidth, Theight);
        
//        taskView.backgroundColor = [UIColor redColor];
        ChoiceModel *model = self.choiceDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TWidth, 20)];
        PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 20, TWidth, 60) total:@100 current:@80 clockwise:YES];
        
        
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        circleChart.backgroundColor = [UIColor lightGrayColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart strokeChart];
        [taskView addSubview:label];
        [taskView addSubview:circleChart];
        
        
        [cell.contentView addSubview:taskView];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 200;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
