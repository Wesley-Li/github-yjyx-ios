//
//  YjyxWorkDetailCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjyxTodayWorkModel;
@interface YjyxWorkDetailCell : UITableViewCell

@property (strong, nonatomic) YjyxTodayWorkModel *todayWorkModel;

@property (strong, nonatomic) YjyxTodayWorkModel *OneSubjectModel;
@end
