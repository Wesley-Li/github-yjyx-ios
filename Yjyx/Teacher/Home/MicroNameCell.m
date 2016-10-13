//
//  MicroNameCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroNameCell.h"
#import "MicroDetailModel.h"
@interface MicroNameCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *microNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
@implementation MicroNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.microNameTextField.delegate = self;
    [_microNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag)
    {
        [[UIApplication sharedApplication].keyWindow makeToast:@"不能添加表情符号" duration:1.0 position:SHOW_CENTER complete:nil];
        textField.text = [textField.text substringToIndex:textField.text.length -2];
        
    }
}

- (void)setModel:(MicroDetailModel *)model
{
    _model = model;
  NSLog(@"%@",  model.create_time) ;
    NSArray *arr = [model.create_time componentsSeparatedByString:@"."];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *date = [formatter dateFromString:arr[0]];
//    date = [NSDate date];
    formatter.dateFormat = @"yyyy:MM:dd HH:mm";
    NSString *str = [formatter stringFromDate:date];
    NSLog(@"%@-----%@", date, str);
    
    self.createTimeLabel.text = str;
    self.microNameTextField.text = model.name;
}
- (IBAction)editBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.microNameTextField.userInteractionEnabled = YES;
        [self.microNameTextField becomeFirstResponder];
    }else{
        NSString *nameStr = [self.microNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([nameStr isEqualToString:@""]){
        [[UIApplication sharedApplication].keyWindow makeToast:@"请输入微课名称" duration:1.0 position:SHOW_CENTER complete:nil];
            sender.selected = !sender.selected;
            return;
        }
        _model.name = self.microNameTextField.text;
        
       
        self.microNameTextField.userInteractionEnabled = NO;
        [self.microNameTextField resignFirstResponder];
    }
   [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyTitleBtnClick" object:nil userInfo:@{@"btn" : @(sender.selected)}];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.microNameTextField.width = self.microNameTextField.width + 60;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"----");
    return YES;
}
@end
