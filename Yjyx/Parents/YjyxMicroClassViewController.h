//
//  YjyxMicroClassViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/3/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxMicroClassViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString *previewRid;//rid请求详细信息时，需要带
@property (nonatomic,strong) NSArray *blankfills;//填充题
@property (nonatomic,strong) NSArray *choices;//选择题
@property (nonatomic,strong) UITableView *subjectTable;
@end
