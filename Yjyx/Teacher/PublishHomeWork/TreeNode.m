//
//  TreeNode.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TreeNode.h"
#import "GradeContentItem.h"
@implementation TreeNode

static NSInteger line_num;// 下滑线个数


+ (instancetype)treeNodeWithDictionary:(GradeContentItem *)item
{
    
    
    TreeNode *node = [[self alloc] init];
    NSString *subString = @"_";
    
    node.parentId = item.parent;
    node.nodeId = item.g_id;
    node.name = item.text;
    
    
    if ([item.parent isEqualToString:@"#"]) {
        
        NSArray *arr = [node.nodeId componentsSeparatedByString:subString];
        line_num = arr.count - 1;
        node.depth = 0;
        node.expand = NO;
    }else {
        
        NSArray *arr = [node.nodeId componentsSeparatedByString:subString];
        node.depth = arr.count - 1 - line_num;
        if (node.depth == 1) {
            node.expand = YES;
        }else {
        
            node.expand = NO;
        }

    
    }
    
    return node;
}


@end
