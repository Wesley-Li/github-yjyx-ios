//
//  YjyxSearchView.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxSearchView;
@protocol SearchViewDelegate <NSObject>

- (void)searchView:(YjyxSearchView *)view searchBtnIsClickAndBeginTime:(NSNumber *)beginT endTime:(NSNumber *)endT andWorkType:(NSNumber *)workType;

@end
@interface YjyxSearchView : UIView

@property (weak, nonatomic) id<SearchViewDelegate> delegate;

+ (instancetype)searchView;
@end
