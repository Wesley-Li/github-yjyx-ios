//
//  MicroNameCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MicroDetailModel, MicroNameCell;
@protocol MicroNameCellDelegate <NSObject>

- (void)microNameCell:(MicroNameCell *)cell editMicroTitleBtn:(UIButton *)btn;

@end
@interface MicroNameCell : UITableViewCell

@property (strong, nonatomic) MicroDetailModel *model;


@property (weak, nonatomic) id<MicroNameCellDelegate> delegate;
@end
