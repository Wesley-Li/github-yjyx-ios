//
//  YjyxStuWrongListViewController.h
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxStuWrongListViewController : UITableViewController

@property (nonatomic, strong) NSNumber *subjectid;//科目ID
@property (nonatomic, strong) NSString *targetlist;//列表(JSON串)

@property (assign, nonatomic) NSInteger openMember; // 1代表开通了会员
@end
