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
@property (nonatomic, strong) NSMutableArray *CStuArr;
@property (nonatomic, strong) NSMutableArray *WStuArr;
@property (nonatomic, strong) NSMutableArray *stuArr;

@end

@implementation AnswerSituationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.CStuArr = [NSMutableArray array];
    self.WStuArr = [NSMutableArray array];
}


- (void)setValueWithCorrectArray:(NSArray *)correctArray andWrongArray:(NSArray *)wrongArray {
    
    // 移除该视图上的所有子视图,不然走一次就会加一层
    for (UIView *view in [self.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
//    for (NSNumber *num in correctArray) {
//        StudentEntity *studentEntity = [[StuDataBase shareStuDataBase] selectStuById:num];
//        if ([studentEntity.realname isEqual:[NSNull null]] || studentEntity.realname == nil) {
//            [self getStuNameAndImageFromNetByids:correctArray];
//            [self.CStuArr addObjectsFromArray:self.stuArr];
//            break;
//        }
//        [self.CStuArr addObject:studentEntity];
//    }
//    
//    for (NSNumber *num in wrongArray) {
//        StudentEntity *studentEntity = [[StuDataBase shareStuDataBase] selectStuById:num];
//        if ([studentEntity.realname isEqual:[NSNull null]] || studentEntity.realname == nil) {
//            [self getStuNameAndImageFromNetByids:wrongArray];
//            [self.WStuArr addObjectsFromArray:self.stuArr];
//            break;
//        }
//        [self.WStuArr addObject:studentEntity];
//    }

    NSInteger totalCount = correctArray.count + wrongArray.count;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.summaryLabel.height, SCREEN_WIDTH - 20, 20)];
    if (correctArray.count == 0 || totalCount == 0) {
        contentLabel.text = [NSString stringWithFormat:@"答题人数%ld人, 正确率为0%%;", (long)totalCount];
    }else {
    
        contentLabel.text = [NSString stringWithFormat:@"答题人数%ld人, 正确率为%.f%%;", (long)totalCount, (correctArray.count * 1.0) * 100 / (totalCount * 1.0)];
    }
    
    contentLabel.font = [UIFont systemFontOfSize:13];
    [self.bg_view addSubview:contentLabel];
    
    
    // 答题正确人数
    self.correctView = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH, 0)];
//    _correctView.backgroundColor = [UIColor yellowColor];
    UILabel *correctLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    correctLabel.text = [NSString stringWithFormat:@"答题正确人数(%ld/%ld)", (long)correctArray.count, (long)totalCount];
    correctLabel.font = [UIFont systemFontOfSize:13];
    
    
    
    // 初始位置
    CGSize size = CGSizeMake(10, 30);
    CGFloat padding = 10;
    
    NSInteger num = 5;
    
    CGFloat tWidth = (_correctView.width - 40 - padding *(num + 1)) * 1.0 / num * 1.0;
    CGFloat tHeigh = tWidth + 20;
    
    UIButton *c_expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [c_expandBtn addTarget:self action:@selector(handleClickc_expandBtn:) forControlEvents:UIControlEventTouchUpInside];
    c_expandBtn.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 20, 20);
    if (_c_isExpand) {
        c_expandBtn.selected = YES;
        [c_expandBtn setImage:[UIImage imageNamed:@"fold_icon"] forState:UIControlStateNormal];
    }else {
        c_expandBtn.selected = NO;
        [c_expandBtn setImage:[UIImage imageNamed:@"unfold_icon"] forState:UIControlStateNormal];

    }
    [self.correctView addSubview:c_expandBtn];

    if (correctArray.count == 0) {
        c_expandBtn.hidden = YES;
        _correctView.frame = CGRectMake(0, contentLabel.origin.y + contentLabel.height, SCREEN_WIDTH, 0);
    }else{
    // 循环创建正确人数
        NSInteger tempCount;
        if (correctArray.count > num ) {
            c_expandBtn.hidden = NO;
            if (_c_isExpand == NO) {
                tempCount = num;
            }else {
                
                tempCount = correctArray.count;
            }
        }else {
            c_expandBtn.hidden = YES;
            tempCount = correctArray.count;
        }

        for (int i = 0; i < tempCount; i++) {
            
            UIView *taskView = [[UIView alloc] init];
            taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
            
            size.width += tWidth + padding;
            
            if (_correctView.width - 40 - size.width == 0) {
                size.width = 10;
                
                if (tempCount - i > 1) {
                    size.height += tHeigh + 10;
                }
                
            }
            
            // 头像
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.frame = CGRectMake(0, 0, tWidth, tWidth);
            imageBtn.layer.cornerRadius = tWidth / 2;
            imageBtn.layer.masksToBounds = YES;
            imageBtn.tag = 200 + i;
            
            StudentEntity *studentEntity = correctArray[i];
            
            // 姓名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth, tWidth, 20)];
            nameLabel.text = [NSString stringWithFormat:@"%@", studentEntity.realname];
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            
            if ([studentEntity.avatar_url isEqual:[NSNull null]]) {
                    
                [imageBtn setBackgroundImage:[UIImage imageNamed:@"student_p"] forState:UIControlStateNormal];
                    
            }else {
                    
                [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:studentEntity.avatar_url] placeholderImage:[UIImage imageNamed:@"student_p"]];
            }
            
            
            [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        
            [taskView addSubview:imageBtn];
            [taskView addSubview:nameLabel];
            [_correctView addSubview:correctLabel];
            [_correctView addSubview:taskView];
    
        }
    
    CGRect cframe = _correctView.frame;
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
    wrongLabel.font = [UIFont systemFontOfSize:13];
    
    // 初始位置
    CGSize size2 = CGSizeMake(10, 30);
    CGFloat padding2 = 10;
    
    NSInteger num2 = 5;
    
    CGFloat tWidth2 = (_wrongView.width - 40 - padding2 *(num2 + 1)) * 1.0 / num2 * 1.0;
    CGFloat tHeigh2 = tWidth + 20;

    UIButton *w_expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [w_expandBtn addTarget:self action:@selector(handleClickW_expandBtn:) forControlEvents:UIControlEventTouchUpInside];
    w_expandBtn.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 20, 20);
    
    if (_w_isExpand) {
        w_expandBtn.selected = YES;
        [w_expandBtn setImage:[UIImage imageNamed:@"fold_icon"] forState:UIControlStateNormal];
    }else {
        w_expandBtn.selected = NO;
        [w_expandBtn setImage:[UIImage imageNamed:@"unfold_icon"] forState:UIControlStateNormal];
        
    }
    [self.wrongView addSubview:w_expandBtn];
    
    if (wrongArray.count == 0) {
        w_expandBtn.hidden = YES;
        _wrongView.frame = CGRectMake(0, _correctView.origin.y + _correctView.height, SCREEN_WIDTH, 0);
    }else{
    // 循环创建错误人数
        NSInteger tempCount;
        if (wrongArray.count > num2 ) {
            w_expandBtn.hidden = NO;
            if (_w_isExpand == NO) {
                tempCount = num2;
            }else {
                
                tempCount = wrongArray.count;
            }
        }else {
            w_expandBtn.hidden = YES;
            tempCount = wrongArray.count;
        }

        
        for (int i = 0; i < tempCount; i++) {
            
            UIView *taskView = [[UIView alloc] init];
            taskView.frame = CGRectMake(size2.width, size2.height, tWidth2, tHeigh2);
            
            size2.width += tWidth2 + padding2;
            
            if (_wrongView.width - 40 - size2.width <= 0) {
                size2.width = 10;
                if (tempCount - i > 1) {
                    size2.height += tHeigh2 + 10;
                }
                
            }
            
            // 头像
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.frame = CGRectMake(0, 0, tWidth2, tWidth2);
            imageBtn.layer.cornerRadius = tWidth2 / 2;
            imageBtn.layer.masksToBounds = YES;
            imageBtn.tag = 200 + i;
            
            StudentEntity *studentEntity = wrongArray[i];
            
            // 姓名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tWidth2, tWidth2, 20)];
            nameLabel.text = [NSString stringWithFormat:@"%@", studentEntity.realname];
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.textAlignment = NSTextAlignmentCenter;

            if ([studentEntity.avatar_url isEqual:[NSNull null]]) {
                [imageBtn setBackgroundImage:[UIImage imageNamed:@"student_p"] forState:UIControlStateNormal];
            }else {
                [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:studentEntity.avatar_url] placeholderImage:[UIImage imageNamed:@"student_p"]];
            }
            

            [imageBtn addTarget:self action:@selector(handleImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [taskView addSubview:imageBtn];
            [taskView addSubview:nameLabel];
            [_wrongView addSubview:wrongLabel];
            [_wrongView addSubview:taskView];
            
        }
    
    CGRect wFrame = _wrongView.frame;
    wFrame.size.height = size2.height + tHeigh2 + 20;
    _wrongView.frame = wFrame;
    } 
    [self.bg_view addSubview:_wrongView];
    
    self.height = _wrongView.origin.y + _wrongView.height + 30;
    
    

}

/*
// 根据学生id列表获取学生的头像和姓名
- (void)getStuNameAndImageFromNetByids:(NSArray *)idArr {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"studentdisattr", @"action", [idArr JSONString], @"ids", nil];
    [manager GET:[BaseURL stringByAppendingString:@"/api/teacher/mobile/yj_teachers/"] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            for (NSDictionary *dic in responseObject[@"students"]) {
               
                StudentEntity *entity = [[StudentEntity alloc] init];
                [entity initStudentWithDic:dic];
                [self.stuArr addObject:entity];
                
            }
            
        }else {
        
            [self.contentView makeToast:responseObject[@"msg"] duration:1 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self.contentView makeToast:@"网络出错" duration:1 position:SHOW_CENTER complete:nil];
        
    }];

}
*/
- (void)imageBtnClick:(UIButton *)sender {
    
    [self.delegate handlePushCorrectWithSender:sender];
    
}

- (void)handleImageBtn:(UIButton *)sender {

    [self.delegate handlePushWrongWithSender:sender];

}

- (void)handleClickc_expandBtn:(UIButton *)sender {

    [self.delegate handleTapCorrectExpandBtn:sender];
}

- (void)handleClickW_expandBtn:(UIButton *)sender {
    
    [self.delegate handleTapWrongExpandBtn:sender];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
