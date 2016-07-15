//
//  YjyxWorkDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkDetailCell.h"
#import "YjyxTodayWorkModel.h"
#import "YjyxDoingWorkController.h"
#import "YjyxWorkDetailController.h"
@interface YjyxWorkDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *workImageView;
@property (weak, nonatomic) IBOutlet UILabel *workDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *progressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstant;
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
    if ([todayWorkModel.finished isEqual:@1]) {
        [self.progressBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = STUDENTCOLOR;
    }else{
        [self.progressBtn setTitle:@"做作业" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = RGBACOLOR(10.0, 96.0, 254.0, 1);
    }
}
- (void)setOneSubjectModel:(YjyxTodayWorkModel *)OneSubjectModel
{
    _OneSubjectModel = OneSubjectModel;
    self.leadConstant.constant = 10;
    if ([OneSubjectModel.tasktype isEqual:@1]) {
        self.workImageView.image = [UIImage imageNamed:@"作业"];
    }else{
        self.workImageView.image = [UIImage imageNamed:@"视频"];
    }
    self.workDescLabel.text = OneSubjectModel.task_description;
    self.releaseTimeLabel.text = [NSString stringWithFormat:@"%@", OneSubjectModel.task_delivertime];
    self.teacherDescLabel.text = [NSString stringWithFormat:@"由%@老师发布", OneSubjectModel.delivername];
    if ([OneSubjectModel.finished isEqual:@1]) {
        [self.progressBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = STUDENTCOLOR;
    }else{
        [self.progressBtn setTitle:@"做作业" forState:UIControlStateNormal];
         self.progressBtn.backgroundColor = RGBACOLOR(10.0, 96.0, 254.0, 1);
    }
    
}
- (IBAction)doingBtnClick:(UIButton *)sender {
    if([[sender titleForState:UIControlStateNormal] isEqualToString:@"做作业"]){
        YjyxDoingWorkController *vc = [[YjyxDoingWorkController alloc] init];
        NSLog(@"%@", _todayWorkModel);
        vc.type = _todayWorkModel == nil ? _OneSubjectModel.tasktype : _todayWorkModel.tasktype;
        vc.desc = _todayWorkModel == nil ? _OneSubjectModel.task_description : _todayWorkModel.task_description;
        vc.taskid = _todayWorkModel == nil ? _OneSubjectModel.task_id : _todayWorkModel.task_id;
        vc.examid = _todayWorkModel == nil ? _OneSubjectModel.task_relatedresourceid : _todayWorkModel.task_relatedresourceid;
        [((UINavigationController *)([UIApplication  sharedApplication].keyWindow.rootViewController.childViewControllers[0])) pushViewController:vc animated:YES];
    }else{
        YjyxWorkDetailController *vc = [[YjyxWorkDetailController alloc] init];
        NSNumber *t_id = _todayWorkModel == nil ? _OneSubjectModel.t_id : _todayWorkModel.t_id;
        NSNumber *type = _todayWorkModel == nil ? _OneSubjectModel.tasktype : _todayWorkModel.tasktype;
        NSString *desc = _todayWorkModel == nil ? _OneSubjectModel.task_description : _todayWorkModel.task_description;
        vc.t_id = t_id;
        vc.taskType = type;
        vc.title = desc;
        [((UINavigationController *)([UIApplication  sharedApplication].keyWindow.rootViewController.childViewControllers[0])) pushViewController:vc animated:YES];
        
    }
  
}
@end
