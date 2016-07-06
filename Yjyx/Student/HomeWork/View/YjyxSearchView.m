//
//  YjyxSearchView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxSearchView.h"
#import "YjyxTimeField.h"
@interface YjyxSearchView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet YjyxTimeField *beginTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgView1;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *doingBtn;

@property (strong, nonatomic) UIButton *preBtn;
@end
@implementation YjyxSearchView
- (void)awakeFromNib
{
    self.beginTimeField.delegate = self;
    self.endTimeField.delegate = self;
    
    self.allBtn.layer.cornerRadius = 5;
    self.allBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.allBtn.layer.borderWidth = 1;
    
    self.finishBtn.layer.cornerRadius = 5;
    self.finishBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.finishBtn.layer.borderWidth = 1;
    
    self.doingBtn.layer.cornerRadius = 5;
    self.doingBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.doingBtn.layer.borderWidth = 1;
}

+ (instancetype)searchView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (IBAction)btnClick:(UIButton *)sender {
    self.preBtn.backgroundColor = [UIColor whiteColor];
    self.preBtn.layer.borderWidth = 1;
    sender.backgroundColor = STUDENTCOLOR;
    sender.layer.borderWidth = 0;
    self.preBtn.selected = NO;
    sender.selected = YES;
    self.preBtn = sender;
}
- (IBAction)searchBtnClick:(id)sender {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSNumber *beginTime = nil;
    NSNumber *endTime = nil;
    if (![self.beginTimeField.text isEqualToString:@""]) {
        NSDate  *date = [fmt dateFromString:self.beginTimeField.text];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *beginDate = [date  dateByAddingTimeInterval: interval];
        beginTime = [NSNumber numberWithDouble:beginDate.timeIntervalSince1970];
    }
    if (![self.endTimeField.text isEqualToString:@""]){
    NSDate *date1 = [fmt dateFromString:self.endTimeField.text];
    NSInteger interval1 = [zone secondsFromGMTForDate:date1] + 24*60*60;
    NSDate *endDate = [date1  dateByAddingTimeInterval: interval1];
    endTime = [NSNumber numberWithDouble:endDate.timeIntervalSince1970];
    }
    NSNumber *workType = nil;
    if ([self.preBtn isEqual:self.finishBtn]) {
        workType = @1;
    }else if ([self.preBtn isEqual:self.doingBtn]){
        workType = @0;
    }
    
    NSLog(@"%@, %@", beginTime, endTime);
    if ([self.delegate respondsToSelector:@selector(searchView:searchBtnIsClickAndBeginTime:endTime:andWorkType:)]) {
        [self.delegate searchView:self searchBtnIsClickAndBeginTime:beginTime endTime:endTime andWorkType:workType];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.beginTimeField resignFirstResponder];
    [self.endTimeField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}
@end
