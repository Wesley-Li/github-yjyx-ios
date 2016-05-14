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

@end

@implementation TaskListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithTaskModel:(TaskModel *)model {

    NSArray *arr = [model.delivertime componentsSeparatedByString:@"T"];
    NSArray *arr2 = [arr[1] componentsSeparatedByString:@":"];
    NSString *timeString = [NSString stringWithFormat:@"%@日%@:%@", arr[0], arr2[0], arr2[1]];
    self.timeLabel.text = timeString;
    
    self.descriptionLabel.text = model.t_description;
    NSNumberFormatter *numberF = [[NSNumberFormatter alloc] init];
    if ([model.finished isEqual:model.total]) {
        self.finishedLabel.text = @"全部已交";
    }else {
    
        self.finishedLabel.text = [ NSString stringWithFormat:@"%@/%@", [numberF stringFromNumber:model.finished], [numberF stringFromNumber:model.total]];

    }
    
    if ([model.deadlinetime isEqual:[NSNull null]]) {
        self.deadlineLabel.text = @"";
    }else {
        self.deadlineLabel.text = model.deadlinetime;
    }
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
