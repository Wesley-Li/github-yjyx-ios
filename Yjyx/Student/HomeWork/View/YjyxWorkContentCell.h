//
//  YjyxWorkContentCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjyxWorkDetailModel ,YjyxStuAnswerModel;
@interface YjyxWorkContentCell : UITableViewCell
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) YjyxWorkDetailModel *finishModel;
@property (strong, nonatomic) YjyxStuAnswerModel *stuAsnwerModel;
@end
