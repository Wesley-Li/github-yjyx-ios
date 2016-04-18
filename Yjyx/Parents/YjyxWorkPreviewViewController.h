//
//  YjyxWorkPreviewViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxWorkPreviewViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) IBOutlet UITableView *previewTable;
@property (nonatomic,strong) NSString *previewRid;
@property (nonatomic,strong) NSArray *blankfills;//填充题
@property (nonatomic,strong) NSArray *choices;//选择题
@end
