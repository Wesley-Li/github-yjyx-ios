//
//  RTSpinKitView.h
//  SpinKit
//
//  Created by Ramon Torres on 1/1/14.
//  Copyright (c) 2014 Ramon Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RTSpinKitViewStyle) {
    RTSpinKitViewStylePlane,
    RTSpinKitViewStyleBounce,
    RTSpinKitViewStyleWave,
    RTSpinKitViewStyleWanderingCubes,
    RTSpinKitViewStylePulse,
};

@interface RTSpinKitView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, assign) RTSpinKitViewStyle style;
@property (nonatomic, assign) BOOL stopped;

-(instancetype)initWithStyle:(RTSpinKitViewStyle)style;
-(instancetype)initWithStyle:(RTSpinKitViewStyle)style color:(UIColor*)color on:(UIView*)parent center:(CGPoint)point;

-(void)startAnimating;
-(void)stopAnimating;

@end
