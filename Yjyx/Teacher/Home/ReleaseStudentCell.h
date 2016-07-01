//
//  ReleaseStudentCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StuClassEntity, StudentEntity, ReleaseStudentCell;

@protocol ReleaseStudentCellDelegate <NSObject>

- (void)releaseStudentCell:(ReleaseStudentCell *)cell allBtnSelectedClicked:(UIButton *)btn;
- (void)releaseStudentCell:(ReleaseStudentCell *)cell isSelectedClicked:(UIButton *)btn;

@end
@interface ReleaseStudentCell : UITableViewCell

@property (strong, nonatomic) StuClassEntity *classEntity;

@property (weak, nonatomic) id<ReleaseStudentCellDelegate> delegate;

@property (strong, nonatomic) StudentEntity *stuEntity;
@end
