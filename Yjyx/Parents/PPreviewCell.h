//
//  PPreviewCell.h
//  Yjyx
//
//  Created by liushaochang on 16/6/29.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPreviewCell : UITableViewCell<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSIndexPath *indexPath;


- (void)setSubviewWithContent:(NSString *)content;

@end
