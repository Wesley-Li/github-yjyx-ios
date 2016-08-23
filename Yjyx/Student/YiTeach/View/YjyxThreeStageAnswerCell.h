//
//  YjyxThreeStageAnswerCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxThreeStageModel, YjyxThreeStageAnswerCell;
@protocol ThreeStageAnswerCellDelegate <NSObject>

- (void)threeStageAnswerCell:(YjyxThreeStageAnswerCell *)cell analysisBtnClick:(UIButton *)btn;

@end
@interface YjyxThreeStageAnswerCell : UITableViewCell

@property (weak, nonatomic) id<ThreeStageAnswerCellDelegate> deleagte;
@property (strong, nonatomic) YjyxThreeStageModel *model;

@property (assign, nonatomic) CGFloat height;
@end
