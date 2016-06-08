//
//  ParentChapterCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TreeNode;
@interface ParentChapterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVleadConstant;
@property (strong, nonatomic)  TreeNode *node;

@end
