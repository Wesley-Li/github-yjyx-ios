//
//  ChapterViewController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChapterViewController.h"
#import "GradeContentItem.h"
#import "TreeNode.h"
#import "TreeTableView.h"
#import "GradeVerVolItem.h"
@interface ChapterViewController ()<TreeTableCellDelegate>

@property (weak, nonatomic) UILabel *title_label;
@end

@implementation ChapterViewController
- (void)dealloc
{
    NSLog(@"-------");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMONCOLOR;
    [self loadBackBtn];
    self.navigationItem.title = @"选择出题";
    NSMutableArray *data = [NSMutableArray array];
    for (GradeContentItem *item in _chaperArr) {
        TreeNode *node = [TreeNode treeNodeWithDictionary:item];
        if (node == nil) {
            continue;
        }
        [data addObject:node];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 64+49, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 49) withData:data];
    tableview.treeTableCellDelegate = self;
    tableview.chapterArray = self.chaperArr;
    tableview.gradeNumItem = self.GradeNumItem;
    tableview.bounces = NO;
    [self.view addSubview:tableview];
    [self addTitleLabel];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.title_label.text = self.title1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)addTitleLabel
{
    UIView  *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 34)];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    self.title_label = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = self.title1;
    [titleView addSubview:titleLabel];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(titleView.width - 30, 5, titleView.height - 10 , titleView.height - 10 )];
    imageV.image = [UIImage imageNamed:@"list_icon_2-1"];
    [titleView insertSubview:imageV aboveSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClicked)];
    [titleView addGestureRecognizer:tap];
}

- (void)titleClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(TreeNode *)node{
    NSLog(@"%@",node.name);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
