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
#import "TCustomView.h"

#define stuCondition @"stuConditionCell"
#define taskConditon @"taskConditonCell"
@interface TaskDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *choiceDataSource;
@property (nonatomic, strong) NSMutableArray *blankFillDataSource;
@property (nonatomic, strong) NSMutableArray *finishedArr;
@property (nonatomic, strong) NSMutableArray *unfinishedArr;

@property (nonatomic, assign) NSInteger choiceTaskCellHeight;
@property (nonatomic, assign) NSInteger blankfillTaskCellHeight;

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self readDataFromNetWork];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskConditionTableViewCell" bundle:nil] forCellReuseIdentifier:taskConditon];
    [self.tableView registerNib:[UINib nibWithNibName:@"StuConditionTableViewCell" bundle:nil] forCellReuseIdentifier:stuCondition];
    
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
    
    if (_choiceDataSource.count == 0 || _blankFillDataSource.count == 0) {
        return 2;
    }
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_choiceDataSource.count != 0 && _blankFillDataSource.count == 0) {
        if (indexPath.row == 0) {
            TaskConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
            cell.descriptionLabel.text = @"选择题正确率";
            [self cell:cell addSubViewsWithChoiceArr:self.choiceDataSource];
            return cell;
        }else {
        
            StuConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
            cell.descriptionLabel.text = @"作业上交情况";
            return cell;

        }
    }else if (_blankFillDataSource != 0 && _choiceDataSource == 0) {
        if (indexPath.row == 0) {
            TaskConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
            [self cell:cell addSubViewsWithBlankfillArr:self.blankFillDataSource];
            cell.descriptionLabel.text = @"填空题正确率";
            return cell;
        }else {
        
            StuConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
            cell.descriptionLabel.text = @"作业上交情况";
            return cell;
        }
        
    }else {
    
        if (indexPath.row == 0 || indexPath.row == 1) {
            TaskConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskConditon  forIndexPath:indexPath];
            
            if (indexPath.row == 0) {
                //            cell.choiceArr = self.choiceDataSource;
                cell.descriptionLabel.text = @"选择题正确率";
                
                [self cell:cell addSubViewsWithChoiceArr:self.choiceDataSource];
                //            [cell setValuesWithChoiceModelArr:self.choiceDataSource];
                return cell;
            }else {
                //            cell.blankArr = self.blankFillDataSource;
                [self cell:cell addSubViewsWithBlankfillArr:self.blankFillDataSource];
                cell.descriptionLabel.text = @"填空题正确率";
                return cell;
                
            }
            
        }else {
            
            StuConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stuCondition forIndexPath:indexPath];
            cell.descriptionLabel.text = @"作业上交情况";
            return cell;
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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithChoiceArr:(NSMutableArray *)arr {

    CGSize size = CGSizeMake(10, 25);
    CGFloat padding = 5;
    
    CGFloat TWidth = 60;
    CGFloat Theight = 80;
    
//    NSLog(@"%@", self.choiceArr);
    
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
        ChoiceModel *model = self.choiceDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TWidth, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, TWidth, TWidth)];
        imageView.image = [UIImage imageNamed:@"stu_pic"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 20, TWidth, TWidth);
        NSString *titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
        [button setTitle:[NSString stringWithFormat:@"%@", titleString] forState:UIControlStateNormal];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(handleButton) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:label];
        [taskView addSubview:imageView];
        [taskView addSubview:button];
        
        [cell.bg_view addSubview:taskView];
    }
    
    self.choiceTaskCellHeight = size.height + 80 + 30;

}

- (void)handleButton {

    NSLog(@"点击了题目");
}

- (void)cell:(TaskConditionTableViewCell *)cell addSubViewsWithBlankfillArr:(NSMutableArray *)arr{

    CGSize size = CGSizeMake(10, 25);
    CGFloat padding = 5;
    
    CGFloat TWidth = 60;
    CGFloat Theight = 80;
    
    //    NSLog(@"%@", self.choiceArr);
    
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
        imageView.image = [UIImage imageNamed:@"stu_pic"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 20, TWidth, TWidth);
        NSString *titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
        [button setTitle:[NSString stringWithFormat:@"%@", titleString] forState:UIControlStateNormal];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:label];
        [taskView addSubview:imageView];
        [taskView addSubview:button];
        
        [cell.bg_view addSubview:taskView];
    }
    
    self.blankfillTaskCellHeight = size.height + 80 + 30;

    

}

- (void)buttonClick {

    NSLog(@"点击了填空题");

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_blankFillDataSource.count == 0 && _choiceDataSource != 0) {
        if (indexPath.row == 0) {
            return _choiceTaskCellHeight;
        }else {
        
            return 400;
        }
        
    }else if (_blankFillDataSource.count != 0 && _choiceDataSource == 0) {
    
        if (indexPath.row == 0) {
            return _blankfillTaskCellHeight;
        }else {
        
            return 400;
        }
        
    }
    if (indexPath.row == 0) {
        return _choiceTaskCellHeight;
    }else if (indexPath.row == 1){
    
        return _blankfillTaskCellHeight;
    }else {
    
        return 400;
    }
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
