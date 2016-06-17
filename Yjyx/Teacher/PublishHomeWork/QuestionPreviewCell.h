//
//  QuestionPreviewCell.h
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChaperContentItem;
@interface QuestionPreviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) ChaperContentItem *model;


- (void)setValueWithModel:(ChaperContentItem *)model;

@end
