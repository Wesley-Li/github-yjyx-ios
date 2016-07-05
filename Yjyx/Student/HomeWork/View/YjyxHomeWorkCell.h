//
//  YjyxHomeWorkCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjyxHomeDataModel, YjyxHomeWrongModel;
@interface YjyxHomeWorkCell : UITableViewCell

@property (strong, nonatomic) YjyxHomeDataModel *homeWorkModel;

@property (strong, nonatomic) YjyxHomeWrongModel *homeWrongModel;
@end
