//
//  YjyxConvertDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxConvertDetailCell.h"
#import "YjyxExchangeRecordModel.h"
@interface YjyxConvertDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@end
@implementation YjyxConvertDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)copyBtnClick:(UIButton *)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.cardNumLabel.text;
    [pab setString:string];
}

- (void)setModel:(YjyxExchangeRecordModel *)model
{
    _model = model;
    self.cardNumLabel.text = model.specific_info;
}

@end
