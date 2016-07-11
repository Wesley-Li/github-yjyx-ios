//
//  TaskCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (nonatomic, assign) CGSize optimalSize;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDictionary *dic;

/**
 *根据字典赋值
 */
- (void)setValueWithDictionary:(NSDictionary *)dic;




@end
