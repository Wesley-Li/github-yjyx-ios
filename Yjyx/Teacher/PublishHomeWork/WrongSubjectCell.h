//
//  WrongSubjectCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjyxWrongSubModel;
@interface WrongSubjectCell : UITableViewCell
// 错题模型
@property (strong, nonatomic) YjyxWrongSubModel *wrongSubModel;
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) NSInteger flag;
@end
