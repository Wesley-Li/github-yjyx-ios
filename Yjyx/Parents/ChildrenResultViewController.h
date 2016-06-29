//
//  ChildrenResultViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/3/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildrenResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) IBOutlet UITableView *resultTable;
@property (nonatomic,strong) NSString *childrenCid;
@property (nonatomic,strong) NSString *taskResultId;




@end
