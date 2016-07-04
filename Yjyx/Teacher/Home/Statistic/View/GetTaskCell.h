//
//  GetTaskCell.h
//  Yjyx
//
//  Created by liushaochang on 16/7/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetTaskModel;
@interface GetTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

- (void)setValueWithModel:(GetTaskModel *)model;

@end
