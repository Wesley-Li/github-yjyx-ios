//
//  YjyxDoWorkCollectionCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/30.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxDoingWorkModel;
@class YjyxDoWorkCollectionCell;
@protocol DoWorkCollectionCellDelegate <NSObject>

- (void)doWorkCollectionCell:(YjyxDoWorkCollectionCell *)cell nextWorkBtnIsClick:(UIButton *)btn;

@end
@interface YjyxDoWorkCollectionCell : UICollectionViewCell

@property (weak, nonatomic) id<DoWorkCollectionCellDelegate> delegate;
@property (strong, nonatomic) YjyxDoingWorkModel *model;
@end
