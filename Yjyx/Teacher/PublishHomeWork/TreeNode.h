//
//  TreeNode.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GradeContentItem;
@interface TreeNode : NSObject

@property (nonatomic , copy) NSString *parentId;//父节点的id，如果为-1表示该节点为根节点

@property (nonatomic , copy) NSString *nodeId;//本节点的id

@property (nonatomic , copy) NSString *name;//本节点的名称

@property (nonatomic , assign) int depth;//该节点的深度

@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态

@property (nonatomic, assign) BOOL show;// 该节点是否显示

+ (instancetype)treeNodeWithDictionary:(GradeContentItem *)item;


@end
