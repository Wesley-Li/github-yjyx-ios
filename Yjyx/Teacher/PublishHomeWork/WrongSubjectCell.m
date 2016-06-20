//
//  WrongSubjectCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongSubjectCell.h"
#import "YjyxWrongSubModel.h"
#import "RCLabel.h"
@interface WrongSubjectCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *wrongTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


@property (weak, nonatomic) RCLabel *contentLabel;
@end

@implementation WrongSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1;
    
    NSString *content = _wrongSubModel.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    self.contentLabel = templabel;
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    
    templabel.componentsAndPlainText = componentsDS;
    
    
    [self.bgView addSubview:templabel];
}
- (void)setWrongSubModel:(YjyxWrongSubModel *)wrongSubModel
{
    _wrongSubModel = wrongSubModel;
    self.wrongTimesLabel.text = [NSString stringWithFormat:@"%ld", wrongSubModel.total_wrong_num];
    self.rightAnswerLabel.text = wrongSubModel.answer;
    
    NSString *content = wrongSubModel.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    
    self.contentLabel.componentsAndPlainText = componentsDS;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.frame = _wrongSubModel.cellFrame;
    
}
- (IBAction)collectBtnClick:(id)sender {
}
- (IBAction)addBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
}

@end
