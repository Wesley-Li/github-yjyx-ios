//
//  ReleaseDescrpitionCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseDescrpitionCell.h"

#import "NSString+emjoy.h"

@interface ReleaseDescrpitionCell()<UITextFieldDelegate>

@end

@implementation ReleaseDescrpitionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.descriptionTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textFieldDidChange:(UITextField *)textField
{
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag)
    {
        [[UIApplication sharedApplication].keyWindow makeToast:@"不能添加表情符号" duration:1.0 position:SHOW_CENTER complete:nil];
        self.descriptionTextField.text = [textField.text substringToIndex:textField.text.length -2];
        
    }
}


@end
