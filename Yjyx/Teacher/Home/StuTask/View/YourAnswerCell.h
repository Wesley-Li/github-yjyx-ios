//
//  YourAnswerCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yourAnswerLable;



/**
 *选择题赋值方法
 */
- (void)setChoiceValueWithDictionary:(NSDictionary *)dic;

/**
 *提空题赋值方法
 */
- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic;


@end
