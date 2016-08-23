//
//  YjyxThreeStageSubjectCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxThreeStageModel, YjyxThreeStageSubjectCell;
@protocol ThreeStageSubjectCellDelegate <NSObject>

- (void)threeStageSubjectCell:(YjyxThreeStageSubjectCell *)cell doingSubjectBtnClick:(UIButton *)btn;

@end
@interface YjyxThreeStageSubjectCell : UITableViewCell

@property (weak, nonatomic) id<ThreeStageSubjectCellDelegate> delegate;
@property (strong, nonatomic) YjyxThreeStageModel *model;
@end
