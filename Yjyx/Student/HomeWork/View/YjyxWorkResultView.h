//
//  YjyxWorkResultView.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxWorkResultView;
@protocol WorkResultDelegate <NSObject>

- (void)workResultView:(YjyxWorkResultView *)view workNumBtnClick:(UIButton *)btn;
- (void)workResultView:(YjyxWorkResultView *)view sumbitBtnClick:(UIButton *)btn;
- (void)workResultView:(YjyxWorkResultView *)view ;
@end
@interface YjyxWorkResultView : UIView

@property (assign, nonatomic) NSInteger workTotalNum;

@property (weak, nonatomic) id<WorkResultDelegate> delegate;
- (void)setWorkType:(NSMutableArray *)workType andArr:(NSMutableArray *)arr;
@end
