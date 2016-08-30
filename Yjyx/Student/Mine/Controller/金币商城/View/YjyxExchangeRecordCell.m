//
//  YjyxExchangeRecordCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxExchangeRecordCell.h"
#import "YjyxExchangeRecordModel.h"
@interface YjyxExchangeRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *exchangeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *copyedBtn;
@end
@implementation YjyxExchangeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.copyedBtn.layer.cornerRadius = 5;
    self.copyedBtn.layer.borderWidth = 1;
    self.copyedBtn.layer.borderColor = STUDENTCOLOR.CGColor;
}
- (IBAction)copyBtnClick:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.descLabel.text;
    [pab setString:string];
    if(pab == nil){
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}

- (void)setRecordModel:(YjyxExchangeRecordModel *)recordModel
{
    _recordModel = recordModel;
    self.exchangeTimeLabel.text = recordModel.exec_datetime;
    self.productNameLabel.text = recordModel.goods_type_name;
    self.coinLabel.text = [recordModel.exchange_coins stringValue];
    if(![recordModel.specific_info isEqual:[NSNull null]]){
    self.descLabel.text = recordModel.specific_info;
    }else{
        self.descLabel.hidden = YES;
    }
    
}

@end
