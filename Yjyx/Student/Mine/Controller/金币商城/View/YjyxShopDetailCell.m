//
//  YjyxShopDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxShopDetailCell.h"
#import "YjyxTeacherShopModel.h"
@interface YjyxShopDetailCell()
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *shopDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *requireCoinNumLabel;
@end
@implementation YjyxShopDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.convertBtn.layer.borderColor = RGBACOLOR(255.0, 90.0, 18.0, 1).CGColor;
    self.convertBtn.layer.borderWidth = 1;
    self.convertBtn.layer.cornerRadius = 5;
}
- (void)setProductModel:(YjyxTeacherShopModel *)productModel
{
    _productModel = productModel;
    self.shopName.text = productModel.name;
    self.shopDescLabel.text = productModel.goods_info;
    self.requireCoinNumLabel.text = [productModel.exchange_coins stringValue];
    [self.shopIconImageView setImageWithURL:[NSURL URLWithString:[productModel.goods_display JSONValue][@"small_img_url"]] placeholderImage:[UIImage imageNamed:@"conver_paper"]];
}
@end
