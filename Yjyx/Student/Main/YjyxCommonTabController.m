//
//  YjyxCommonTabController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxCommonTabController.h"

@interface YjyxCommonTabController ()

@end

@implementation YjyxCommonTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
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
