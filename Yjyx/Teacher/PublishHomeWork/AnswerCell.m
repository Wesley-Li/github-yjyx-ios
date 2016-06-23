//
//  AnswerCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "AnswerCell.h"
#import "OneSubjectModel.h"
@interface AnswerCell()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@end
@implementation AnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(OneSubjectModel *)model
{
    _model = model;

    self.answerLabel.text = model.answer;
   
}
- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame:frame];
}
@end
