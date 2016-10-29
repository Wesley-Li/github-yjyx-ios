//
//  QuestionPreviewController.h
//  Yjyx
//
//  Created by liushaochang on 16/6/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YjyxWrongSubModel;
@interface QuestionPreviewController : UIViewController

@property (nonatomic, strong) NSMutableArray *selectArr;// 选中题目
@property (assign, nonatomic) NSInteger isMoved;
@property (strong, nonatomic) NSIndexPath *preSelIndexPath;
@property (strong, nonatomic) YjyxWrongSubModel *model; // 标记被删除的model
@end
