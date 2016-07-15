//
//  YjyxCommonNavController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxCommonNavController.h"
#import "YjyxDoingWorkController.h"
@interface YjyxCommonNavController ()

@end

@implementation YjyxCommonNavController
+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:RGBACOLOR(0, 229.0, 199.0, 1)];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [navBar setTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    YjyxCommonNavController* nvc = [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = (id)self;
    nvc.delegate = (id)self;
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1 || [viewController isKindOfClass:[YjyxDoingWorkController class]])
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL isPriview = NO;
    //    for (UIView *view in gestureRecognizer.view.subviews) {
    //        if ([view isKindOfClass:[ImgScrollView class]]) {
    //            isPriview = YES;
    //        }
    //    }
    if (isPriview) {
        return NO;
    }
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController); //the most important
    }
    return YES;
}
@end
