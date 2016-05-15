//
//  YjyxOrderViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *orderTable;
    NSMutableArray *orderAry;
}

@end
