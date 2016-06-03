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


@end

@implementation TaskListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithTaskModel:(TaskModel *)model {
    
    self.statusImage.hidden = YES;

    NSArray *arr = [model.delivertime componentsSeparatedByString:@"T"];
    NSArray *arr2 = [arr[1] componentsSeparatedByString:@":"];
    NSString *timeString = [NSString stringWithFormat:@"%@日%@:%@", arr[0], arr2[0], arr2[1]];
    self.timeLabel.text = timeString;
    NSString *mainName = model.resourcename;
    if([model.resourcename isEqual:[NSNull null]] || [model.t_description isEqual:[NSNull null]]){
        if ([model.t_description isEqual:[NSNull null]] && ![model.resourcename isEqual:[NSNull null]]) {
            mainName = model.resourcename;
        }
        mainName = @"学生作业";
    }else if ([model.resourcename isEqualToString:@""] && [model.t_description isEqualToString:@""]) {
        mainName = @"学生作业";
    }else if([model.resourcename isEqualToString:@""]){
        mainName = model.t_description;
    }
    self.descriptionLabel.text = mainName;
    if([model.t_description isEqualToString:@""]){
        self.resourcenameLabel.hidden = YES;
    }
    self.resourcenameLabel.hidden = NO;
    self.resourcenameLabel.text = model.t_description;
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
