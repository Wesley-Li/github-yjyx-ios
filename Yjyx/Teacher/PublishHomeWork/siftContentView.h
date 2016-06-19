//
//  siftContentView.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol siftContentViewDelegate <NSObject>

- (void)configurePamra;// 配置参数

@end

@interface siftContentView : UIView

@property (nonatomic, copy) NSString *questionType;// 题目类型
@property (nonatomic, copy) NSString *level;// 难度

@property (nonatomic, weak) id<siftContentViewDelegate> delegate;


+ (instancetype)siftContentViewFromXib;

@end
