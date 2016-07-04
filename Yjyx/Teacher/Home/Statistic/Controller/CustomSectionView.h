//
//  CustomSectionView.h
//  Yjyx
//
//  Created by liushaochang on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSectionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@property (assign, nonatomic) NSInteger section;

@end
