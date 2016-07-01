//
//  MicroSubjectModel.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroSubjectModel.h"
#import "RCLabel.h"
@implementation MicroSubjectModel

+ (instancetype)microSubjectModel:(NSDictionary *)dict andType:(NSInteger)type
{
    MicroSubjectModel *model = [[self alloc] init];
    model.content = dict[@"content"];
    model.s_id = dict[@"id"];
    NSLog(@"%@", dict[@"level"]);
    if ([dict[@"level"] isEqual:@1]) {
        model.level = @"简单";
    }else if ([dict[@"level"] isEqual:@2]){
        model.level = @"中等";
    }else{
        model.level = @"较难";
    }
    
    model.type = type;
    
    return model;
}

- (CGFloat)cellHeight
{
    CGFloat cellHeight = 0;
    cellHeight += 45;
    NSString *content = self.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    templabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [templabel optimumSize];
    cellHeight += optimalSize.height;
    self.RCLabelFrame = CGRectMake(2, 47, optimalSize.width, optimalSize.height);
    
    return cellHeight += 15;
}
@end
