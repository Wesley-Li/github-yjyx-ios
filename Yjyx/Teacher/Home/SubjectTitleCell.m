//
//  SubjectTitleCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SubjectTitleCell.h"
#import "MicroDetailModel.h"
@interface SubjectTitleCell()

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstant;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@end
@implementation SubjectTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MicroDetailModel *)model
{
    _model = model;
    if (model.isSelected) {
        self.editBtn.selected = YES;
    }else{
        self.editBtn.selected = NO;
    }
    if (self.editBtn.selected) {
        self.trailingConstant.constant = 56;
        self.addBtn.hidden = NO;
    }else{
        self.trailingConstant.constant = 8;
        self.addBtn.hidden = YES;
    }
}

- (IBAction)editBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _model.isSelected = sender.selected;
    if(sender.selected){
        [self.contentView layoutIfNeeded];
        [UIView animateWithDuration:5.0 animations:^{
            self.trailingConstant.constant = 56;
            [self.contentView layoutIfNeeded];
        }];
        self.addBtn.hidden = NO;
    }else{
        [self.contentView layoutIfNeeded];
        [UIView animateWithDuration:5.0 animations:^{
            self.trailingConstant.constant = 8;
            [self.contentView layoutIfNeeded];
        }];
        self.addBtn.hidden = YES;
    }
    if([self.delegate respondsToSelector:@selector(subjectTitleCell:editBtnClicked:)]){
        [self.delegate subjectTitleCell:self editBtnClicked:sender];
    }
}
- (IBAction)addBtnClicked:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddBtnClick" object:nil];
}

@end
