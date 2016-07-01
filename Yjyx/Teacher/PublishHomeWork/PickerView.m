//
//  PickerView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "PickerView.h"

@interface PickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker_view;
@property (strong, nonatomic) NSString *selectedWord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;
@end
@implementation PickerView
- (IBAction)cancelBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PickViewCancel" object:nil userInfo:nil];
}
- (IBAction)doBtnClick:(id)sender {
    if (self.selectedWord == nil) {
//        NSInteger index = [self.picker_view selectedRowInComponent:0];
//        self.selectedWord = [self pickerView:self.picker_view titleForRow:index forComponent:0];
        self.selectedWord = self.materialArr.firstObject;
    }
    if(self.selectedWord == nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PickViewCancel" object:nil userInfo:nil];
    }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PickViewDone" object:nil userInfo:@{@"selectedWord" : self.selectedWord}];
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.picker_view.dataSource = self;
    self.picker_view.delegate = self;
}
- (void)setMaterialArr:(NSMutableArray *)materialArr
{


    _materialArr = materialArr;
    [self.picker_view reloadComponent:0];
}

+ (instancetype)pickerView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.materialArr.count;
}
#pragma mark - PickerView代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.materialArr[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
   
    return 35;
   
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedWord = _materialArr[row];
  
}
- (void)dealloc
{
    NSLog(@"delloc");
}
@end
