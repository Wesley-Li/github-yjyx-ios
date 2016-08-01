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

@end
@implementation YjyxExchangeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
