//
//  StuConditionTableViewCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuConditionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *finishedArr;
@property (nonatomic, strong) NSMutableArray *unfinishedArr;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
//交作业的同学数
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
//未交作业的同学数
@property (weak, nonatomic) IBOutlet UILabel *unsubmitLabel;

@property (weak, nonatomic) IBOutlet UIView *showView1;
@property (weak, nonatomic) IBOutlet UIView *showView2;

//显示更多按钮
@property (weak, nonatomic) IBOutlet UIButton *showmoreBtn;

@property (weak, nonatomic) IBOutlet UIButton *showUnsubmitBtn;

@property (weak, nonatomic) UIView *line1;
@property (weak, nonatomic) UIView *line2;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
