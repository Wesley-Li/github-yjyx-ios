//
//  SubTimeCell.h
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subTimeLabel;

- (void)setValueWithDic:(NSDictionary *)dic;

@end
