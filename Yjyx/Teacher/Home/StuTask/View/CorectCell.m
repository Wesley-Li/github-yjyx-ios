//
//  CorectCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "CorectCell.h"
#import "RCLabel.h"



@interface CorectCell ()


//@property (nonatomic, assign) NSInteger ANSWER;

@end




@implementation CorectCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setChoiceValueWithDictionary:(NSDictionary *)dic {

    if (dic == nil) {
        return;
    }
    NSString *answerString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"answer"]];
    NSArray *answerArr = [answerString componentsSeparatedByString:@"|"];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < answerArr.count; i++) {
        

        NSString *aString = [NSString stringWithFormat:@"%@", answerArr[i]];
        
        if ([answerArr[i] isEqualToString:@"0"]) {
            NSString *AString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"A"];
            [arr addObject:AString];
        }else if ([answerArr[i] isEqualToString:@"1"]) {
        
            NSString *BString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"B"];
            [arr addObject:BString];
        }else if ([answerArr[i] isEqualToString:@"2"]) {
        
            NSString *CString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"C"];
            [arr addObject:CString];

        }else if ([answerArr[i] isEqualToString:@"3"]) {
        
            NSString *DString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"D"];
            [arr addObject:DString];

        }else if ([answerArr[i] isEqualToString:@"4"]) {
        
            NSString *EString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"E"];
            [arr addObject:EString];

        }else if ([answerArr[i] isEqualToString:@"5"]) {
            
            NSString *FString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"F"];
            [arr addObject:FString];

        }else if ([answerArr[i] isEqualToString:@"6"]) {
        
            NSString *GString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"G"];
            [arr addObject:GString];

        }else if ([answerArr[i] isEqualToString:@"7"]) {
            
            NSString *EString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"H"];
            [arr addObject:EString];
            
        }else if ([answerArr[i] isEqualToString:@"8"]) {
            
            NSString *FString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"I"];
            [arr addObject:FString];
            
        }else if ([answerArr[i] isEqualToString:@"9"]) {
            
            NSString *GString = [aString stringByReplacingOccurrencesOfString:answerArr[i] withString:@"J"];
            [arr addObject:GString];
            
        }

        
    }
    
    
    NSLog(@"%@", arr);
    NSString *ansString = [arr componentsJoinedByString:@","];

    UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 20, 40)];
    answerLabel.text = ansString;
    answerLabel.font = [UIFont systemFontOfSize:13];
    
    
    [self.contentView addSubview:answerLabel];
    self.height = answerLabel.frame.size.height + 20 + 10;
    
    
}

- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic {
    
    if (dic == nil) {
        return;
    }
    
    NSString *htmlString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"answer"]];
    
    
    NSString *content = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *contentLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH - 20, 500)];
    contentLabel.userInteractionEnabled = NO;
    contentLabel.font = [UIFont systemFontOfSize:12];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    contentLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [contentLabel optimumSize];
    self.height = optimalSize.height + 15 + 30;
    [self.contentView addSubview:contentLabel];

    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
