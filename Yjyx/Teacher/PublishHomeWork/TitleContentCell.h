//
//  TitleContentCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OneSubjectModel;
@interface TitleContentCell : UITableViewCell
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) OneSubjectModel *model;
@end
