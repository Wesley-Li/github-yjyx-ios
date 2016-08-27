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

@property (weak, nonatomic) IBOutlet UIButton *copyedNumBtn;
@end
@implementation YjyxConvertDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.copyedNumBtn.layer.cornerRadius = 4;
    self.copyedNumBtn.layer.borderColor = STUDENTCOLOR.CGColor;
    self.copyedNumBtn.layer.borderWidth = 1;
}
- (IBAction)copyBtnClick:(UIButton *)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.cardNumLabel.text;
    [pab setString:string];
    if(pab == nil){
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}
- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame:frame];
}
- (void)setModel:(YjyxExchangeRecordModel *)model
{
    _model = model;
    self.cardNumLabel.text = model.specific_info;
}

@end
