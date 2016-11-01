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
//    self.preLevelBtn = self.allLevelBtn;
    self.allLevelBtn.selected = YES;
    self.preStatusBtn = self.allStatusBtn;
    
    // 注册通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"levelChange" object:nil];
    
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



- (IBAction)easyBtnClick:(siftButton *)sender {
    
    sender.selected = !sender.selected;
    self.allLevelBtn.selected = NO;
    NSNotification *notice = [NSNotification notificationWithName:@"levelChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

- (IBAction)middleBtnClick:(siftButton *)sender {
    sender.selected = !sender.selected;
    self.allLevelBtn.selected = NO;
    NSNotification *notice = [NSNotification notificationWithName:@"levelChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];

}

- (IBAction)hardBtnClick:(siftButton *)sender {
    sender.selected = !sender.selected;
    self.allLevelBtn.selected = NO;
    NSNotification *notice = [NSNotification notificationWithName:@"levelChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];

}

- (IBAction)allLevelBtnClick:(siftButton *)sender {
    sender.selected = !sender.selected;
    NSNotification *notice = [NSNotification notificationWithName:@"levelChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];

}

- (void)notice:(NSNotification *)sender {

    if (self.easyBtn.selected && self.middleBtn.selected && self.hardBtn.selected) {
        self.allLevelBtn.selected = YES;
        self.easyBtn.selected = NO;
        self.middleBtn.selected = NO;
        self.hardBtn.selected = NO;
        
        self.level = @"1|2|3";
        
    }else if (self.allLevelBtn.selected || (!self.easyBtn.selected && !self.middleBtn.selected && !self.hardBtn.selected && !self.allLevelBtn.selected )) {
        
        self.easyBtn.selected = NO;
        self.middleBtn.selected = NO;
        self.hardBtn.selected = NO;
        
        self.level = @"1|2|3";
    }else if (self.easyBtn.selected && !self.middleBtn.selected && !self.hardBtn.selected) {
        self.allLevelBtn.selected = NO;
        self.level = @"1";
    }else if (self.middleBtn.selected && !self.easyBtn.selected && !self.hardBtn.selected) {
        self.allLevelBtn.selected = NO;
        self.level = @"2";
    }else if (self.hardBtn.selected && !self.easyBtn.selected && !self.middleBtn.selected) {
        self.allLevelBtn.selected = NO;
        self.level = @"3";
    }else if (self.easyBtn.selected && self.middleBtn.selected && !self.hardBtn.selected) {
        self.allLevelBtn.selected = NO;
        self.level = @"1|2";
    }else if (self.easyBtn.selected && self.hardBtn.selected && !self.middleBtn.selected) {
        self.allLevelBtn.selected = NO;
        self.level = @"1|3";
    }else {
        self.allLevelBtn.selected = NO;
        self.level = @"2|3";
    }

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        NSLog(@"%@", touch.view);
        if([touch.view isKindOfClass:[self class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SiftViewIsMove" object:nil];
          
        }
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
//    self.transform = CGAffineTransformMakeTranslation(0, -(SCREEN_HEIGHT - 64));
    
    
}



@end
