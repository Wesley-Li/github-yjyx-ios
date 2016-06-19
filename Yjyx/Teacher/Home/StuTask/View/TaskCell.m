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
@property (nonatomic, strong) RCLabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *bg_view;



@end

@implementation TaskCell


- (void)awakeFromNib {
    [super awakeFromNib];

    
    NSString *content = [NSString stringWithFormat:@"%@", [_dic[@"question"] objectForKey:@"content"]];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 999)];
    self.contentLabel = templabel;
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    
    [self.bg_view addSubview:templabel];
    
    
}

- (void)setValueWithDictionary:(NSDictionary *)dic {
    

    if (dic == nil) {
        return;
    }
    
    NSString *htmlString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"content"]];
    NSString *content = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    self.contentLabel.componentsAndPlainText = componentsDS;
    
    CGSize optimalSize = [_contentLabel optimumSize];
    self.height = optimalSize.height + 15 + 30;



    NSInteger level;
    if ([dic[@"question"][@"level"] isEqual:[NSNull null]]) {
         level = 1;
         self.dificultyLabel.hidden = YES;
    }else{
     level = [[dic[@"question"] objectForKey:@"level"] integerValue];
    }
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




- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame: frame];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
