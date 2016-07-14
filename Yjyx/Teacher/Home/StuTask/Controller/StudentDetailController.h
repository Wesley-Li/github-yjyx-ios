//
//  StudentDetailController.h
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FinshedModel;

@interface StudentDetailController : UITableViewController


@property (nonatomic, strong) NSNumber *taskID;
@property (nonatomic, strong) NSNumber *studentID;
@property (nonatomic, copy) NSString *titleName;

@end
