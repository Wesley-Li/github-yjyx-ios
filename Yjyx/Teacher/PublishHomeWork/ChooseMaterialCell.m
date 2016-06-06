//
//  ChooseMaterialCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChooseMaterialCell.h"

@interface ChooseMaterialCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail_label;

@end
@implementation ChooseMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setType:(NSString *)type
{
    _type = type;
    _nameLabel.text = type;
    
}
- (void)setSelMaterial:(NSString *)selMaterial
{
    _selMaterial = selMaterial;
    self.detail_label.text = selMaterial;
}

@end
