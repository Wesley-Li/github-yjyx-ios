//
//  YourAnswerCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YourAnswerCell.h"

@implementation YourAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame: frame];
}

- (void)setChoiceValueWithDictionary:(NSDictionary *)dic {

    NSMutableArray *yAnswerArr = [dic[@"summary"][1] mutableCopy];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < yAnswerArr.count; i++) {
        NSString *aString = [NSString stringWithFormat:@"%@", yAnswerArr[i]];
        
        if ([aString isEqualToString:@"0"]) {
            NSString *AString = [NSString stringWithFormat: @"A"];
            [arr addObject:AString];
        }else if ([aString isEqualToString:@"1"]) {
            
            NSString *BString = [NSString stringWithFormat: @"B"];
            [arr addObject:BString];
        }else if ([aString isEqualToString:@"2"]) {
            
            NSString *CString = [NSString stringWithFormat: @"C"];
            [arr addObject:CString];
            
        }else if ([aString isEqualToString:@"3"]) {
            
            NSString *DString = [NSString stringWithFormat: @"D"];
            [arr addObject:DString];
            
        }else if ([aString isEqualToString:@"4"]) {
            
            NSString *EString = [NSString stringWithFormat: @"E"];
            [arr addObject:EString];
            
        }else if ([aString isEqualToString:@"5"]) {
            
            NSString *FString = [NSString stringWithFormat: @"F"];
            [arr addObject:FString];
            
        }else if ([aString isEqualToString:@"6"]) {
            
            NSString *GString = [NSString stringWithFormat: @"G"];
            [arr addObject:GString];
            
        }else if ([aString isEqualToString:@"7"]) {
            
            NSString *HString = [NSString stringWithFormat: @"H"];
            [arr addObject:HString];
            
        }else if ([aString isEqualToString:@"8"]) {
            
            NSString *IString = [NSString stringWithFormat: @"I"];
            [arr addObject:IString];
            
        }else if ([aString isEqualToString:@"9"]) {
            
            NSString *JString = [NSString stringWithFormat: @"J"];
            [arr addObject:JString];
            
        }

    }
    
    NSString *ansString = [arr componentsJoinedByString:@","];
    
    NSLog(@"%@", ansString);
    
    self.yourAnswerLable.text = [NSString stringWithFormat:@"%@", ansString];
    

}


- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic {

    NSString *ansString = [dic[@"summary"][1] componentsJoinedByString:@","];
    
    self.yourAnswerLable.text = [NSString stringWithFormat:@"%@", ansString];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
