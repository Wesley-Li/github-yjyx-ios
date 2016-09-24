//
//  SpendTimeCell.h
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpendTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *spendTimeLabel;

@property (assign, nonatomic) NSInteger finishTime;
- (void)setValueWithDic:(NSDictionary *)dic;

@end
