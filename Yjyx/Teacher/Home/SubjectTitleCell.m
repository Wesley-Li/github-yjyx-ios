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
// 包含添加题目及需要过程的按钮
@property (weak, nonatomic) IBOutlet UIView *addBtnView;
@property (weak, nonatomic) IBOutlet UIButton *requireProcessBtn;
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
        self.addBtnView.hidden = NO;
    }else{
        self.editBtn.selected = NO;
        self.addBtnView.hidden = YES;
    }
    
    self.requireProcessBtn.selected = model.isShouldProcess;
 
 
}
- (IBAction)requireProcessBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _model.isShouldProcess = sender.selected;
    if([self.delegate respondsToSelector:@selector(subjectTitleCell:requireProcessBtnClicked:)]){
        [self.delegate subjectTitleCell:self requireProcessBtnClicked:sender];
    }
}

- (IBAction)editBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _model.isSelected = sender.selected;
   
    if([self.delegate respondsToSelector:@selector(subjectTitleCell:editBtnClicked:)]){
        [self.delegate subjectTitleCell:self editBtnClicked:sender];
    }
}
- (IBAction)addBtnClicked:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddBtnClick" object:nil];
}

@end
