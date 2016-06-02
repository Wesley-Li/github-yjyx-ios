//
//  AnswerSituationCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "AnswerSituationCell.h"
#import "StuDataBase.h"
#import "StudentEntity.h"


@implementation AnswerSituationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithCorrectArray:(NSArray *)correctArray andWrongArray:(NSArray *)wrongArray {

    NSInteger totalCount = correctArray.count + wrongArray.count;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.summaryLabel.origin.y + 20, SCREEN_WIDTH - 20, 20)];
    if (correctArray.count == 0) {
        contentLabel.text = [NSString stringWithFormat:@"答题人数%ld人, 正确率为0%%;", (long)totalCount];
    }
    contentLabel.text = [NSString stringWithFormat:@"答题人数%ld人, 正确率为%.f%%;", (long)totalCount, (correctArray.count * 1.0) * 100 / (totalCount * 1.0)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:contentLabel];
    
    
    // 答题正确人数
    UIView *correctView = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH, 0)];
    UILabel *correctLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];

    correctLabel.font = [UIFont systemFontOfSize:12];
    
    // 初始位置
    CGSize size = CGSizeMake(10, 0);
    CGFloat padding = 10;
    
    NSInteger num = 7;
    
    CGFloat tWidth = (correctView.width - padding *(num + 1)) * 1.0 / num * 1.0;
    CGFloat tHeigh = tWidth + 20;

    if (correctArray.count == 0) {
        correctView.frame = CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH, 0);
    }else{
    // 循环创建正确人数
    for (int i = 0; i < correctArray.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        taskView.backgroundColor = [UIColor redColor];
        size.width += tWidth + padding;
        
        if (correctView.width - 40 - size.width == 0) {
            size.width = 10;
            size.height += tHeigh + 10;
        }
        
        // 头像
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        
        StudentEntity *studentEntity = [[StuDataBase shareStuDataBase] selectStuById:correctArray[i]];
        
        if ([studentEntity.avatar_url isEqual:[NSNull null]]) {
            
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
            
        }else {
        
            [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:studentEntity.avatar_url] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
        }
        
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@", studentEntity.realname];
    
        [taskView addSubview:imageBtn];
        [taskView addSubview:nameLabel];
        [correctView addSubview:taskView];
    
    }
    
    CGRect cframe = correctView.frame;
    cframe.size.width = SCREEN_WIDTH - 40;
    cframe.size.height = size.height + tHeigh + 20;
    correctView.frame = cframe;
    }
//    correctView.frame = CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH - 40, size.height + tHeigh + 20);
    
    // 将正确的人数添加到父视图
    [self.contentView addSubview:correctView];
    
    
    
    // 答题错误人数
    UIView *wrongView = [[UIView alloc] initWithFrame:CGRectMake(0, correctView.origin.y + correctView.height, SCREEN_WIDTH, 0)];
    UILabel *wrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];

    wrongLabel.font = [UIFont systemFontOfSize:12];
    if (wrongArray.count == 0) {
        wrongView.frame = CGRectMake(0, correctView.origin.y + correctView.height, SCREEN_WIDTH, 0);
    }else{
    // 循环创建正确人数
    for (int i = 0; i < wrongArray.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (correctView.width - 40 - size.width == 0) {
            size.width = 10;
            size.height += tHeigh + 10;
        }
        
        // 头像
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        
        StudentEntity *studentEntity = [[StuDataBase shareStuDataBase] selectStuById:wrongArray[i]];
        
        if ([studentEntity.avatar_url isEqual:[NSNull null]]) {
            
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
            
        }else {
            
            [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:studentEntity.avatar_url] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
        }
        
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@", studentEntity.realname];
        
        [taskView addSubview:imageBtn];
        [taskView addSubview:nameLabel];
        [wrongView addSubview:taskView];
        
    }
    
    CGRect wFrame = wrongView.frame;
    wFrame.size.width = SCREEN_WIDTH - 40;
    wFrame.size.height = size.height + tHeigh + 20;
    wrongView.frame = wFrame;
    } 
    [self.contentView addSubview:wrongView];
    
    self.height = wrongView.origin.y + wrongView.height + 20;

}

- (void)imageBtnClick:(UIButton *)sender {
    
    NSLog(@"点击了头像");

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
