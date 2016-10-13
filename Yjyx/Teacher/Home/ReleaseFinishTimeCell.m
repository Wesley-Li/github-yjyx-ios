//
//  ReleaseFinishTimeCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseFinishTimeCell.h"
#import "NSString+emjoy.h"
@interface ReleaseFinishTimeCell()

@end
@implementation ReleaseFinishTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
     [self.timeLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag)
    {
        [[UIApplication sharedApplication].keyWindow makeToast:@"不能添加表情符号" duration:1.0 position:SHOW_CENTER complete:nil];
        self.timeLabel.text = [textField.text substringToIndex:textField.text.length -2];
        
    }
    if(textField.text.length > 3){
        textField.text = [textField.text substringToIndex:3];
        [SVProgressHUD showWithStatus:@"建议完成时间必须最多999分钟"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
