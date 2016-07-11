//
//  SolutionCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SolutionCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setSolutionValueWithDiction:(NSDictionary *)dic;

@end
