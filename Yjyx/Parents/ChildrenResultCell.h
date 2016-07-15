//
//  ChildrenResultCell.h
//  Yjyx
//
//  Created by liushaochang on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildrenResultModel;
@class ResultModel, YjyxStuAnswerModel, YjyxWorkDetailModel;
@interface ChildrenResultCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *solutionBtn;// 亿教解析

@property (weak, nonatomic) IBOutlet UIButton *expandBtn;// 展开按钮

@property (weak, nonatomic) IBOutlet UIButton *annotationBtn;// 老师批注

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSIndexPath *indexPath;




// 题目内容赋值
- (void)setSubviewsWithChildrenResultModel:(ChildrenResultModel *)model andResultModel:(ResultModel *)resultModel;

// 学生端
- (void)setSubviewsWithWorkDetailModel:(YjyxWorkDetailModel *)model andStuResultModel:(YjyxStuAnswerModel *)resultModel;

@end
