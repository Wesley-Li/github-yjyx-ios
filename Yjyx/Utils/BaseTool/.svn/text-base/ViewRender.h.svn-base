//
//  ViewRender.h
//  ASR-S
//
//  Created by spinery on 14/12/14.
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+category.h"

typedef enum : NSUInteger {
    RenderStateWillOpen,
    RenderStateDidOpen,
    RenderStateWillClose,
    RenderStateDidClose,
} RenderState;

@protocol ViewRenderDelegate;
@interface ViewRender : NSObject

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIButton *backgroundButton;

@property (nonatomic, assign, readonly) RenderState currentState;
@property (nonatomic, assign) id <ViewRenderDelegate> delegate;

- (void)renderView:(UIView *)view withFrame:(CGRect)frame;
- (void)restoreRender;
- (BOOL)rendered;

@end

@protocol ViewRenderDelegate <NSObject>

- (void)dropdownViewDidTapBackgroundButton:(ViewRender *)dropdownView;

@end
