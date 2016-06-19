//
//  WrongViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongViewController.h"
#import "ReleaseHomeWorkController.h"
@interface WrongViewController ()

@end

@implementation WrongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
