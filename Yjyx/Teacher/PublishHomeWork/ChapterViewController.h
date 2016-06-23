//
//  ChapterViewController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GradeVerVolItem;
@interface ChapterViewController : UIViewController 
//  章节内容数组
@property (strong, nonatomic) NSMutableArray *chaperArr;
// 标题属性
@property (copy, nonatomic) NSString *title1;
// 书本编号模型
//@property (strong, nonatomic) GradeVerVolItem *GradeNumItem;

@property (assign, nonatomic) NSInteger gradeid;
@property (assign, nonatomic) NSInteger volid;
@property (assign, nonatomic) NSInteger verid;

@end
