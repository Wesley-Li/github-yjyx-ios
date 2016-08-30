//
//  TaskListTableViewCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskListTableViewCell.h"
#import "TaskModel.h"

@interface TaskListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;

@property (weak, nonatomic) IBOutlet UILabel *resourcenameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UIButton *realeaseComWorkBtn;
@end

@implementation TaskListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.realeaseComWorkBtn.layer.cornerRadius = 4;
    self.realeaseComWorkBtn.layer.borderColor = [UIColor colorWithHexString:@"#007aff"].CGColor;
    self.realeaseComWorkBtn.layer.borderWidth = 1;
}
- (IBAction)realeaseBtnClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(taskListTableViewCell:releaseWorkBtn:)]){
        [self.delegate taskListTableViewCell:self releaseWorkBtn:sender];
    }
    
}

- (void)setValueWithTaskModel:(TaskModel *)model {
    
    self.statusImage.hidden = YES;

    NSArray *arr = [model.delivertime componentsSeparatedByString:@"T"];
    NSArray *arr2 = [arr[1] componentsSeparatedByString:@":"];
    NSString *timeString = [NSString stringWithFormat:@"%@日%@:%@", arr[0], arr2[0], arr2[1]];
    self.timeLabel.text = timeString;
    
    self.descriptionLabel.text = model.resourcename;
    self.rateLabel.textColor = [UIColor colorWithHexString:@"#d30013"];
    NSInteger totalNum = [model.total_correct integerValue] + [model.total_wrong integerValue];
    self.rateLabel.text = totalNum == 0 ? @"0%" : [NSString stringWithFormat:@"%.f%%", [model.total_correct floatValue] * 100 / ([model.total_correct floatValue] + [model.total_wrong floatValue])];
    
    if([model.t_description isEqualToString:@""]){
        self.resourcenameLabel.hidden = YES;
    }
    self.resourcenameLabel.hidden = NO;
    self.resourcenameLabel.text = model.t_description;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    self.resourcenameLabel.font = font;
    CGRect frame = [_resourcenameLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    
//    self.height = frame.size.height + 120;
    
    model.height = frame.size.height + 120;
    
    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    if ([model.finished isEqual:model.total]) {
        self.finishedLabel.text = @"全部已交";
    }else {
    
        self.finishedLabel.text = [ NSString stringWithFormat:@"%@/%@", [numberF stringFromNumber:model.finished], [numberF stringFromNumber:model.total]];

    }
    
    if ([model.deadlinetime isEqual:[NSNull null]]) {
        self.deadlineLabel.text = @"";
        _deadlineLabel.hidden = YES;
    }else {
        self.deadlineLabel.text = model.deadlinetime;
        _deadlineLabel.hidden = YES;
    }
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
