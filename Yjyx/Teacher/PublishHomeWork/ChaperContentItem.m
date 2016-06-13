//
//  ChaperContentItem.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChaperContentItem.h"

#import "RCLabel.h"
@implementation ChaperContentItem

+ (instancetype)chaperContentItemWithArray:(NSArray *)arr
{
    ChaperContentItem *item = [[self alloc] init];
    item.t_id = [arr[0] integerValue];
    item.content_text = arr[2];
    item.person_type = [arr[3] integerValue];
    item.p_id = [arr[4] integerValue];
    if ([arr[5] isEqual:[NSNull null]]) {
        item.level = -1;
        return nil;
    }else{
    item.level = [arr[5] integerValue];
    }
    item.subject_type = arr[6];
    
    return item;
}
- (CGFloat)cellHeight
{
   
    CGFloat cellHeight = 0;
    cellHeight += 30;
    NSString *content = self.content_text;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [templabel optimumSize];
    cellHeight += optimalSize.height;
    self.RCLabelFrame = CGRectMake(2, 2, optimalSize.width, optimalSize.height);
    cellHeight += 80;
    return cellHeight + 10;
    
}
@end
