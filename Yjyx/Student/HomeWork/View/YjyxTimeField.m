//
//  YjyxTimeField.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxTimeField.h"

@interface YjyxTimeField()
@property (strong, nonatomic) UIDatePicker *dataPick;

@end

@implementation YjyxTimeField

- (void)awakeFromNib
{
    [self setup];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    UIDatePicker *dataPick = [[UIDatePicker alloc] init];
    self.dataPick = dataPick;
    dataPick.backgroundColor = [UIColor whiteColor];
    dataPick.datePickerMode = UIDatePickerModeDate;
    self.inputView  = dataPick;
    [dataPick addTarget:self action:@selector(dateValueChange:) forControlEvents:UIControlEventValueChanged];
    UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancalBtn.frame = CGRectMake(10, 0, 50, accView.height);
    [accView addSubview:cancalBtn];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 50, accView.height);
    [accView addSubview:doneBtn];
    accView.backgroundColor = [UIColor whiteColor];
    self.inputAccessoryView = accView;
    
}
- (void)cancel:(UIButton *)btn
{
    [self resignFirstResponder];
}
- (void)done:(UIButton *)btn
{
    NSLog(@"%@", _dataPick.date);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    self.text = [fmt stringFromDate:_dataPick.date];
    [self resignFirstResponder];
}
- (void)dateValueChange:(UIDatePicker *)picker
{
    NSLog(@"---");
}
@end
