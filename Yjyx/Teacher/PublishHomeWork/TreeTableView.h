//
//  TreeTableView.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TreeNode;
@class GradeVerVolItem;
@class GradeContentItem;
@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (GradeContentItem *)node andVerVolItem:(GradeVerVolItem *)item andTreeNode:(TreeNode *)node;

@end

@interface TreeTableView : UITableView

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;
// 保存章节的模型数组
@property (strong, nonatomic) NSMutableArray *chapterArray;
// 保存书的版本号等的模型
@property (strong, nonatomic) GradeVerVolItem  *gradeNumItem;
-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@end
