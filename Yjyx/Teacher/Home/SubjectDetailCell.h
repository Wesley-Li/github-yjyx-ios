//
//  SubjectDetailCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroSubjectModel , SubjectDetailCell;

@protocol SubjectDetailCellDelegate <NSObject>

- (void)subjectDetailCell:(SubjectDetailCell *)cell moveUpBtnClick:(UIButton *)btn;
- (void)subjectDetailCell:(SubjectDetailCell *)cell moveDownBtnClick:(UIButton *)btn;
- (void)subjectDetailCell:(SubjectDetailCell *)cell deletedBtnClick:(UIButton *)btn;

@end
@interface SubjectDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectNumLabel;

@property (strong, nonatomic) MicroSubjectModel *model;

@property (assign, nonatomic) id<SubjectDetailCellDelegate> delegate;
@end
