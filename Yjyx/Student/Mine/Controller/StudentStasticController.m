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
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的统计";
    
    UIImage *image = [UIImage imageNamed:@"isbuilding"];
    CGFloat width = SCREEN_WIDTH - 80;
    CGFloat height = image.size.height *width/image.size.width ;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, width, height)];

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
