//
//  SubjectTitleCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubjectTitleCell, MicroDetailModel;
@protocol SubjectTitleCellDelegate <NSObject>

- (void)subjectTitleCell:(SubjectTitleCell *)cell editBtnClicked:(UIButton *)btn;
- (void)subjectTitleCell:(SubjectTitleCell *)cell requireProcessBtnClicked:(UIButton *)btn;
@end
@interface SubjectTitleCell : UITableViewCell

@property (strong, nonatomic) MicroDetailModel *model;
@property (assign, nonatomic) id<SubjectTitleCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@end
