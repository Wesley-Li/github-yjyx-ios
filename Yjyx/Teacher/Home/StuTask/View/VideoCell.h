//
//  VideoCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell


@property (nonatomic, assign) CGFloat height;
- (void)setVideoValueWithDic:(NSDictionary *)dic;

@end
