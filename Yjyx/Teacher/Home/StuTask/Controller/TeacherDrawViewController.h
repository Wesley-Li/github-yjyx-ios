//
//  TeacherDrawViewController.h
//  Yjyx
//
//  Created by liushaochang on 16/7/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherDrawViewController : UIViewController



@property (strong, nonatomic) NSNumber *taskid;
@property (strong, nonatomic) NSNumber *suid;
@property (copy, nonatomic) NSString *qtype;
@property (strong, nonatomic) NSNumber *qid;

@property (strong, nonatomic) NSMutableDictionary *dic;
@property (assign, nonatomic) NSInteger imageIndex;
@property (strong, nonatomic) NSMutableArray *processArr;
@property (copy, nonatomic) NSString *stuName;

@end
