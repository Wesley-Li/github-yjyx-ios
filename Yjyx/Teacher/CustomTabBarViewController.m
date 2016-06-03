//
//  CustomTabBarViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self configure];
}

#pragma mark - setting
- (void)configure {

    [self addCenterButtonWithImage:[UIImage imageNamed:@"publishhw"] selectedImage:[UIImage imageNamed:@"publishhw_click"]];
    self.delegate = self;
    self.selectedIndex = 0;
    

}

#pragma mark - addCenterButton
- (void)addCenterButtonWithImage:(UIImage *)buttonImage selectedImage:(UIImage *)selectedImage {

    _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customButton addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    _customButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    //  设定button大小为适应图片
    _customButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [_customButton setImage:buttonImage forState:UIControlStateNormal];
    [_customButton setImage:selectedImage forState:UIControlStateSelected];
    
    //  这个比较恶心  去掉选中button时候的阴影
    _customButton.adjustsImageWhenHighlighted=NO;
    
    /*
     *  核心代码：设置button的center 和 tabBar的 center 做对齐操作， 同时做出相对的上浮
     */
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0){
        _customButton.center = self.tabBar.center;
        CGPoint center = self.tabBar.center;
        center.y = center.y - 12;
        _customButton.center = center;
    }else{
        
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        _customButton.center = center;
    }
    
    self.tab_bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60)];
    _tab_bgImage.image = [UIImage imageNamed:@"tab_bg"];
    [self.view addSubview:_tab_bgImage];
//    [self.view sendSubviewToBack:tab_bgImage];
    
    [self.view insertSubview:_tab_bgImage atIndex:1];
    
    [self.view addSubview:_customButton];
    

}

-(void)pressChange:(id)sender
{
    self.selectedIndex = 2;
    _customButton.selected=YES;
}

#pragma mark - tabBar delegate
//  换页和button的状态关联上

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex == 2) {
        _customButton.selected=YES;
    }else
    {
        _customButton.selected=NO;
    }
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
