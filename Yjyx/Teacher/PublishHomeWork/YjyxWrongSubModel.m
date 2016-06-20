//
//  YjyxWrongSubModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWrongSubModel.h"
#import "RCLabel.h"
@implementation YjyxWrongSubModel
+ (instancetype)wrongSubjectModelWithDict:(NSDictionary *)dict
{
    YjyxWrongSubModel  *model = [[self alloc] init];
    NSInteger i = [dict[@"answer"] integerValue];
    NSString *str = nil;
    switch (i) {
        case 1:
            str = @"A";
            break;
        case 2:
            str = @"B";
            break;
        case 3:
            str = @"C";
            break;
        case 4:
            str = @"D";
            break;
        case 5:
            str = @"E";
            break;
        case 6:
            str = @"F";
            break;
        case 7:
            str = @"G";
            break;
        case 8:
            str = @"H";
            break;
            
        default:
            break;
    }
    model.answer = str;
    model.content = dict[@"content"];
    model.t_id = [dict[@"id"] integerValue];
    model.level = [dict[@"level"] integerValue];
    model.questionid = [dict[@"questionid"] integerValue];
    model.questiontype = [dict[@"questiontype"] integerValue];
    model.total_wrong_num = [dict[@"total_wrong_num"] integerValue];
    
    return model;
}

- (CGFloat)cellHeight
{
    CGFloat cellHeight = 0;
    cellHeight += 30;
    NSString *content = self.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [templabel optimumSize];
    cellHeight += optimalSize.height;
    self.cellFrame = CGRectMake(2, 2, optimalSize.width, optimalSize.height);
    cellHeight += 60;
    return cellHeight + 10;
}

@end
