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
#import "YjyxCommonNavController.h"
@interface YjyxPMemberCenterViewController ()<ZLScrollingDelegate>
{
    ZLScrolling *zlScroll;
    NSInteger jumpType; // 1 代表学生端会员中心  0 代表家长端
}
@end

@implementation YjyxPMemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    productAry = [[NSMutableArray alloc] init];
    
    
    NSArray *imageAry = @[@"memberCenter_bg1",@"memberCenter_bg2",@"memberCenter_bg3"];
    zlScroll = [[ZLScrolling alloc] initWithCurrentController:self frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*179/320) photos:imageAry placeholderImage:nil];
    zlScroll.timeInterval = 3;
    zlScroll.delegate = self;
    
    [self.view addSubview:zlScroll.view];
    if([self.navigationController isKindOfClass:[YjyxCommonNavController class]]){
        jumpType = 1;
        [self getStudentProductList];
    }else{
        [self getProductList];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (jumpType != 1) {
        [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    
}
/*
获取商品列表
*/
-(void)getProductList
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"list",@"action",@"0",@"firstid",@"0",@"lastid",@"ASC",@"direction", nil];
    [[YjxService sharedInstance] getProductList:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            
            NSLog(@"%@", result);
            
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                for (int i = 0; i<[[result objectForKey:@"products"] count]; i++) {
                    ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:[[result objectForKey:@"products"] objectAtIndex:i]];
                    
                    if ([entity.status isEqual:@1]) {
                        // status 为1的代表正常的,为2代表下架的
                        [productAry addObject:entity];
                    }
                    
                    
                }
                
                
                [self initView];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}
/*
 获取学生商品列表
 */
-(void)getStudentProductList
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"list",@"action",@"0",@"firstid",@"0",@"lastid",@"ASC",@"direction", nil];
    [[YjxService sharedInstance] getStudentProductList:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            
            NSLog(@"%@", result);
            
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                for (int i = 0; i<[[result objectForKey:@"products"] count]; i++) {
                    ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:[[result objectForKey:@"products"] objectAtIndex:i]];
                    
                    if ([entity.status isEqual:@1]) {
                        // status 为1的代表正常的,为2代表下架的
                        [productAry addObject:entity];
                    }
                    
                    
                }
                
                
                [self initView];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

/*
页面布局
*/

- (void)initView
{
    CGFloat margin = 15;
    CGFloat height = (SCREEN_WIDTH - margin * 4)/3  ;
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.frame = CGRectMake(0, SCREEN_WIDTH*179/320, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SCREEN_WIDTH*179/320);
    [self.view addSubview:scrollV];
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.contentSize = CGSizeMake(SCREEN_WIDTH ,margin + (height + 25) * (productAry.count / 3));
    for (int i=0; i < [productAry count]; i++) {
        ProductEntity *entity = [productAry objectAtIndex:i];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake( margin +(margin+ height)*(i % 3) , margin + (margin + (height + 25)) * (i / 3), height, height + 25)];
        [image setImageWithURL:[NSURL URLWithString:entity.img] placeholderImage:[UIImage imageNamed:@"member_kexue"]];
        image.tag = i;
        [scrollV addSubview:image];
        NSLog(@"%@", NSStringFromCGRect(image.frame));
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
    detail.jumpType = jumpType;
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
