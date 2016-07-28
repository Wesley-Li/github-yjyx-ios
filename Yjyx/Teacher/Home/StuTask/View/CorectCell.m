//
//  CorectCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "CorectCell.h"



@interface CorectCell ()

@property (weak, nonatomic) IBOutlet UIView *bg_view;

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
    
    // 清空上次添加的所有子视图
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    NSArray *letterAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"M", nil];
    NSString *tureAnswer = nil;
    NSString *answerString = [NSString stringWithFormat:@"%@", [dic[@"question"] objectForKey:@"answer"]];
    
    // 正确答案显示
    if ([answerString containsString:@"|"]) {
        // 多选
        NSArray *answerArr = [answerString componentsSeparatedByString:@"|"];
        for (NSString *str in answerArr) {
            NSString *tempStr = [letterAry objectAtIndex:[str integerValue]];
            
            if (tureAnswer == nil) {
                tureAnswer = [NSString stringWithFormat:@"%@", tempStr];
            }else{
                
                tureAnswer = [NSString stringWithFormat:@"%@%@", tureAnswer,tempStr];
            }
        }
        
        
    }else {
        // 单选
        tureAnswer = [letterAry objectAtIndex:[answerString integerValue]];
        
    }


    UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
    answerLabel.text = tureAnswer;
    answerLabel.font = [UIFont systemFontOfSize:13];
    [self.bg_view addSubview:answerLabel];
    self.height = answerLabel.frame.size.height + 20 + 10;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeightChange" object:self userInfo:nil];

    
    
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 1;
    frame = rect;
    [super setFrame: frame];
}


- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic {
    
    if (dic == nil) {
        return;
    }
    
    // 清空上次添加的所有子视图
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    NSLog(@"%@", [dic[@"question"] objectForKey:@"answer"]);
    
    // 填空的显示
    NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
    NSArray *arr = [[dic[@"question"] objectForKey:@"answer"] JSONValue];
    NSString *tempString = @"";
    for (int i = 0; i < arr.count; i++) {
        
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], arr[i]]];
        
    }
    
    UILabel *answerLabel = [[UILabel alloc] init];
    answerLabel.text = tempString;
    answerLabel.font = [UIFont systemFontOfSize:13];
    answerLabel.numberOfLines = 0;
    
    
    CGFloat height = [answerLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:answerLabel.font, NSFontAttributeName, nil] context:nil].size.height;
    
    answerLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, height);
    [self.bg_view addSubview:answerLabel];
    
    self.height = height + 15 + 30;
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellHeightChange" object:self userInfo:nil];
    

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
