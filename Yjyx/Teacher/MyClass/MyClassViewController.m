//
//  MyClassViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MyClassViewController.h"
#import "ClassDetailViewController.h"
#import "StuDataBase.h"
#import "StuClassEntity.h"
#import "MJRefresh.h"
#import "YjyxOverallData.h"


@interface MyClassViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *gradeArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyClassViewController

- (NSMutableArray *)dataSource {

    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)gradeArr {

    if (!_gradeArr) {
        self.gradeArr = [NSMutableArray array];
    }
    return _gradeArr;
}

- (NSMutableArray *)titleArr {

    if (!_titleArr) {
        self.titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (void)viewWillAppear:(BOOL)animated {

    
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[[StuDataBase shareStuDataBase] selectAllClass] mutableCopy];
    self.gradeArr = [[[YjyxOverallData sharedInstance].teacherInfo.school_classes JSONValue] mutableCopy];
    
    
//    NSLog(@"%@", NSHomeDirectory());
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.navigationItem.title = @"我的班级";

    [self refreshAll];
//    [self.classListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
    
   
}
// 刷新
- (void)refreshAll {
    
    // 头部刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
  
}
- (void)headerRefresh
{
    self.dataSource = [[[StuDataBase shareStuDataBase]selectAllClass] mutableCopy];
    self.gradeArr = [[[YjyxOverallData sharedInstance].teacherInfo.school_classes JSONValue] mutableCopy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}
#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"MyClass";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    StuClassEntity *model = self.dataSource[indexPath.row];
    
    for (NSArray *arr in _gradeArr) {
        if ([model.gradeid isEqual:arr[2]]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", arr[3], arr[1]];
            [self.titleArr addObject:cell.textLabel.text];
        }
    }
    
    
//    cell.textLabel.text = model.name;
    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"邀请码:%@", [numberF stringFromNumber: model.invitecode]];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ClassDetailViewController *detailVC = [[ClassDetailViewController alloc] initWithNibName:@"ClassDetailViewController" bundle:nil];
    detailVC.model = self.dataSource[indexPath.row];
    detailVC.currentIndex = indexPath.row;
    detailVC.navigationItem.title = self.titleArr[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
