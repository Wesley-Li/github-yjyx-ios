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
#import "OneStuTaskDetailViewController.h"
#import "StuDataBase.h"
#import "StudentEntity.h"
#import "TaskConditonModel.h"
#import "NextTableViewController.h"
#import "YourAnswerCell.h"

@interface AnswerSituationCell ()

@property (weak, nonatomic) IBOutlet UIView *bg_view;


@end

@implementation AnswerSituationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (NSArray *)r_arr {

    if (!_r_arr) {
        self.r_arr = [NSArray array];
    }
    return _r_arr;
}

- (NSArray *)w_arr {

    if (!_w_arr) {
        self.w_arr = [NSArray array];
    }
    return _w_arr;
}

- (void)setValueWithCorrectArray:(NSArray *)correctArray andWrongArray:(NSArray *)wrongArray {
    
    // 移除该视图上的所有子视图,不然走一次就会加一层
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }

    NSInteger totalCount = correctArray.count + wrongArray.count;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.summaryLabel.height, SCREEN_WIDTH - 20, 20)];
    if (correctArray.count == 0 || totalCount == 0) {
        contentLabel.text = [NSString stringWithFormat:@"答题人数%ld人, 正确率为0%%;", (long)totalCount];
    }else {
    
        contentLabel.text = [NSString stringWithFormat:@"答题人数%ld人, 正确率为%.f%%;", (long)totalCount, (correctArray.count * 1.0) * 100 / (totalCount * 1.0)];
    }
    
    contentLabel.font = [UIFont systemFontOfSize:12];
    [self.bg_view addSubview:contentLabel];
    
    
    // 答题正确人数
    self.correctView = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH, 0)];
//    _correctView.backgroundColor = [UIColor yellowColor];
    UILabel *correctLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    correctLabel.text = [NSString stringWithFormat:@"答题正确人数(%ld/%ld)", (long)correctArray.count, (long)totalCount];
    correctLabel.font = [UIFont systemFontOfSize:12];
    
    // 初始位置
    CGSize size = CGSizeMake(10, 30);
    CGFloat padding = 10;
    
    NSInteger num = 5;
    
    CGFloat tWidth = (_correctView.width - 40 - padding *(num + 1)) * 1.0 / num * 1.0;
    CGFloat tHeigh = tWidth + 20;

    if (correctArray.count == 0) {
        _correctView.frame = CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH, 0);
    }else{
    // 循环创建正确人数
    for (int i = 0; i < correctArray.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (_correctView.width - 40 - size.width == 0) {
            size.width = 10;
            size.height += tHeigh + 10;
        }
        
        // 头像
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
        imageBtn.tag = 200 + i;
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
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textAlignment = NSTextAlignmentCenter;
    
        [taskView addSubview:imageBtn];
        [taskView addSubview:nameLabel];
        [_correctView addSubview:correctLabel];
        [_correctView addSubview:taskView];
    
    }
    
    CGRect cframe = _correctView.frame;
    cframe.size.width = SCREEN_WIDTH - 40;
    cframe.size.height = size.height + tHeigh + 20;
    _correctView.frame = cframe;
    }
//    correctView.frame = CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH - 40, size.height + tHeigh + 20);
    
    // 将正确的人数添加到父视图
    [self.bg_view addSubview:_correctView];
    
    
    
    // 答题错误人数
    
    self.wrongView = [[UIView alloc] initWithFrame:CGRectMake(0, _correctView.origin.y + _correctView.height, SCREEN_WIDTH, 0)];
//    _wrongView.backgroundColor = [UIColor redColor];
    UILabel *wrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    wrongLabel.text = [NSString stringWithFormat:@"答题错误人数(%ld/%ld)", (long)wrongArray.count, (long)totalCount];
    wrongLabel.font = [UIFont systemFontOfSize:12];
    
    // 初始位置
    CGSize size2 = CGSizeMake(10, 30);
    CGFloat padding2 = 10;
    
    NSInteger num2 = 5;
    
    CGFloat tWidth2 = (_wrongView.width - 40 - padding2 *(num2 + 1)) * 1.0 / num2 * 1.0;
    CGFloat tHeigh2 = tWidth + 20;

    
    if (wrongArray.count == 0) {
        _wrongView.frame = CGRectMake(0, _correctView.origin.y + _correctView.height, SCREEN_WIDTH, 0);
    }else{
    // 循环创建错误人数
    for (int i = 0; i < wrongArray.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size2.width, size2.height, tWidth2, tHeigh2);
        
        size2.width += tWidth2 + padding2;
        
        if (_wrongView.width - 40 - size2.width == 0) {
            size2.width = 10;
            size2.height += tHeigh2 + 10;
        }
        
        // 头像
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(0, 0, tWidth2, tWidth2);
        imageBtn.tag = 200 + i;
        StudentEntity *studentEntity = [[StuDataBase shareStuDataBase] selectStuById:wrongArray[i]];
        
        if ([studentEntity.avatar_url isEqual:[NSNull null]]) {
            
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"stu_pic"] forState:UIControlStateNormal];
            
        }else {
            
            [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:studentEntity.avatar_url] placeholderImage:[UIImage imageNamed:@"stu_pic"]];
        }
        
        [imageBtn addTarget:self action:@selector(handleImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // 姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth2, tWidth2, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@", studentEntity.realname];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [taskView addSubview:imageBtn];
        [taskView addSubview:nameLabel];
        [_wrongView addSubview:wrongLabel];
        [_wrongView addSubview:taskView];
        
    }
    
    CGRect wFrame = _wrongView.frame;
    wFrame.size.width = SCREEN_WIDTH - 40;
    wFrame.size.height = size2.height + tHeigh2 + 20;
    _wrongView.frame = wFrame;
    } 
    [self.bg_view addSubview:_wrongView];
    
    self.height = _wrongView.origin.y + _wrongView.height + 30;

}

- (void)imageBtnClick:(UIButton *)sender {
    
//    NSLog(@"点击了正确头像");
    
    OneStuTaskDetailViewController *oneTaskVC = [[OneStuTaskDetailViewController alloc] init];
    oneTaskVC.taskid = self.taskid;
    oneTaskVC.qtype = self.qtype;
    oneTaskVC.suid = _r_arr[sender.tag - 200];
    oneTaskVC.right = @"YES";

    oneTaskVC.qid = self.qid;
    
    StudentEntity *stu = [[StuDataBase shareStuDataBase] selectStuById:_r_arr[sender.tag - 200]];
    
    oneTaskVC.title = [NSString stringWithFormat:@"%@", stu.realname];

    [self.navi.navigationController pushViewController:oneTaskVC animated:YES];


    
}

- (void)handleImageBtn:(UIButton *)sender {

//    NSLog(@"点击了错误头像");
    
    OneStuTaskDetailViewController *oneTaskVC = [[OneStuTaskDetailViewController alloc] init];
    oneTaskVC.taskid = self.taskid;
    oneTaskVC.qtype = self.qtype;
    oneTaskVC.suid = _w_arr[sender.tag - 200];
//    TaskConditonModel *model = _w_arr[sender.tag - 200];
    oneTaskVC.qid = self.qid;
    StudentEntity *stu = [[StuDataBase shareStuDataBase] selectStuById:_w_arr[sender.tag - 200]];
    oneTaskVC.title = [NSString stringWithFormat:@"%@", stu.realname];
//    oneTaskVC.answerArr = model.answerArr;
    [self.navi.navigationController pushViewController:oneTaskVC animated:YES];


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
