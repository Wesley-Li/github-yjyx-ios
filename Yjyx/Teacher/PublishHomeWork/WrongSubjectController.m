//
//  WrongSubjectController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongSubjectController.h"

@interface WrongSubjectController ()

@end

@implementation WrongSubjectController
#pragma mark - view的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // 重写导航栏的返回按钮
    [self loadBackBtn];
    // 加载错题数据
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 私有方法
- (void)loadData
{
//    AFHTTPSessionManager
}


@end
