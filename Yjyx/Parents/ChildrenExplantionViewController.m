//
//  ChildrenExplantionViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/11.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenExplantionViewController.h"

@interface ChildrenExplantionViewController ()

@end

@implementation ChildrenExplantionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self loadBackBtn];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initView
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    web.detectsPhoneNumbers = NO;

    NSString *str = @"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">";
    
    _explantionStr = [_explantionStr  stringByReplacingOccurrencesOfString:@"<p>" withString:str];

    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", _explantionStr];
    [web loadHTMLString:jsString baseURL:nil];
    [self.view addSubview:web];
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
