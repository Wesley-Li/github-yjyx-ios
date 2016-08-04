//
//  QuestionPreviewCell.h
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChaperContentItem, YjyxWrongSubModel, QuestionPreviewCell;
@protocol QuestionPreviewCellDelegate <NSObject>

- (void)questionPreviewCell:(QuestionPreviewCell *)cell isRequireProBtnClicked:(UIButton *)btn;

@end
@interface QuestionPreviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, assign) CGFloat height;

@property (weak, nonatomic) id<QuestionPreviewCellDelegate> delegate;
@property (nonatomic, strong) ChaperContentItem *chaperItem; //  知识点出题
@property (nonatomic, strong) YjyxWrongSubModel *wrongModel; // 错题题目

- (void)setValueWithModel:(ChaperContentItem *)model;

- (void)setWrongWithModel:(YjyxWrongSubModel *)model;




@end
