//
//  YjyxStuWrongListCell.m
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuWrongListCell.h"
#import "YjyxStuWrongListModel.h"


@interface YjyxStuWrongListCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *BGVIEW;
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageview;
@property (weak, nonatomic) IBOutlet UILabel *myAnswer;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswer;

@property (weak, nonatomic) IBOutlet UILabel *stuAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stuAnswerBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightAnswerBottom;

@end

@implementation YjyxStuWrongListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.correctAnswer.textColor = RGBACOLOR(22, 156, 111, 1);
    
    self.BGVIEW.layer.borderWidth = 1;
    self.BGVIEW.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    self.lineImageview.backgroundColor = RGBACOLOR(140.0, 140.0, 140.0, 1);
    self.rightAnswerLabel.textColor = RGBACOLOR(22, 156, 111, 1);
    
    self.solutionBtn.layer.cornerRadius = 5;
    self.solutionBtn.layer.borderWidth = 1;
    self.solutionBtn.layer.masksToBounds = YES;
    self.solutionBtn.layer.borderColor = RGBACOLOR(22, 156, 111, 1).CGColor;
    [self.solutionBtn setTitleColor:RGBACOLOR(38, 228, 200, 1) forState:UIControlStateNormal];

    
    
    
}

- (void)setSubviewsWithModel:(YjyxStuWrongListModel *)model {

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
