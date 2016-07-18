//
//  YjyxYiTeachController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxYiTeachController.h"

@interface YjyxYiTeachController ()

@end

@implementation YjyxYiTeachController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"亿教";
    UILabel *label = [[UILabel alloc] init];
    label.text = @"敬请期待...";
    [label sizeToFit ];
    label.center = self.view.center;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
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
