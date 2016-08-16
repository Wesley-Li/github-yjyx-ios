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
