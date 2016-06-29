//
//  ChildrenResultCell.h
//  Yjyx
//
//  Created by liushaochang on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildrenResultModel;
@class ResultModel;
@interface ChildrenResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *solutionBtn;

@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSIndexPath *indexPath;





// 题目内容赋值
- (void)setSubviewsWithChildrenResultModel:(ChildrenResultModel *)model andResultModel:(ResultModel *)resultModel;




@end
