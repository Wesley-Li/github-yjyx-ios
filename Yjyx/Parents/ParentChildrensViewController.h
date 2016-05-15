//
//  ParentChildrensViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentChildrensViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property(weak,nonatomic) IBOutlet UITableView *childrenTab;
@property(strong,nonatomic) NSMutableArray *childrenAry;
@property (strong,nonatomic) UIImagePickerController *picker;
@end
