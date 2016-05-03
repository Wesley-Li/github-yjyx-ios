//
//  PublishHomeworkViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "PublishHomeworkViewController.h"

#import "SmartViewController.h"
#import "BookViewController.h"
#import "TestViewController.h"
#import "MidTestViewController.h"
#import "CameraViewController.h"
#import "PrivateViewController.h"

@interface PublishHomeworkViewController ()

@end

@implementation PublishHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"发布作业";
}

// 点击智能出题
- (IBAction)handleSmartBtn:(UIButton *)sender {
    
    SmartViewController *smartVC = [[SmartViewController alloc] initWithNibName:@"SmartViewController" bundle:nil];
    smartVC.title = @"智能出题";
    [self.navigationController pushViewController:smartVC animated:YES];
    
}

// 点击教材同步
- (IBAction)handleBookBtn:(UIButton *)sender {
    
    BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    bookVC.title = @"教材同步";
    [self.navigationController pushViewController:bookVC animated:YES];

}

// 点击套卷出题
- (IBAction)handleTestBtn:(UIButton *)sender {
    
    TestViewController *testVC = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    testVC.title = @"套卷出题";
    [self.navigationController pushViewController:testVC animated:YES];

}

// 点击中考复习
- (IBAction)handleMidTestBtn:(UIButton *)sender {
    
    MidTestViewController *midTestVC = [[MidTestViewController alloc] initWithNibName:@"MidTestViewController" bundle:nil];
    midTestVC.title = @"中考复习";
    [self.navigationController pushViewController:midTestVC animated:YES];
}

// 点击拍照出题
- (IBAction)handleCameraBtn:(UIButton *)sender {
    
    CameraViewController *cameraVC = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    cameraVC.title = @"拍照出题";
    [self.navigationController pushViewController:cameraVC animated:YES];
}

// 点击私有题库
- (IBAction)handlePrivateBtn:(UIButton *)sender {
    
    PrivateViewController *privateVC = [[PrivateViewController alloc] initWithNibName:@"PrivateViewController" bundle:nil];
    privateVC.title = @"私有题库";
    [self.navigationController pushViewController:privateVC animated:YES];
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
