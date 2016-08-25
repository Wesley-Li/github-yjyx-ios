//
//  YjyxParentTabBarController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxParentTabBarController.h"
#import "YjyxParentTabBar.h"
@interface YjyxParentTabBarController ()

@end

@implementation YjyxParentTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    YjyxParentTabBar *tabbar = [[YjyxParentTabBar alloc] init];
    [self setValue:tabbar forKey:@"tabBar"];
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
