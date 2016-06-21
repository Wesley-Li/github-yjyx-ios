//
//  TitleContentCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TitleContentCell.h"
#import "RCLabel.h"
#import "OneSubjectModel.h"
@interface TitleContentCell()

@property (weak, nonatomic) RCLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@end
@implementation TitleContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    self.contentLabel = templabel;
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:templabel];
}

- (void)setModel:(OneSubjectModel *)model
{
    _model = model;
    NSString *content = model.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    self.contentLabel.componentsAndPlainText = componentsDS;
    NSString *str = @"简单";
    if (model.level == 2) {
        str = @"中等";
    }else if (model.level == 3){
        str = @"较难";
    }
    self.levelLabel.text =  str;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.frame = _model.firstFrame;
}
- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame:frame];
}
@end
