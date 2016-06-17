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
#import "ChapterChoiceController.h"
#import "ChaperContentItem.h"

@interface ChapterViewController ()<TreeTableCellDelegate>

@property (weak, nonatomic) UILabel *title_label;
@property (strong, nonatomic) NSMutableArray *chaperItemArr;

@end

@implementation ChapterViewController

- (NSMutableArray *)chaperItemArr
{
    if (_chaperItemArr == nil) {
        _chaperItemArr = [NSMutableArray array];
    }
    return _chaperItemArr;
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
    // 标题label
    [self addTitleLabel];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.title_label.text = self.title1;
}

- (void)addTitleLabel
{
    UIView  *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 34)];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    self.title_label = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
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
// cell的点击方法
-(void)cellClick:(GradeContentItem *)item1 andVerVolItem:(GradeVerVolItem *)item andTreeNode:(TreeNode *)node{
    if(node.depth == 1){
       
        ChapterChoiceController *chapterVC = [[ChapterChoiceController alloc] init];
        
        chapterVC.g_id = item1.g_id;
        chapterVC.gradeid = item.gradeid;
        chapterVC.verid = item.verid;
        chapterVC.volid = item.volid;
        
        [self.navigationController pushViewController:chapterVC animated:YES];
        
    
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
