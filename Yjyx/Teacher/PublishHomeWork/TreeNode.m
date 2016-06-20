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
static NSInteger i = 0;
static NSInteger j = 0;
static NSInteger k = 0;
+ (instancetype)treeNodeWithDictionary:(GradeContentItem *)item
{
    if (item.g_id.length == 4) {
        return nil;
    }
    
    NSLog(@"%@", item.text);
    
    TreeNode *node = [[self alloc] init];
    if(node.name.length < 4){
        node.name = item.text;
    }else{
        node.name = [item.text substringFromIndex:4];
    }
    node.nodeId = i++;
    if (item.g_id.length == 6 ) {
        node.parentId = -1;
        node.depth = 0;
        j = i - 1;
        node.expand = YES;
    }else if(item.g_id.length == 8){
        node.parentId = j;
        node.depth = 1;
        node.expand = NO;
        k = i - 1;
    }else if(item.g_id.length == 10){
        node.depth = 2;
        node.expand = NO;
        node.parentId = k;
        node.name = item.text;
    }
    return node;
}
- (void)setStaticPamar
{
    i = 0;
    j = 0;
    k = 0;
}
-(void)dealloc
{
    NSLog(@"delloc---------");
    i = 0;
    j = 0;
    k = 0;
}
@end
