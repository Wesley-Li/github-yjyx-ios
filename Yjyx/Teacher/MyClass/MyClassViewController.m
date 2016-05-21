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


@interface MyClassViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MyClassViewController

//- (NSMutableArray *)dataSource {
//
//    if (!_dataSource) {
//        self.dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}

- (void)viewWillAppear:(BOOL)animated {

    self.dataSource = [[[StuDataBase shareStuDataBase]selectAllClass] mutableCopy];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    

    self.title = @"我的班级";
    
//    [self.classListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
   
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
    
    cell.textLabel.text = model.name;
    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"邀请码:%@", [numberF stringFromNumber: model.invitecode]];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ClassDetailViewController *detailVC = [[ClassDetailViewController alloc] initWithNibName:@"ClassDetailViewController" bundle:nil];
    detailVC.model = self.dataSource[indexPath.row];
    detailVC.currentIndex = indexPath.row;
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
