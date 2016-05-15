//
//  OrderTableViewCell.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property(nonatomic ,weak) IBOutlet UILabel *orderSubject;
@property(nonatomic ,weak) IBOutlet UILabel *orderOutrade;
@property(nonatomic ,weak) IBOutlet UILabel *orderTime;
@property(nonatomic ,weak) IBOutlet UILabel *orderPrice;

@end
