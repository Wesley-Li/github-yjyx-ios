//
//  YjyxShopMallViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/5/17.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxShopMallViewController.h"

@interface YjyxShopMallViewController ()

@end

@implementation YjyxShopMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.title = @"商城";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RCLabelReload" object:nil];
    [super viewWillDisappear:YES];
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
