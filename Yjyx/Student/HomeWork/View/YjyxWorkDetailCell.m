//
//  YjyxWorkDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkDetailCell.h"
#import "YjyxTodayWorkModel.h"
#import "YjyxHomeDataModel.h"
#import "YjyxDoingWorkController.h"
#import "YjyxWorkDetailController.h"
#import "YjyxOneSubjectViewController.h"
#import "YjyxHomeWorkController.h"
@interface YjyxWorkDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *workImageView;
@property (weak, nonatomic) IBOutlet UILabel *workDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *progressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstant;
@property (weak, nonatomic) IBOutlet UILabel *timeInfoLabel; // 时间描述

@end
@implementation YjyxWorkDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressBtn.layer.cornerRadius = 5;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
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
    self.workDescLabel.text = todayWorkModel.resourcename;
    NSString *str = todayWorkModel.task_delivertime;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:str];
    fmt.dateFormat = @"HH:mm";
    NSString *str1 = [fmt stringFromDate: date];

    
    if ([todayWorkModel.finished isEqual:@1]) {// 已完成
        [self.progressBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = STUDENTCOLOR;
        // 平均正确率
        CGFloat total = [todayWorkModel.totalCorrect floatValue] + [todayWorkModel.totalWrong floatValue];
        CGFloat myTotal = [todayWorkModel.summary[@"correct"] floatValue] + [todayWorkModel.summary[@"wrong"] floatValue];
        NSString *rateString = total == 0 ? @"0%" : [NSString stringWithFormat:@"%.f%%", [todayWorkModel.totalCorrect floatValue] * 100 / total];
        NSString *myRate = [NSString stringWithFormat:@"%.f%%", [todayWorkModel.summary[@"correct"] floatValue] * 100 / myTotal];
        NSString *raString = [NSString stringWithFormat:@"\n本次平均正确率%@  |  我的正确率%@", rateString, myRate];
        
        NSString *summaryString = [NSString stringWithFormat:@"今天%@  由%@老师发布\n提交时间:%@%@", str1, todayWorkModel.delivername, todayWorkModel.finishtime, raString];
        if([todayWorkModel.finishtime isEqual:[NSNull null]]){
            summaryString = [NSString stringWithFormat:@"今天%@  由%@老师发布%@", str1, todayWorkModel.delivername, raString];
        }
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:summaryString];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e71419"] range:NSMakeRange(summaryString.length - raString.length, raString.length)];
        self.releaseTimeLabel.attributedText = attString;
        todayWorkModel.height = [self.releaseTimeLabel.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 95;
        // 花费时间
        if([todayWorkModel.task__suggestspendtime isEqual:[NSNull null]] || [todayWorkModel.task__suggestspendtime integerValue] == 0){
            todayWorkModel.task__suggestspendtime = @30;
        }
        
        NSInteger time = [todayWorkModel.spendTime integerValue];
        NSString *spendtimeStr = @"";
        if(time < 60){
            spendtimeStr = [NSString stringWithFormat:@"%ld秒", time];
        }else if(time < 60 * 60){
            spendtimeStr = [NSString stringWithFormat:@"%ld分%ld秒", time / 60, time % 60];
        }else{
            spendtimeStr = [NSString stringWithFormat:@"%ld时%ld分%ld秒",time / 3600, (time % 3600)/ 60, (time % 3600) % 60];
        }
        if([todayWorkModel.spendTime integerValue] == 0){
             self.timeInfoLabel.text = [NSString stringWithFormat:@"建议完成时间:%@分钟 ", todayWorkModel.task__suggestspendtime];
        }else{
            self.timeInfoLabel.text = [NSString stringWithFormat:@"建议完成时间:%@分钟 | 用时:%@", todayWorkModel.task__suggestspendtime, spendtimeStr];
        }
        

    }else{
        NSString *summaryString = [NSString stringWithFormat:@"今天%@  由%@老师发布", str1, todayWorkModel.delivername];
        self.releaseTimeLabel.text = summaryString;
        todayWorkModel.height = [self.releaseTimeLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height + 95;
        
        [self.progressBtn setTitle:@"做作业" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = [UIColor colorWithHexString:@"#d8261d"];
        if([todayWorkModel.task__suggestspendtime isEqual:[NSNull null]] || [todayWorkModel.task__suggestspendtime integerValue] == 0){
            todayWorkModel.task__suggestspendtime = @30;
        }
        self.timeInfoLabel.text = [NSString stringWithFormat:@"建议完成时间:%@分钟 ", todayWorkModel.task__suggestspendtime];

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
    self.workDescLabel.text = OneSubjectModel.resourcename;
    self.releaseTimeLabel.text = [NSString stringWithFormat:@"%@", OneSubjectModel.task_delivertime];
    
    NSString *str = OneSubjectModel.task_delivertime;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:str];
    fmt.dateFormat = @"MM-dd HH:mm";
    NSString *str1 = [fmt stringFromDate: date];
    
    //    self.teacherDescLabel.text = [NSString stringWithFormat:@"由%@老师发布", OneSubjectModel.delivername];
    if ([OneSubjectModel.finished isEqual:@1]) {
        [self.progressBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = STUDENTCOLOR;
        // 平均正确率
        CGFloat total = [OneSubjectModel.totalCorrect floatValue] + [OneSubjectModel.totalWrong floatValue];
        CGFloat myTotal = [OneSubjectModel.summary[@"correct"] floatValue] + [OneSubjectModel.summary[@"wrong"] floatValue];
        NSString *rateString = total == 0 ? @"0%" : [NSString stringWithFormat:@"%.f%%", [OneSubjectModel.totalCorrect floatValue] * 100 / total];
        NSString *myRate = [NSString stringWithFormat:@"%.f%%", [OneSubjectModel.summary[@"correct"] floatValue] * 100 / myTotal];
        NSString *raString = [NSString stringWithFormat:@"本次平均正确率%@  |  我的正确率%@", rateString, myRate];
        NSString *summaryString = [NSString stringWithFormat:@"%@  由%@老师发布\n提交时间:%@\n%@", str1, OneSubjectModel.delivername, OneSubjectModel.finishtime, raString];
        if([OneSubjectModel.finishtime isEqual:[NSNull null]]){
            summaryString = [NSString stringWithFormat:@"%@  由%@老师发布\n%@", str1, OneSubjectModel.delivername, raString]; 
        }
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:summaryString];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e71419"] range:NSMakeRange(summaryString.length - raString.length, raString.length)];
        self.releaseTimeLabel.attributedText = attString;
        OneSubjectModel.height = [self.releaseTimeLabel.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 95;
        // 花费时间
        if([OneSubjectModel.task__suggestspendtime isEqual:[NSNull null]] || [OneSubjectModel.task__suggestspendtime integerValue] == 0){
            OneSubjectModel.task__suggestspendtime = @30;
        }
        NSInteger time = [OneSubjectModel.spendTime integerValue];
        NSString *spendtimeStr = @"";
        if(time < 60){
            spendtimeStr = [NSString stringWithFormat:@"%ld秒", time];
        }else if(time < 60 * 60){
            spendtimeStr = [NSString stringWithFormat:@"%ld分%ld秒", time / 60, time % 60];
        }else{
            spendtimeStr = [NSString stringWithFormat:@"%ld时%ld分%ld秒",time / 3600, (time % 3600)/ 60, (time % 3600) % 60];
        }
        if([OneSubjectModel.spendTime integerValue] == 0){
            self.timeInfoLabel.text = [NSString stringWithFormat:@"建议完成时间:%@分钟", OneSubjectModel.task__suggestspendtime];
        }else{
            self.timeInfoLabel.text = [NSString stringWithFormat:@"建议完成时间:%@分钟 | 用时:%@", OneSubjectModel.task__suggestspendtime , spendtimeStr];
        }
        
    }else{
        
        NSString *summaryString = [NSString stringWithFormat:@"%@  由%@老师发布", str1, OneSubjectModel.delivername];
        self.releaseTimeLabel.text = summaryString;
        OneSubjectModel.height = [self.releaseTimeLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height + 95;

        [self.progressBtn setTitle:@"做作业" forState:UIControlStateNormal];
        self.progressBtn.backgroundColor = [UIColor colorWithHexString:@"#d8261d"];
        if([OneSubjectModel.task__suggestspendtime isEqual:[NSNull null]] || [OneSubjectModel.task__suggestspendtime integerValue] == 0){
            OneSubjectModel.task__suggestspendtime = @30;
        }
        self.timeInfoLabel.text = [NSString stringWithFormat:@"建议完成时间:%@分钟", OneSubjectModel.task__suggestspendtime];
    }
    
}

- (void)setFrame:(CGRect)frame
{
    if(self.OneSubjectModel != nil){
        CGRect rect = frame;
        rect.size.height -= 10;
        frame = rect;
    }
    
    [super setFrame:frame];
}

- (IBAction)doingBtnClick:(UIButton *)sender {
    if([[sender titleForState:UIControlStateNormal] isEqualToString:@"做作业"]){
        if ([self.delegate respondsToSelector:@selector(workDetailCell:doingBtnClicked:)]) {
            [self.delegate workDetailCell:self doingBtnClicked:sender];
        }
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
        if ([((UINavigationController *)[UIApplication  sharedApplication].keyWindow.rootViewController.childViewControllers[0]).topViewController isKindOfClass:[YjyxHomeWorkController class]]) {
           YjyxHomeDataModel *model = ((YjyxHomeWorkController *)((UINavigationController *)[UIApplication  sharedApplication].keyWindow.rootViewController.childViewControllers[0]).topViewController).subjectTypeArr[self.tag];
            vc.subject_id = model.s_id;
        }else{
        vc.subject_id = ((YjyxOneSubjectViewController *)((UINavigationController *)[UIApplication  sharedApplication].keyWindow.rootViewController.childViewControllers[0]).topViewController).subjectid;
        }
        [((UINavigationController *)([UIApplication  sharedApplication].keyWindow.rootViewController.childViewControllers[0])) pushViewController:vc animated:YES];
        
    }
  
}
@end
