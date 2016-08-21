//
//  YiTeachCustomView.h
//  Yjyx
//
//  Created by liushaochang on 16/8/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiTeachCustomView : UIView

//@property (nonatomic, strong) UIImageView *imageview;
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIImageView *indicatorImageview;

@property (assign, nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageview;

@end
