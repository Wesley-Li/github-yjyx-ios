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


- (void)setValueWithArray:(NSArray *)arr {

    NSString *aString;
    for (int i = 0; i < arr.count; i++) {
        NSNumber *numer = arr[i];
        NSLog(@"%@", arr[i]);
        
        aString = [NSString stringWithFormat:@"%@", numer];
        
    }
    
    NSString *stringA = [aString stringByReplacingOccurrencesOfString:@"0" withString:@"A"];
    NSString *stringB = [stringA stringByReplacingOccurrencesOfString:@"1" withString:@"B"];
    NSString *stringC = [stringB stringByReplacingOccurrencesOfString:@"2" withString:@"C"];
    NSString *stringD = [stringC stringByReplacingOccurrencesOfString:@"3" withString:@"D"];
    
    self.yourAnswerLable.text = [NSString stringWithFormat:@"%@", stringD];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
