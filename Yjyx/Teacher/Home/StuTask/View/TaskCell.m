//
//  TaskCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskCell.h"
#import "RCLabel.h"

@interface TaskCell ()


@property (weak, nonatomic) IBOutlet UILabel *dificultyLabel;

//@property (weak, nonatomic) IBOutlet RCLabel *contentLabel;




@end

@implementation TaskCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithDictionary:(NSDictionary *)dic {
    

    if (dic == nil) {
        return;
    }
    
    NSString *htmlString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"content"]];
    NSString *content = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *contentLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 500)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    contentLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [contentLabel optimumSize];
    self.height = optimalSize.height + 15 + 30;
    [self.contentView addSubview:contentLabel];
    
    NSInteger level = [[dic[@"question"] objectForKey:@"level"] integerValue];
    switch (level) {
        case 1:
            self.dificultyLabel.text = @"难度:简单";
            break;
        case 2:
            self.dificultyLabel.text = @"难度:中等";
            break;
        case 3:
            self.dificultyLabel.text = @"难度:较难";
            break;
        default:
            break;
    }
    
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
