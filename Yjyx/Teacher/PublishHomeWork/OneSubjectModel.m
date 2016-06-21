//
//  OneSubjectModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OneSubjectModel.h"
#import "RCLabel.h"
@implementation OneSubjectModel

+ (instancetype)oneSubjectModelWithDict:(NSDictionary *)dict
{
     NSArray *arr = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", nil];
    OneSubjectModel *model = [[self alloc] init];
    model.content = dict[@"content"];
    model.videourl = dict[@"videourl"];
    model.explanation = dict[@"explanation"];
    model.level = [dict[@"level"] integerValue];
    NSInteger i = [dict[@"answer"] integerValue];
    NSString *str = nil;
    if([dict[@"answer"] containsString:@"|"]){
    NSArray *answerArr = [dict[@"answer"] componentsSeparatedByString:@"|"];
    for(int j = 0; j < answerArr.count; j++){
        if (str == nil) {
            str = arr[[answerArr[i] integerValue]];
        }else{
            str = [NSString stringWithFormat:@"%@%@", str, arr[[answerArr[i] integerValue]]];
        }
        model.answer = str;
    }
    }else{
        NSInteger j = [dict[@"answer"] integerValue];
        model.answer = [NSString stringWithFormat:@"%@", arr[j]];
    }
    
    model.t_id = [dict[@"id"] integerValue];
    return model;
}
- (CGFloat)firstCellHeight
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
    self.firstFrame = CGRectMake(5, 5, optimalSize.width, optimalSize.height);
    cellHeight += 25;
    return cellHeight + 10;
}
- (CGFloat)threeCellHeight
{
    CGFloat cellHeight = 0;
    cellHeight += 60;
    NSString *content = self.explanation;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [templabel optimumSize];
    cellHeight += optimalSize.height;
    self.threeFrame = CGRectMake(5, 60, optimalSize.width, optimalSize.height);
    return cellHeight + 10;
}
@end
