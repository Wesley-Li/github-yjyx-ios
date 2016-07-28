//
//  UnSubmitCell.m
//  Yjyx
//
//  Created by liushaochang on 16/5/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "UnSubmitCell.h"

@interface UnSubmitCell()

@property (weak, nonatomic) IBOutlet UIButton *speedSubmitBtn;

@end
@implementation UnSubmitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.speedSubmitBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)speedSubmitBtnClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(UnSubmitCell:speedSubmitBtnIsClicked:)]){
        [self.delegate UnSubmitCell:self speedSubmitBtnIsClicked:sender];
    }
}
@end
