//
//  YjyxMemberDetailViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/4/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"
#import "RCLabel.h"

@interface YjyxMemberDetailViewController : BaseViewController
{
    IBOutlet UIButton *trailBtn;
    IBOutlet UIButton *openBtn;
    IBOutlet UIButton *payBtn;
    UIView *productView;
    RCLabel *contentLb;
}

@property (strong,nonatomic) ProductEntity *productEntity;
@property (weak,nonatomic) IBOutlet UIView *detailView;

@end
