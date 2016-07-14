//
//  YourAnswerCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YourAnswerCellDelegate <NSObject>

- (void)handlePushClick:(UITapGestureRecognizer *)sender;

@end

@interface YourAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yourAnswerLable;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIView *imageBGView;
@property (weak, nonatomic) id <YourAnswerCellDelegate> delegate;

/**
 *选择题赋值方法
 */
- (void)setChoiceValueWithDictionary:(NSDictionary *)dic;

/**
 *提空题赋值方法
 */
- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic;


@end
