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
#import "StuGroupEntity.h"


@interface MyClassViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *gradeArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *groupArr;

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
    
    
    self.dataSource = [[[StuDataBase shareStuDataBase] selectAllClass] mutableCopy];
    
    
    if (self.dataSource.count == 0) {
        [self.view makeToast:@"您暂时没有班级" duration:1.0 position:SHOW_CENTER complete:nil];
    }
    
    self.gradeArr = [[[YjyxOverallData sharedInstance].teacherInfo.school_classes JSONValue] mutableCopy];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSLog(@"%@", NSHomeDirectory());
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.groupArr = [[StuDataBase shareStuDataBase] selectAllGroup];
    
    self.navigationItem.title = @"我的班级";

    [self refreshAll];
//    [self.classListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}
// 刷新
- (void)refreshAll {
    
    // 头部刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
  
}
- (void)headerRefresh
{
    self.dataSource = [[[StuDataBase shareStuDataBase]selectAllClass] mutableCopy];
    self.groupArr = [[StuDataBase shareStuDataBase] selectAllGroup];
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
    NSLog(@"%ld", self.groupArr.count);

    return self.dataSource.count + self.groupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"MyClass";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row < self.dataSource.count) {
        StuClassEntity *model = self.dataSource[indexPath.row];
        
        if ([model.name containsString:@"年级"]) {
            
            cell.textLabel.text = model.name;
            [self.titleArr addObject:model.name];
        }else {
            
            for (NSArray *arr in _gradeArr) {
                if ([model.gradeid isEqual:arr[2]]) {
                    NSString *titleString = [NSString stringWithFormat:@"%@%@", arr[3], arr[1]];
                    [self.titleArr addObject:titleString];
                    
                }
                
            }
            
        }
        
        
        cell.textLabel.text = self.titleArr[indexPath.row];
        
        
        //    cell.textLabel.text = model.name;
        if(!(cell.textLabel.text == nil)){
            [self.titleArr addObject:cell.textLabel.text];
        }
        
        
        NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"邀请码:%@", [numberF stringFromNumber: model.invitecode]];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];

           }else{
        NSLog(@"%ld, %ld", indexPath.row, self.dataSource.count);
        StuGroupEntity *model = self.groupArr[indexPath.row - self.dataSource.count];
        cell.textLabel.text = model.name;
    }
   
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataSource.count != 0) {
        
        ClassDetailViewController *detailVC = [[ClassDetailViewController alloc] initWithNibName:@"ClassDetailViewController" bundle:nil];
        if (indexPath.row < self.dataSource.count) {
           detailVC.model = self.dataSource[indexPath.row];
           detailVC.navigationItem.title = self.titleArr[indexPath.row];
        }else{
            detailVC.groupModel = self.groupArr[indexPath.row - self.dataSource.count];
        }
        
        detailVC.currentIndex = indexPath.row;
        
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    
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
