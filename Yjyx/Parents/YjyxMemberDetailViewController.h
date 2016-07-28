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
    IBOutlet UILabel *titleLb;
}

@property (strong,nonatomic) ProductEntity *productEntity; // 产品类型
@property (assign, nonatomic) NSInteger jumpType; //  从上个界面跳转类型
@property (weak,nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) NSNumber *subjectid;


@end
