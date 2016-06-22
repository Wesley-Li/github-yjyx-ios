//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "TreeNode.h"
#import "ParentChapterCell.h"
#import "GradeContentItem.h"
#import "GradeVerVolItem.h"
@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）控制显示的行数


@end

@implementation TreeTableView

static NSString *NODE_CELL_ID = @"node_cell_id";
static NSString *NODE_CELL_ID2 = @"node_cell_id2";

-(instancetype)initWithFrame:(CGRect)frame withData : (NSMutableArray *)data{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _data = data;
        _tempData = [self createTempData:data];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ParentChapterCell class]) bundle:nil] forCellReuseIdentifier:NODE_CELL_ID];
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        TreeNode *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%ld", _tempData.count);
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
    ParentChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];

    TreeNode *node = [_tempData objectAtIndex:indexPath.row];

    cell.node = node;

    if (node.depth == 1) {
        if (node.expand == NO) {
            cell.imageV.image = [UIImage imageNamed:@"list_icon_1展开"];
        }else{
            cell.imageV.image = [UIImage imageNamed:@"list_icon_1"];
        }
    }else{

        for (int j = 0; j < _data.count; j++){
            TreeNode *sNode = [_data objectAtIndex:j];
     
            if(node.nodeId == sNode.parentId){
                if (!node.expand) {
                    cell.imageV.image = [UIImage imageNamed:@"list_icon_2展开"];
                }else{
                    cell.imageV.image = [UIImage imageNamed:@"list_icon_2"];
                }
                break;
            }else{
                cell.imageV.image = [UIImage imageNamed:@"list_icon_3"];
            }
        }
    }
    cell.chapterLabel.text = node.name;
    
    return cell;
}


#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd", indexPath.row);
    //先修改数据源
    TreeNode *parentNode = [_tempData objectAtIndex:indexPath.row];
    GradeContentItem *item = self.chapterArray[indexPath.row];
    GradeVerVolItem *item1 = self.gradeNumItem;
  
    
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    
    for (int i=0; i<_data.count; i++) {
        TreeNode *node = [_data objectAtIndex:i];
        if (node.parentId == parentNode.nodeId) {
            
            node.expand = !node.expand;
            if (node.expand) {
                
                [_tempData insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentNode];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        parentNode.expand = !parentNode.expand;
        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        if(indexPathArray.count <= 0){
            if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:andVerVolItem:andTreeNode:)]) {
                [_treeTableCellDelegate cellClick:parentNode andVerVolItem:item1 andTreeNode:parentNode];
            }
            return;
        }
        parentNode.expand = !parentNode.expand;
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];

//    [self reloadData];
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (TreeNode *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        TreeNode *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

@end
