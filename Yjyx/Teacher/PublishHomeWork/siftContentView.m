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
    if (sender == self.choiceBtn) {
        self.questionType = @"choice";
    }else {
    
        self.questionType = @"blankfill";
    }
    
}

- (IBAction)levelBtnClicked:(siftButton *)sender {
//    self.preLevelBtn.selected = NO;
    sender.selected = !sender.selected;
    self.preLevelBtn= sender;
    if (self.easyBtn.selected && self.middleBtn.selected && self.hardBtn.selected) {
        self.allLevelBtn.selected = YES;
        self.easyBtn.selected = NO;
        self.middleBtn.selected = NO;
        self.hardBtn.selected = NO;
        
        self.level = @"1|2|3";
        
    }else if (self.allLevelBtn.selected) {
        
        self.easyBtn.selected = NO;
        self.middleBtn.selected = NO;
        self.hardBtn.selected = NO;
        
        self.level = @"1|2|3";
    }else if (self.easyBtn.selected && !self.middleBtn.selected && !self.hardBtn.selected) {
    
        self.level = @"1";
    }else if (self.middleBtn.selected && !self.easyBtn.selected && !self.hardBtn.selected) {
        
        self.level = @"2";
    }else if (self.hardBtn.selected && !self.easyBtn.selected && !self.middleBtn.selected) {
        
        self.level = @"3";
    }else if (self.easyBtn.selected && self.middleBtn.selected && !self.hardBtn.selected) {
        
        self.level = @"1|2";
    }else if (self.easyBtn.selected && self.hardBtn.selected && !self.middleBtn.selected) {
    
        self.level = @"1|3";
    }else {
    
        self.level = @"2|3";
    }



    
    
}

- (IBAction)statusBtnClicked:(siftButton *)sender {
    self.preStatusBtn.selected = NO;
    sender.selected = YES;
    self.preStatusBtn = sender;
}

// 确定
- (IBAction)configureBtnClick:(UIButton *)sender {
    
    [self.delegate configurePamra];
    self.transform = CGAffineTransformMakeTranslation(0, -(SCREEN_HEIGHT - 64));
    
    
}



@end
