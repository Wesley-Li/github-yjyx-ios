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
   NSArray *arr = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", nil];
    YjyxWrongSubModel  *model = [[self alloc] init];
    // 填空题答案与选择题答案的处理
    if([[dict[@"answer"] JSONValue] isKindOfClass:[NSArray class]]){
        NSArray *arr = @[@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳"];
        NSArray *tempArr = [dict[@"answer"] JSONValue];
        if ([[dict[@"answer"] JSONValue] isKindOfClass:[NSArray class]]) {
            NSString *tempStr = nil;
            NSInteger i = 0;
            for (NSString *b_answer in tempArr) {
                if (tempStr == nil) {
                    tempStr = [NSString stringWithFormat:@"%@%@",arr[i],b_answer];
                }else{
                    tempStr = [NSString stringWithFormat:@"%@\n%@%@", tempStr, arr[i], b_answer];
                }
                i++;
            }
            model.answer = tempStr;
        }
    }else{
        NSString *str = nil;
        if([dict[@"answer"] containsString:@"|"]){
            NSArray *answerArr = [dict[@"answer"] componentsSeparatedByString:@"|"];
            for(int j = 0; j < answerArr.count; j++){
                if (str == nil) {
                    str = arr[[answerArr[j] integerValue]];
                }else{
                    str = [NSString stringWithFormat:@"%@%@", str, arr[[answerArr[j] integerValue]]];
                }
                model.answer = str;
            }
        }else{
            NSInteger j = [dict[@"answer"] integerValue];
            model.answer = [NSString stringWithFormat:@"%@", arr[j]];
        }
    }
    
    model.content = dict[@"content"];
    model.t_id = [dict[@"id"] integerValue];
    model.level = [dict[@"level"] integerValue];
    model.questionid = [dict[@"questionid"] integerValue];
    model.questiontype = [dict[@"questiontype"] integerValue];
    model.total_wrong_num = [NSString stringWithFormat:@"%@次", dict[@"total_wrong_num"]];
    
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
    if ([self.answer containsString:@"①"]) {
        CGFloat pullHeight = 0;
        if (self.isLoadMore) {
        NSArray *arr = [self.answer componentsSeparatedByString:@"\n"];
        CGRect rect = [arr[0] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 277, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        if (rect.size.height > 43) {
            cellHeight += rect.size.height - 43;
            pullHeight += rect.size.height - 43;
        }
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
        [tempArr removeObjectAtIndex:0];
        NSString *tempStr = [tempArr componentsJoinedByString:@"\n"];
        CGRect rect1 = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 175, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        cellHeight += rect1.size.height;
            pullHeight += rect1.size.height + 20;
        }
        self.pullHeight = pullHeight;
    }
    
    return cellHeight + 10;
}

@end
