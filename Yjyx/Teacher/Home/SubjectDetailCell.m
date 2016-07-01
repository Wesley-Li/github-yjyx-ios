//
//  SubjectDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SubjectDetailCell.h"
#import "MicroSubjectModel.h"
#import "RCLabel.h"
@interface SubjectDetailCell()
// 上移按钮
@property (weak, nonatomic) IBOutlet UIButton *moveUpBtn;
// 下移按钮
@property (weak, nonatomic) IBOutlet UIButton *moveDownBtn;
// 删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deletedBtn;
// 科目类型label
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeLabel;
// 科目的难易程度
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
// 背景view
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) RCLabel *templabel;
// 包装上下移及删除按钮的view
@property (weak, nonatomic) IBOutlet UIView *btnSetView;
// 上部分view
@property (weak, nonatomic) IBOutlet UIView *topView;
@end
@implementation SubjectDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moveUpBtn.layer.cornerRadius = 5;
    self.moveUpBtn.layer.borderColor = RGBACOLOR(0, 128.0, 255.0, 1).CGColor;
    self.moveUpBtn.layer.borderWidth = 1;
    
    self.moveDownBtn.layer.cornerRadius = 5;
    self.moveDownBtn.layer.borderColor = RGBACOLOR(0, 128.0, 255.0, 1).CGColor;
    self.moveDownBtn.layer.borderWidth = 1;
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    _templabel = templabel;
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:templabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.topView addGestureRecognizer:tap];
}
- (void)tap{}

- (void)setModel:(MicroSubjectModel *)model
{
    _model = model;
    self.subjectTypeLabel.text = model.type == 1 ? @"选择题" : @"填空题";
    self.levelLabel.text = model.level;
    NSString *content = model.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    _templabel.componentsAndPlainText = componentsDS;
    if (model.btnIsShow) {
        self.btnSetView.hidden = NO ;
    }else{
        self.btnSetView.hidden = YES;
    }

}
- (IBAction)moveDownBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(subjectDetailCell:moveDownBtnClick:)]) {
        [self.delegate subjectDetailCell:self moveDownBtnClick:sender];
    }
}
- (IBAction)moveUpBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(subjectDetailCell:moveUpBtnClick:)]) {
        [self.delegate subjectDetailCell:self moveUpBtnClick:sender];
    }
}
- (IBAction)deletedBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(subjectDetailCell:deletedBtnClick:)]) {
        [self.delegate subjectDetailCell:self deletedBtnClick:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.templabel.frame = _model.RCLabelFrame;
}
@end
