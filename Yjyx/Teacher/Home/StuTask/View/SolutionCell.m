//
//  SolutionCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SolutionCell.h"
#import "RCLabel.h"

@interface SolutionCell ()


@property (weak, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@end

@implementation SolutionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSolutionValueWithDiction:(NSDictionary *)dic {

    if (dic == nil) {
        return;
    }
    
    // 清空上次添加的所有子视图
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    NSString *htmlString = [dic[@"question"] objectForKey:@"explanation"];
    if ([htmlString isEqualToString:@""]) {
        self.title_label.text = @"";
    }
    NSString *content = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *contentLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 500)];

    contentLabel.userInteractionEnabled = NO;

    contentLabel.font = [UIFont systemFontOfSize:12];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    contentLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [contentLabel optimumSize];
    self.height = optimalSize.height + 40 + 40;
    [self.bg_view addSubview:contentLabel];
  
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
