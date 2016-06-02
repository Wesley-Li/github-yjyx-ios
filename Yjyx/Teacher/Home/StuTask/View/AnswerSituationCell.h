//
//  AnswerSituationCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerSituationCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

/**
 *本班答题情况赋值方法
 */

- (void)setValueWithCorrectArray:(NSArray *)correctArray andWrongArray:(NSArray *)wrongArray;

@end
