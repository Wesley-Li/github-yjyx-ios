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
    
    UIImage *image = [UIImage imageNamed:@"isbuilding"];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    imageV.width = SCREEN_WIDTH - 80;
    imageV.height = image.size.height *imageV.width/image.size.width;
    imageV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    [self.view addSubview:imageV];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RCLabelReload" object:nil];
    [super viewWillDisappear:animated];
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
