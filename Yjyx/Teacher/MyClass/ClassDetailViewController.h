//
//  ClassDetailViewController.h
//  Yjyx
//
//  Created by 刘少昌 on 16/4/28.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StuClassEntity, StuGroupEntity;
@interface ClassDetailViewController : UIViewController

@property (nonatomic, strong) StuClassEntity *model;

@property (strong, nonatomic) StuGroupEntity *groupModel;

@property (nonatomic, assign) NSInteger currentIndex;

@end
