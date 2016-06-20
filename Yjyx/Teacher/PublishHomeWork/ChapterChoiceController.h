//
//  ChapterChoiceController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterChoiceController : UIViewController

/*
 * 章节目录
 */
@property (copy, nonatomic) NSString *g_id;
// 年级号
@property (assign, nonatomic) NSInteger gradeid;
// 上下册
@property (assign, nonatomic) NSInteger volid;
// 版本号
@property (assign, nonatomic) NSInteger verid;

@property (nonatomic, copy) NSString *questionType;// 题目类型
@property (nonatomic, copy) NSString *level;// 难度
@property (nonatomic, copy) NSString *knowledgetreeidvalue;// 知识点

@end
