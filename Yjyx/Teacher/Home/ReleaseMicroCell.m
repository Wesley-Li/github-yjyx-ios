//
//  ReleaseMicroCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseMicroCell.h"
#import "YjyxMicroWorkModel.h"

@interface ReleaseMicroCell()
@property (weak, nonatomic) IBOutlet UIButton *backBTN;

@end
@implementation ReleaseMicroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(YjyxMicroWorkModel *)model
{
    _model = model;
    
    if (model.videoobjlist.count == 0) {
        self.playBtn.hidden = YES;
        self.backBTN.hidden = YES;
    }else{
//        self.playBtn.hidden = NO;
        self.backBTN.hidden = NO;
    }
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackButtonClicked" object:nil];
}

@end
