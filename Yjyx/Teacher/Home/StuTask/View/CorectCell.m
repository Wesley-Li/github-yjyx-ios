//
//  CorectCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "CorectCell.h"



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
    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    NSNumber *answerNumber = [numberF numberFromString:answerString];
    NSInteger answer = [answerNumber integerValue];
    NSLog(@"%ld", answer);
    UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 20, 40)];
    
    switch (answer) {
        case 0:
            answerLabel.text = @"A";
            break;
        case 1:
            answerLabel.text = @"B";
            break;
        case 2:
            answerLabel.text = @"C";
            break;
        case 3:
            answerLabel.text = @"D";
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@", answerLabel.text);
    
    [self.contentView addSubview:answerLabel];
    self.height = answerLabel.frame.size.height + 20 + 10;
    
    
}

- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic {
    
    if (dic == nil) {
        return;
    }
    NSString *htmlString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"answer"]];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH - 20, 1)];
    [web loadHTMLString:htmlString baseURL:nil];
    CGRect frame = web.frame;
    frame.size.width = SCREEN_WIDTH - 20;
    frame.size.height = web.scrollView.contentSize.height;
    web.frame = frame;
    
    self.height = web.frame.size.height + 20 + 10;
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
