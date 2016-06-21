//
//  ReleaseVideoCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OneSubjectModel;
@interface ReleaseVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIV;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;

@property (strong, nonatomic) OneSubjectModel *model;
@end
