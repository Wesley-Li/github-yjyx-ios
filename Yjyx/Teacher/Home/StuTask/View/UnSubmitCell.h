//
//  UnSubmitCell.h
//  Yjyx
//
//  Created by liushaochang on 16/5/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UnSubmitCell;
@protocol UnSubmitCellDelegate <NSObject>

- (void)UnSubmitCell:(UnSubmitCell *)cell speedSubmitBtnIsClicked:(UIButton *)submitBtn;

@end
@interface UnSubmitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *submitLabel;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIButton *showMoreBtn;

@property (weak, nonatomic) IBOutlet UIView *BGVIEW;

@property (weak, nonatomic) id<UnSubmitCellDelegate> delegate;

@end
