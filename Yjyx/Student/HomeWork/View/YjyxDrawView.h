//
//  YjyxDrawView.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/11.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxDrawView : UIView

// 撤销
- (void)revoke;

// 前进
- (void)goForward;

// 清空
- (void)clear;
@end
