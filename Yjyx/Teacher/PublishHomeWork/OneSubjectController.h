//
//  OneSubjectController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjyxWrongSubModel;
@interface OneSubjectController : UIViewController

@property (copy, nonatomic) NSString *qtype;
@property (copy, nonatomic) NSString *w_id;
@property (assign, nonatomic) NSInteger is_select;

@property (strong, nonatomic) YjyxWrongSubModel *wrongSubjectModel;
@end
