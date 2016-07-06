//
//  YjyxStuWrongListCell.h
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjyxStuWrongListModel;
@interface YjyxStuWrongListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UIButton *solutionBtn;

@property (assign, nonatomic) CGFloat height;



- (void)setSubviewsWithModel:(YjyxStuWrongListModel *)model;

@end
