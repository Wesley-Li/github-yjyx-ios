//
//  QuestionPreviewCell.m
//  Yjyx
//
//  Created by liushaochang on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "QuestionPreviewCell.h"
#import "ChaperContentItem.h"
#import "RCLabel.h"

@interface QuestionPreviewCell ()

@property (weak, nonatomic) IBOutlet UILabel *subject_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) RCLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation QuestionPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setValueWithModel:(ChaperContentItem *)model {

    self.questionNumberLabel.layer.cornerRadius = 5;
    self.questionNumberLabel.layer.masksToBounds = YES;
    self.questionNumberLabel.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    self.lineView.backgroundColor = RGBACOLOR(140.0, 140.0, 140.0, 1);
    
    
    self.subject_typeLabel.text = model.subject_type;
    
    if ([model.subject_type isEqualToString:@"choice"]) {
        self.subject_typeLabel.text = @"选择题";
    }else if ([model.subject_type isEqualToString:@"blankfill"]) {
    
        self.subject_typeLabel.text = @"填空题";
    }
    
    switch (model.level) {
        case 1:
            self.levelLabel.text = @"难度:简单";
            break;
        case 2:
            self.levelLabel.text = @"难度:中等";
            break;
        case 3:
            self.levelLabel.text = @"难度:较难";
            break;
        default:
            break;
            
    }
    
    
    self.bg_view.layer.borderWidth = 1;
    self.bg_view.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    
    NSString *content = model.content_text;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH - 20, 999)];
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    
    
    [self.bg_view addSubview:templabel];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
