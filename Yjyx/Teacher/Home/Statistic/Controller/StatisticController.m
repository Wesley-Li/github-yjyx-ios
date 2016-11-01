//
//  StatisticController.m
//  Yjyx
//
//  Created by liushaochang on 16/6/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StatisticController.h"

#import "StudentViewController.h"
#import "TaskStatisticViewController.h"
#import "WrongSubjectController.h"


@interface StatisticController ()



@end

@implementation StatisticController


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置导航栏
    self.navigationItem.title = @"统计";
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(14.0, 115.0, 221.0, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
}

#pragma mark -IBAction

#pragma mark -点击学生按钮
- (IBAction)stuBtnClick:(UIButton *)sender {
    
    StudentViewController *stuVC = [[StudentViewController alloc] init];
    [self.navigationController pushViewController:stuVC animated:YES];
    
}

#pragma mark -点击任务按钮
- (IBAction)taskBtnClick:(UIButton *)sender {
    
    TaskStatisticViewController *taskVC = [[TaskStatisticViewController alloc] init];
    [self.navigationController pushViewController:taskVC animated:YES];
    
}


#pragma mark -点击错题库按钮
- (IBAction)wrongQuestionBtnClick:(UIButton *)sender {
    
    WrongSubjectController *wrongVC = [[WrongSubjectController alloc] initWithNibName:@"WrongSubjectController" bundle:nil];
//    wrongVC.title = @"错题榜";
    [self.navigationController pushViewController:wrongVC animated:YES];

    
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
