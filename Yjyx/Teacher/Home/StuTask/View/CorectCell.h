//
//  CorectCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorectCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGFloat height;

/**
 *选择题赋值方法
 */
- (void)setChoiceValueWithDictionary:(NSDictionary *)dic;

/**
 *提空题赋值方法
 */
- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic;

@end
