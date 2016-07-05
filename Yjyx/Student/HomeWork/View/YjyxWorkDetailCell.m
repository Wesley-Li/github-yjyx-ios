//
//  YjyxWorkDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkDetailCell.h"
#import "YjyxTodayWorkModel.h"
@interface YjyxWorkDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *workImageView;
@property (weak, nonatomic) IBOutlet UILabel *workDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *progressBtn;
@end
@implementation YjyxWorkDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTodayWorkModel:(YjyxTodayWorkModel *)todayWorkModel
{
    _todayWorkModel = todayWorkModel;
    if ([todayWorkModel.tasktype isEqual:@1]) {
        self.workImageView.image = [UIImage imageNamed:@"作业"];
    }else{
        self.workImageView.image = [UIImage imageNamed:@"视频"];
    }
    self.workDescLabel.text = todayWorkModel.task_description;
    NSString *str = todayWorkModel.task_delivertime;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:str];
    fmt.dateFormat = @"HH:mm";
    NSString *str1 = [fmt stringFromDate: date];
    self.releaseTimeLabel.text = [NSString stringWithFormat:@"今天%@", str1];
    self.teacherDescLabel.text = [NSString stringWithFormat:@"由%@老师发布", todayWorkModel.delivername];
}
- (void)setOneSubjectModel:(YjyxTodayWorkModel *)OneSubjectModel
{
    _OneSubjectModel = OneSubjectModel;
    if ([OneSubjectModel.tasktype isEqual:@1]) {
        self.workImageView.image = [UIImage imageNamed:@"作业"];
    }else{
        self.workImageView.image = [UIImage imageNamed:@"视频"];
    }
    self.workDescLabel.text = OneSubjectModel.task_description;
    self.releaseTimeLabel.text = [NSString stringWithFormat:@"今天%@", OneSubjectModel.task_delivertime];
    self.teacherDescLabel.text = [NSString stringWithFormat:@"由%@老师发布", OneSubjectModel.delivername];
    
}
@end
