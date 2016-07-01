//
//  MicroDetailViewController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroDetailViewController;
@protocol MicroDetailViewControllerDelegate <NSObject>

- (void)microDetailViewController:(MicroDetailViewController *)VC andName:(NSString *)name;

@end
@interface MicroDetailViewController : UITableViewController

@property (weak, nonatomic) id<MicroDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *addMicroArr;
@property (strong, nonatomic) NSNumber *m_id;
@end
