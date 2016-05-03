//
//  YjyxPMemberCenterViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxPMemberCenterViewController.h"
#import "YjxService.h"
#import "ProductEntity.h"
#import "YjyxMemberDetailViewController.h"
#import "ZLScrolling.h"

@interface YjyxPMemberCenterViewController ()<ZLScrollingDelegate>
{
    ZLScrolling *zlScroll;
}
@end

@implementation YjyxPMemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员介绍";
    productAry = [[NSMutableArray alloc] init];
    [self getProductList];
    
    NSArray *imageAry = @[@"memberCenter_bg1",@"memberCenter_bg2",@"memberCenter_bg3"];
    zlScroll = [[ZLScrolling alloc] initWithCurrentController:self frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*179/320) photos:imageAry placeholderImage:nil];
    zlScroll.timeInterval = 3;
    zlScroll.delegate = self;
    
    [self.view addSubview:zlScroll.view];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
}
/*
获取商品列表
*/
-(void)getProductList
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"list",@"action",@"0",@"firstid",@"0",@"lastid",@"ASC",@"direction", nil];
    [[YjxService sharedInstance] getProductList:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                for (int i = 0; i<[[result objectForKey:@"products"] count]; i++) {
                    ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:[[result objectForKey:@"products"] objectAtIndex:i]];
                    [productAry addObject:entity];
                }
                [self initView];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

/*
页面布局
*/

- (void)initView
{
    CGFloat height = SCREEN_WIDTH/3 -20 ;
    for (int i=0; i < [productAry count]; i++) {
        ProductEntity *entity = [productAry objectAtIndex:i];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(SCREEN_WIDTH/3), SCREEN_WIDTH*179/320 + 20, height, height + 25)];
        [image setImageWithURL:[NSURL URLWithString:entity.img] placeholderImage:[UIImage imageNamed:@"member_kexue"]];
        image.tag = i;
        [self.view addSubview:image];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subjectSelect:)];
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
    }
}

- (void)subjectSelect:(UITapGestureRecognizer *)gestureRecognizer
{
    ProductEntity *entity = [productAry objectAtIndex:gestureRecognizer.view.tag];
    YjyxMemberDetailViewController *detail = [[YjyxMemberDetailViewController alloc] init];
    detail.title = [entity.subject_name stringByAppendingString:@"会员"];
    detail.productEntity = entity;
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -ZLScrollingDelegate
-(void)zlScrolling:(ZLScrolling *)zlScrolling clickAtIndex:(NSInteger)index
{
    
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
