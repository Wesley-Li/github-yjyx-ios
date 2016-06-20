//
//  subjectContentCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "subjectContentCell.h"
#import "ChaperContentItem.h"
#import "RCLabel.h"
@interface subjectContentCell()


@property (weak, nonatomic) IBOutlet UILabel *subjectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLevelLabel;

@property (weak, nonatomic) RCLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation subjectContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectBtn.hidden = YES;
    
    self.subjectNumLabel.layer.cornerRadius = 5;
    self.subjectNumLabel.layer.masksToBounds = YES;
    self.subjectNumLabel.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    NSString *content = _item.content_text;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    self.contentLabel = templabel;
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    
    templabel.componentsAndPlainText = componentsDS;
//    CGSize optimalSize = [templabel optimumSize];
    
    
    
    [self.bgView addSubview:templabel];

}

- (void)setItem:(ChaperContentItem *)item
{
    _item = item;
    NSString *subjectType = nil;
    subjectType = [item.subject_type isEqualToString:@"choice"]?@"选择题":@"填空题";
    self.subjectTypeLabel.text = subjectType;
    NSString *subjectLevel = nil;
    if (item.level == -1) {
        subjectLevel = @"未知";
    }else if (item.level == 1){
        subjectLevel = @"简单";
    }else if(item.level == 2){
        subjectLevel = @"中等";
    }else if(item.level == 3){
        subjectLevel = @"较难";
    }
    self.subjectLevelLabel.text = subjectLevel;
    NSString *content = _item.content_text;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    
    self.contentLabel.componentsAndPlainText = componentsDS;
   
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.frame = _item.RCLabelFrame;

}

@end
