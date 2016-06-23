//
//  StudentViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/6/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StudentViewController.h"

#import "StuDataBase.h"
#import "StudentEntity.h"
#import "StuClassEntity.h"
#import "ClassCustomTableViewCell.h"
#import "StatisticClassCell.h"

#define iD @"StatisticClassCell"
#define identi @"ClassCustomTableViewCell"

@interface StudentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 获取班级信息
@property (strong, nonatomic) NSMutableArray *classArr;
// 保存所有学生信息
@property (strong, nonatomic) NSMutableArray *stuArr;
// 保存班级里的学生信息
@property (strong, nonatomic) NSMutableArray *classStuArr;

@end

@implementation StudentViewController


- (NSMutableArray *)classArr
{
    if (_classArr == nil) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

- (NSMutableArray *)stuArr
{
    if (_stuArr == nil) {
        _stuArr = [NSMutableArray array];
    }
    return _stuArr;
}

- (NSMutableArray *)classStuArr
{
    if (_classStuArr == nil) {
        _classStuArr = [NSMutableArray array];
    }
    return _classStuArr;
}


- (void)viewWillAppear:(BOOL)animated {

    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置导航栏
    self.navigationItem.title = @"学生统计";
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
    // 获取数据源
    self.classArr = [[StuDataBase shareStuDataBase] selectAllClass];
    NSLog(@"%@", self.classArr);
    for (StuClassEntity *stuClassModel in self.classArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuClassModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            [self.stuArr addObject:stuModel];
            [tempArr addObject:stuModel];
        }
        [self.classStuArr addObject:tempArr];
    }
    
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StatisticClassCell class]) bundle:nil] forCellReuseIdentifier:iD];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassCustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:identi];
    
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
