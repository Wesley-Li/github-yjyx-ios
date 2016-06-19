//
//  AnswerSituationCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FinshedModel;
@class NextTableViewController;
@interface AnswerSituationCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (nonatomic, strong) UIView *correctView;
@property (nonatomic, strong) UIView *wrongView;


@property (nonatomic, strong) NSArray *r_arr;
@property (nonatomic, strong) NSArray *w_arr;

@property (nonatomic, strong) NSArray *correctArray;
@property (nonatomic, strong) NSArray *wrongArray;

@property (nonatomic, strong) NSNumber *qtype;
@property (nonatomic, strong) NSNumber *taskid;
@property (nonatomic, strong) NSNumber *qid;


@property (nonatomic, strong) FinshedModel *finshedModel;
@property (nonatomic, strong) NextTableViewController *navi;

/**
 *本班答题情况赋值方法
 */

- (void)setValueWithCorrectArray:(NSArray *)correctArray andWrongArray:(NSArray *)wrongArray;

@end
