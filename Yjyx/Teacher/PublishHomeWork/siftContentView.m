//
//  siftContentView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "siftContentView.h"
#import "siftButton.h"
@interface siftContentView()
@property (weak, nonatomic) IBOutlet siftButton *choiceBtn;
@property (weak, nonatomic) IBOutlet siftButton *blankBTN;
@property (weak, nonatomic) IBOutlet siftButton *allLevelBtn;
@property (weak, nonatomic) IBOutlet siftButton *easyBtn;
@property (weak, nonatomic) IBOutlet siftButton *middleBtn;
@property (weak, nonatomic) IBOutlet siftButton *hardBtn;
@property (weak, nonatomic) IBOutlet siftButton *allStatusBtn;
@property (weak, nonatomic) IBOutlet siftButton *collectBtn;
@property (weak, nonatomic) IBOutlet siftButton *neverUseBtn;

@property (weak, nonatomic) siftButton *preTypeBtn;
@property (weak, nonatomic) siftButton *preLevelBtn;
@property (weak, nonatomic) siftButton *preStatusBtn;
@end
@implementation siftContentView
 - (void)awakeFromNib
{
    self.preTypeBtn = self.choiceBtn;
    self.preLevelBtn = self.allLevelBtn;
    self.preStatusBtn = self.allStatusBtn;
}
+ (instancetype)siftContentViewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (IBAction)typeBtnClicked:(siftButton *)sender {
    self.preTypeBtn.selected = NO;
    sender.selected = YES;
    self.preTypeBtn = sender;
    
}
- (IBAction)levelBtnClicked:(siftButton *)sender {
    self.preLevelBtn.selected = NO;
    sender.selected = YES;
    self.preLevelBtn= sender;
}

- (IBAction)statusBtnClicked:(siftButton *)sender {
    self.preStatusBtn.selected = NO;
    sender.selected = YES;
    self.preStatusBtn = sender;
}
@end
