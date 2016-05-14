//
//  ViewRender.m
//  ASR-S
//
//  Created by spinery on 14/12/14.
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import "ViewRender.h"

#define kDefaultAnimationDuration           0.25
#define kDefaultDepthStyleClosedScale       0.85
#define kDefaultBlurRadius                  5
#define kDefaultBlackMaskAlpha              0.5

@implementation ViewRender

- (id)init
{
    self = [super init];
    if (self) {
        _currentState = RenderStateDidClose;
    }
    return self;
}


#pragma mark - PUBLIC METHOD
- (void)renderView:(UIView *)view withFrame:(CGRect)frame
{
    if (_currentState == RenderStateDidClose)
    {
        _currentState = RenderStateWillOpen;
        
        // Setup menu in view
        [self renderInView:view withFrame:frame];
        
        // Animate content view controller
        [self addContentAnimationForMenuState:_currentState];
        
        // Finish showing
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _currentState = RenderStateDidOpen;
        });
    }
}

- (void)restoreRender
{
    if (_currentState == RenderStateDidOpen)
    {
        _currentState = RenderStateWillClose;
        
        // Animate content view controller
        [self addContentAnimationForMenuState:_currentState];
        
        // Finish hiding
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.backgroundButton removeFromSuperview];
            [self.contentView removeFromSuperview];
            [self.mainView removeFromSuperview];
            
            _currentState = RenderStateDidClose;
        });
    }
}

- (BOOL)rendered
{
    return (_currentState == RenderStateDidOpen);
}


#pragma mark - PRIVATE
- (void)renderInView:(UIView *)view withFrame:(CGRect)frame
{
    // Prepare content image
    CGSize contentSize = [view bounds].size;
    UIImage *blurredCapturedImage = [[view viewShot] blurredWithRadius:kDefaultBlurRadius iterations:5 tintColor:[UIColor clearColor]];
    
    // Main View
    if (!self.mainView) {
        self.mainView = [[UIScrollView alloc] init];
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    [self.mainView setFrame:frame];
    [view addSubview:self.mainView];
    
    // Content Image View
    if (!self.contentView) {
        self.contentView = [[UIImageView alloc] init];
        self.contentView.backgroundColor = [UIColor blackColor];
        self.contentView.contentMode = UIViewContentModeCenter;
    }
    self.contentView.image = blurredCapturedImage;
    [self.contentView setFrame:CGRectMake(-contentSize.width * (1 - kDefaultDepthStyleClosedScale),
                                          -self.mainView.frame.origin.y - contentSize.height * (1 - kDefaultDepthStyleClosedScale),
                                          contentSize.width * (3 - 2 * kDefaultDepthStyleClosedScale),
                                          contentSize.height * (3 - 2 * kDefaultDepthStyleClosedScale))];
    [self.mainView addSubview:self.contentView];
    
    //点击还原
    if (!self.backgroundButton) {
        self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kDefaultBlackMaskAlpha];
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.backgroundButton setFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    [self.mainView addSubview:self.backgroundButton];
}

- (void)backgroundButtonTapped:(id)sender
{
    [self restoreRender];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownViewDidTapBackgroundButton:)]) {
            [self.delegate dropdownViewDidTapBackgroundButton:self];
        }
    });
}


#pragma mark - KEYFRAME ANIMATION

- (void)addContentAnimationForMenuState:(RenderState)state
{
    CAKeyframeAnimation *scaleBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleBounceAnim.duration = kDefaultAnimationDuration;
    scaleBounceAnim.delegate = self;
    scaleBounceAnim.removedOnCompletion = NO;
    scaleBounceAnim.fillMode = kCAFillModeForwards;
    scaleBounceAnim.values = [self contentTransformValuesForMenuState:state];
    scaleBounceAnim.timingFunctions = [self contentTimingFunctionsForMenuState:state];
    scaleBounceAnim.keyTimes = [self contentKeyTimesForMenuState:state];
    
    [self.contentView.layer addAnimation:scaleBounceAnim forKey:nil];
    [self.contentView.layer setValue:[scaleBounceAnim.values lastObject] forKeyPath:@"transform"];
}


#pragma mark - PROPERTIES FOR KEYFRAME ANIMATION
- (NSArray *)contentTransformValuesForMenuState:(RenderState)state
{
    CATransform3D contentTransform = self.contentView.layer.transform;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCATransform3D:contentTransform]];
    
    if (state == RenderStateWillOpen || state == RenderStateDidOpen)
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(contentTransform, kDefaultDepthStyleClosedScale-0.05, kDefaultDepthStyleClosedScale-0.05, kDefaultDepthStyleClosedScale-0.05)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(contentTransform, kDefaultDepthStyleClosedScale, kDefaultDepthStyleClosedScale, kDefaultDepthStyleClosedScale)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(contentTransform, 0.95, 0.95, 0.95)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    }
    
    return values;
}

- (NSArray *)contentKeyTimesForMenuState:(RenderState)state
{
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.5]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    return keyTimes;
}

- (NSArray *)contentTimingFunctionsForMenuState:(RenderState)state
{
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}

@end
