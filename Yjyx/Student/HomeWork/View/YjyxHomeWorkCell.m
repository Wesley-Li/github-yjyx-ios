//
//  YjyxHomeWorkCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxHomeWorkCell.h"
#import "UIImageView+WebCache.h"
#import "YjyxHomeDataModel.h"
#import "YjyxHomeWrongModel.h"
@interface YjyxHomeWorkCell()
@property (weak, nonatomic) IBOutlet UIImageView *subjectImageView;

@property (weak, nonatomic) IBOutlet UILabel *subjectNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *doneCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expandImageView;
@end
@implementation YjyxHomeWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHomeWorkModel:(YjyxHomeDataModel *)homeWorkModel
{
    _homeWorkModel = homeWorkModel;
    if([homeWorkModel.icon isEqual:[NSNull null]]){
        self.subjectImageView.image = [UIImage imageNamed:@"default_image"];
    }else{
    [self.subjectImageView setImageWithURL:[NSURL URLWithString:homeWorkModel.icon]];
    }
    self.subjectNameLabel.text = homeWorkModel.name;
    self.doneCountLabel.text = @"所有作业";
}
- (void)setHomeWrongModel:(YjyxHomeWrongModel *)homeWrongModel
{
    _homeWrongModel = homeWrongModel;
    if([homeWrongModel.icon isEqual:[NSNull null]]){
        self.subjectImageView.image = [UIImage imageNamed:@"default_image"];
    }else{
    [self.subjectImageView setImageWithURL:[NSURL URLWithString:homeWrongModel.icon] ];
    }
    self.subjectNameLabel.text = homeWrongModel.subjectname;
    self.doneCountLabel.text = [NSString stringWithFormat:@"共做错%ld题", (unsigned long)homeWrongModel.failedquestions.count];
    if(homeWrongModel.failedquestions.count == 0){
        self.expandImageView.hidden = YES;
    }else{
        self.expandImageView.hidden = NO;
    }
}
@end
