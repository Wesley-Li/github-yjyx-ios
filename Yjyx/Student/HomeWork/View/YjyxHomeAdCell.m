//
//  YjyxHomeAdCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeAdCell.h"

#import "YjyxHomeAdModel.h"
@interface YjyxHomeAdCell()
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@end
@implementation YjyxHomeAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(YjyxHomeAdModel *)model
{
    _model = model;
    if (![model.img isEqual:[NSNull null]]) {
         [self.adImageView setImageWithURL:[NSURL URLWithString:model.img]];
    }
   
}
@end
