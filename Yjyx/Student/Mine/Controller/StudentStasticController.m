//
//  StudentStasticController.m
//  Yjyx
//
//  Created by liushaochang on 16/8/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StudentStasticController.h"

@interface StudentStasticController ()

@end

@implementation StudentStasticController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的统计";
    
    UIImage *image = [UIImage imageNamed:@"isbuilding"];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    imageV.width = SCREEN_WIDTH - 80;
    imageV.height = image.size.height *imageV.width/image.size.width;
    imageV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);

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
