//
//  TaskConditionTableViewCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TaskConditionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) NSMutableArray *blankArr;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bg_view;



- (void)setValuesWithChoiceModelArr:(NSMutableArray *)choiceDataSource;

- (void)setValuesWithBlankFillModelArr:(NSMutableArray *)blankDataSource;


@end
