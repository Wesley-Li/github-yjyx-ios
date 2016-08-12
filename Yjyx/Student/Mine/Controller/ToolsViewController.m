//
//  ToolsViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/8/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ToolsViewController.h"

@interface ToolsViewController ()

@end

@implementation ToolsViewController


- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"常用工具";
    UIImage *image = [UIImage imageNamed:@"isbuilding"];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, image.size.height*SCREEN_WIDTH/image.size.width)];
    imageV.image = image;
    [self.view addSubview:imageV];
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
