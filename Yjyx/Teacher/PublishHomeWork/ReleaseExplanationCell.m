//
//  ReleaseExplanationCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseExplanationCell.h"
#import "RCLabel.h"
#import "OneSubjectModel.h"

@interface ReleaseExplanationCell()

@property (weak, nonatomic) RCLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@end
@implementation ReleaseExplanationCell

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
    NSString *content = model.explanation;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    self.contentLabel.componentsAndPlainText = componentsDS;
    if([content isEqualToString:@""]){
        self.explanationLabel.hidden = YES;
        self.answerLabel.hidden = YES;
    }else{
        self.explanationLabel.hidden = NO;
        self.answerLabel.hidden = NO;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.frame = _model.threeFrame;
}
@end
