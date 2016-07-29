//
//  VideoNumShowCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroDetailModel, VideoNumShowCell, YjyxMicroWorkModel;
@protocol VideoNumShowCellDelegate <NSObject>

- (void)videoNumShowCell:(VideoNumShowCell *)cell videoNumBtnClick:(UIButton *)btn;

@end
@interface VideoNumShowCell : UITableViewCell

@property (strong, nonatomic) MicroDetailModel *model;

@property (strong, nonatomic) YjyxMicroWorkModel *workModel;
@property (weak, nonatomic) id<VideoNumShowCellDelegate> delegate;
@end
