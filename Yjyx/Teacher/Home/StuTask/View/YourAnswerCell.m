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


- (void)setChoiceValueWithDictionary:(NSDictionary *)dic {

    NSLog(@"%@", dic);
    
    NSArray *letterAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"M", nil];
    NSString *tureAnswer = nil;
    for (NSNumber *num in dic[@"summary"][1]) {
        NSString *tempStr = [letterAry objectAtIndex:[num integerValue]];
        
        if (tureAnswer == nil) {
            tureAnswer = [NSString stringWithFormat:@"%@", tempStr];
        }else{
            
            tureAnswer = [NSString stringWithFormat:@"%@%@", tureAnswer,tempStr];
        }

    }
    
    if (tureAnswer.length == 0) {
        self.yourAnswerLable.text = @"无做答";
        self.yourAnswerLable.textColor = [UIColor redColor];
    }else {
    
        self.yourAnswerLable.text = [NSString stringWithFormat:@"%@", tureAnswer];
        
//        self.yourAnswerLable.textColor = RGBACOLOR(100, 174, 99, 1);
    }
    
    CGFloat myAnswerHeight = [self.yourAnswerLable.text boundingRectWithSize:CGSizeMake(self.yourAnswerLable.width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.yourAnswerLable.font, NSFontAttributeName, nil] context:nil].size.height;

    
    
    // 如果有作业过程
    CGFloat imageBGHeight;
    if ([dic[@"summary"] count] == 5 && [[dic[@"summary"][4] objectForKey:@"writeprocess"] count] != 0) {
        
        for (UIView *view in [self.imageBGView subviews]) {
            [view removeFromSuperview];
        }
        
        CGSize size = CGSizeMake(0, 0);// 初始位置
        CGFloat padding = 10;// 间距
        NSInteger num = 5;
        
        CGFloat tWidth = (SCREEN_WIDTH - 20 - padding *(num - 1)) / num;
        
        CGFloat tHeigh = tWidth;
        
        NSArray *processArr = [dic[@"summary"][4] objectForKey:@"writeprocess"];
        
        for (int i = 0; i < processArr.count; i++) {
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(size.width, size.height, tWidth, tHeigh)];
            imageview.userInteractionEnabled = YES;
            [imageview setImageWithURL:[NSURL URLWithString:[processArr[i] objectForKey:@"img"]]];
            size.width += tWidth + padding;
            imageview.tag = 200 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [imageview addGestureRecognizer:tap];
            [self.imageBGView addSubview:imageview];
            
            // 声音图标
            
            if ([[processArr[i] objectForKey:@"teachervoice"] count] > 0) {
                
                UIImageView *voiceView = [[UIImageView alloc] init];
                voiceView.width = imageview.width / 2;
                voiceView.height = voiceView.width;
                voiceView.center = imageview.center;
                voiceView.image = [UIImage imageNamed:@"voice_icon"];
                [imageview addSubview:voiceView];
                // 角标
                UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(voiceView.width - 15, 0, 15, 15)];
                numLabel.backgroundColor = [UIColor redColor];
                numLabel.layer.cornerRadius = 7.5;
                numLabel.layer.masksToBounds = YES;
                numLabel.textAlignment = NSTextAlignmentCenter;
                numLabel.textColor = [UIColor whiteColor];
                numLabel.text = [NSString stringWithFormat:@"%ld", [[processArr[i] objectForKey:@"teachervoice"] count]];
                [voiceView addSubview:numLabel];

            }
            
            if (self.imageBGView.width - size.width <= 0) {
                // 换行
                size.width = 0;
                
                // 再做一步判断,即刚好排一排,或者剩余的空间不够排一个,但是已经排完,此时就不用换行了
                if (processArr.count - i > 1) {
                    size.height += tHeigh + 10;
                }
                
            }

        }
        
        imageBGHeight = size.height + tHeigh;

        
        
    }else {
    
        imageBGHeight = 0;
    }
    
    self.height = 70 + imageBGHeight + myAnswerHeight;
    

}


- (void)setBlankfillValueWithDictionary:(NSDictionary *)dic {

    // 填空的显示
    NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
    NSArray *arr = dic[@"summary"][1];
    NSString *tempString = @"";
    for (int i = 0; i < arr.count; i++) {
        
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@%@\n", cornerAry[i], arr[i]]];
        
    }
    
    self.yourAnswerLable.text = tempString;
    
    CGFloat myAnswerHeight = [self.yourAnswerLable.text boundingRectWithSize:CGSizeMake(self.yourAnswerLable.width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.yourAnswerLable.font, NSFontAttributeName, nil] context:nil].size.height;
    
    
    
    // 如果有作业过程
    CGFloat imageBGHeight;
    if ([dic[@"summary"] count] == 5 && [[dic[@"summary"][4] objectForKey:@"writeprocess"] count] != 0) {
        
        for (UIView *view in [self.imageBGView subviews]) {
            [view removeFromSuperview];
        }
        
        CGSize size = CGSizeMake(0, 0);// 初始位置
        CGFloat padding = 10;// 间距
        NSInteger num = 5;
        
        CGFloat tWidth = (self.imageBGView.width - padding *(num - 1)) / num;
        
        CGFloat tHeigh = tWidth;
        
        NSArray *processArr = [dic[@"summary"][4] objectForKey:@"writeprocess"];
        
        for (int i = 0; i < processArr.count; i++) {
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(size.width, size.height, tWidth, tHeigh)];
            imageview.userInteractionEnabled = YES;
            [imageview setImageWithURL:[NSURL URLWithString:[processArr[i] objectForKey:@"img"]]];
            size.width += tWidth + padding;
            imageview.tag = 200 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [imageview addGestureRecognizer:tap];
            [self.imageBGView addSubview:imageview];
            
            // 声音图标
            
            if ([[processArr[i] objectForKey:@"teachervoice"] count] > 0) {
                
                UIImageView *voiceView = [[UIImageView alloc] init];
                voiceView.width = imageview.width / 2;
                voiceView.height = voiceView.width;
                voiceView.center = imageview.center;
                voiceView.image = [UIImage imageNamed:@"voice_icon"];
                [imageview addSubview:voiceView];
                // 角标
                UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(voiceView.width - 15, 0, 15, 15)];
                numLabel.layer.cornerRadius = 7.5;
                numLabel.layer.masksToBounds = YES;
                numLabel.textAlignment = NSTextAlignmentCenter;
                numLabel.backgroundColor = [UIColor redColor];
                numLabel.textColor = [UIColor whiteColor];
                numLabel.text = [NSString stringWithFormat:@"%ld", [[processArr[i] objectForKey:@"teachervoice"] count]];
                
            }
            
            if (self.imageBGView.width - size.width <= 0) {
                // 换行
                size.width = 0;
                
                // 再做一步判断,即刚好排一排,或者剩余的空间不够排一个,但是已经排完,此时就不用换行了
                if (processArr.count - i > 1) {
                    size.height += tHeigh + 10;
                }
                
            }
            
            
            
        }
        
        imageBGHeight = size.height + tHeigh;
        
        
        
    }else {
        
        imageBGHeight = 0;
    }


    
    self.height = myAnswerHeight + 40 + 10 + imageBGHeight;
  

}

- (void)imageClick:(UITapGestureRecognizer *)sender {

    NSLog(@"点击了图片");
    [self.delegate handlePushClick:sender];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
