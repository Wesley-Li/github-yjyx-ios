//
//  StudentDetailViewController.h
//  Yjyx
//
//  Created by peng on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FinshedModel;
@interface StudentDetailViewController : UIViewController
    


@property (nonatomic, strong) NSNumber *taskID;
@property (nonatomic,strong)  FinshedModel * finshedModel;
@end
