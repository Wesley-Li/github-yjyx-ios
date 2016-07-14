//
//  AnswerSituationCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol AnswerSituationCellDelegate <NSObject>

- (void)handlePushCorrectWithSender:(UIButton *)sender;
- (void)handlePushWrongWithSender:(UIButton *)sender;
- (void)handleTapCorrectExpandBtn:(UIButton *)sender;
- (void)handleTapWrongExpandBtn:(UIButton *)sender;

@end



@class FinshedModel;

@interface AnswerSituationCell : UITableViewCell

@property (nonatomic, weak) id <AnswerSituationCellDelegate> delegate;

@property (nonatomic, assign) CGFloat height;


@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (nonatomic, strong) UIView *correctView;
@property (nonatomic, strong) UIView *wrongView;

@property (nonatomic, assign) BOOL c_isExpand;
@property (nonatomic, assign) BOOL w_isExpand;

@property (nonatomic, strong) NSArray *correctArray;
@property (nonatomic, strong) NSArray *wrongArray;

@property (nonatomic, strong) FinshedModel *finshedModel;


/**
 *本班答题情况赋值方法
 */

- (void)setValueWithCorrectArray:(NSArray *)correctArray andWrongArray:(NSArray *)wrongArray;

@end
