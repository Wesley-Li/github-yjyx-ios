//
//  YjyxPayDetailViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"
#import "RCLabel.h"

@interface YjyxPayDetailViewController : BaseViewController
{
    IBOutlet UIButton *payBtn;
    UIView *productView;
    RCLabel *contentLb;
    IBOutlet UILabel *titleLb;
}

@property (strong,nonatomic) ProductEntity *productEntity;
@property (weak,nonatomic) IBOutlet UIView *detailView;
@property (assign, nonatomic) NSInteger jumpType;
@end
