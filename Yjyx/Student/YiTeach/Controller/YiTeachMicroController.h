//
//  YiTeachMicroController.h
//  Yjyx
//
//  Created by liushaochang on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiTeachMicroController : UIViewController


@property (strong, nonatomic) NSNumber *version_id;// 版本
@property (strong, nonatomic) NSNumber *subject_id;// 科目
@property (strong, nonatomic) NSNumber *classes_id;// 班级
@property (strong, nonatomic) NSNumber *book_id;// 册号
@property (copy, nonatomic) NSString *textbookunitid;// 节点id


@end
