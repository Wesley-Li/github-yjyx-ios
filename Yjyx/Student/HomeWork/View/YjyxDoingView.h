//
//  YjyxDoingView.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxDoingView;
@protocol DoingViewDelegate <NSObject>

- (void)doingView:(YjyxDoingView *)view nextWorkBtnIsClick:(UIButton *)btn;

@end
@interface YjyxDoingView : UIView

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *nextWorkBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *choiceAnswerView;

@property (assign, nonatomic) NSInteger count;
+ (instancetype)doingView;
@end
