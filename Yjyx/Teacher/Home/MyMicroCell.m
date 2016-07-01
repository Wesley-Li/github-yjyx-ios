//
//  MyMicroCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MyMicroCell.h"
#import "MyMicroModel.h"
@interface MyMicroCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *ReleaseBtn;
@end

@implementation MyMicroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ReleaseBtn.layer.cornerRadius = 5;
    self.ReleaseBtn.layer.borderColor = RGBACOLOR(0, 128.0, 255.0, 1).CGColor;
    self.ReleaseBtn.layer.borderWidth = 1;
}

- (void)setMicroModel:(MyMicroModel *)microModel
{
    _microModel = microModel;
    self.nameLabel.text = microModel.name;
}
- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame:frame];
}
- (IBAction)ReleaseBtnClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReleaseBtnClick" object:nil userInfo:@{@"model" : _microModel}];
    
}
@end
