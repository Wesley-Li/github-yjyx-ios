//
//  MyChildrenViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyChildrenViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *childrenViews;
    NSMutableArray *totalAry;
    IBOutlet UISegmentedControl *segmentedControl;
    NSInteger segmentedIndex;
}
@property(weak,nonatomic) IBOutlet UITableView *childrenTab;
@property(strong,nonatomic) NSMutableArray *childrenAry;
@property(strong,nonatomic) NSMutableArray *activities;
@end
