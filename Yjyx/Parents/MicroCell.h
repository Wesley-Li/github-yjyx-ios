//
//  MicroCell.h
//  Yjyx
//
//  Created by liushaochang on 16/6/29.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PMicroPreviewModel;
@interface MicroCell : UITableViewCell<UIWebViewDelegate>

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)setValuesWithModel:(PMicroPreviewModel *)model;


@end
