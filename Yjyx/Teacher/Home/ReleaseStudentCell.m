//
//  ReleaseStudentCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/27.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ReleaseStudentCell.h"
#import "StuClassEntity.h"
#import "StudentEntity.h"
@interface ReleaseStudentCell()

@property (weak, nonatomic) IBOutlet UILabel *classOrStudentLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *isShowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstant;

@property (strong, nonatomic) NSMutableArray *gradeArr;
@end
@implementation ReleaseStudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gradeArr = [[[YjyxOverallData sharedInstance].teacherInfo.school_classes JSONValue] mutableCopy];

}
- (void)setClassEntity:(StuClassEntity *)classEntity
{
    _classEntity = classEntity;
    self.selectBtn.hidden = NO;
    self.leadConstant.constant = 0;
    self.selectBtn.selected = classEntity.isSelect ? YES : NO;
    NSLog(@"%d", classEntity.isExpanded);
    self.isShowBtn.selected = classEntity.isExpanded ? YES : NO;
    [self.isShowBtn setImage:[UIImage imageNamed:@"list_icon_2"] forState:UIControlStateNormal];
    [self.isShowBtn setImage:[UIImage imageNamed:@"list_icon_2_expand"] forState:UIControlStateSelected];
    self.isShowBtn.userInteractionEnabled = NO;
    self.classOrStudentLabel.text = classEntity.name;
    if ([classEntity.name containsString:@"年级"]) {
        self.classOrStudentLabel.text = classEntity.name;
        
    }else {
        
        for (NSArray *arr in _gradeArr) {
            if ([classEntity.gradeid isEqual:arr[2]]) {
                NSString *titleString = [NSString stringWithFormat:@"%@%@", arr[3], classEntity.name];
                self.classOrStudentLabel.text = titleString;
                
            }
            
        }
        
    }

}
- (void)setStuEntity:(StudentEntity *)stuEntity
{
    _stuEntity = stuEntity;
    self.selectBtn.hidden = YES;
    self.leadConstant.constant = 15;
    [self.isShowBtn setImage:[UIImage imageNamed:@"list_icon_nor"] forState:UIControlStateNormal];
    [self.isShowBtn setImage:[UIImage imageNamed:@"list_icon_sel"] forState:UIControlStateSelected];
    self.isShowBtn.selected = stuEntity.isSelect ? YES : NO;
    self.isShowBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
    self.classOrStudentLabel.text = stuEntity.realname;
    self.isShowBtn.userInteractionEnabled = YES;
}
- (IBAction)showBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _stuEntity.isSelect = sender.selected;
    if([self.delegate respondsToSelector:@selector(releaseStudentCell:isSelectedClicked:)]){
        [self.delegate  releaseStudentCell:self isSelectedClicked:sender];
        
    }
}
- (IBAction)selectAllBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _classEntity.isSelect = sender.selected;
    if([self.delegate respondsToSelector:@selector(releaseStudentCell:allBtnSelectedClicked:)]){
        [self.delegate releaseStudentCell:self allBtnSelectedClicked:sender];
    }
    
}

@end
