//
//  YjyxParentTabBar.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxParentTabBar.h"

@implementation YjyxParentTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#039c78"];
        [self addSubview:view];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    int j = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[NSClassFromString(@"UITabBarButton") class]]) {
            view.frame = CGRectMake(j * ((SCREEN_WIDTH - 2) / 2 + 2), 0, (SCREEN_WIDTH - 2) / 2, 49);
            j++;
        }else if ([view isKindOfClass:[UIView class]]) {
            view.width = 2;
            view.centerX = SCREEN_WIDTH / 2;
            view.height = 26;
            view.centerY = 49 / 2;
        }
    }
}
@end
