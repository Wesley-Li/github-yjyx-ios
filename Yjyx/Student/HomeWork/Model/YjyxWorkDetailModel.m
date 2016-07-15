//
//  YjyxWorkDetailModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkDetailModel.h"
#import "RCLabel.h"
@implementation YjyxWorkDetailModel

+ (instancetype)workDetailModelWithDict:(NSDictionary *)dict
{
    YjyxWorkDetailModel *model = [[self alloc] init];
    model.level = dict[@"level"];
    model.explanation = dict[@"explanation"];
    model.videourl = dict[@"videourl"];
    model.content = dict[@"content"];
    model.showview = dict[@"showview"];
    model.answer = dict[@"answer"];
    model.choicecount = [dict[@"choicecount"] integerValue];
    return model;
}
- (CGFloat)cellHeight
{
    CGFloat cellHeight = 0;
    NSString *content = self.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [templabel optimumSize];
    cellHeight += optimalSize.height;
    self.RcLabelFrame = CGRectMake(6, 8, optimalSize.width, optimalSize.height);
    return cellHeight += 150;
}
@end
