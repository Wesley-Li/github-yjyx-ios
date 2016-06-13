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
#import <AFNetworking.h>

#import <SVProgressHUD/SVProgressHUD.h>
@interface ChapterViewController ()<TreeTableCellDelegate>

@property (weak, nonatomic) UILabel *title_label;
@property (strong, nonatomic) NSMutableArray *chaperItemArr;
@property (strong, nonatomic) AFHTTPSessionManager *mgr;
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
- (void)viewWillDisappear:(BOOL)animated
{
    // 取消网络请求
    [self.mgr.operationQueue cancelAllOperations];
    [SVProgressHUD dismiss];
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
       AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        self.mgr = mgr;
        NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
        
        NSLog(@"%ld,%ld,%ld,%@", item.verid, item.volid, item.gradeid, item1.g_id);
        pamar[@"action"] = @"m_search";
        pamar[@"question_type"] = @"choice";
        pamar[@"lastid"]  = @0;
        
        pamar[@"sgt_dict"] = @{
                            
                               @"textbookunitid" : [NSString stringWithFormat:@"%@|%@",item1.parent ,item1.g_id],
                               @"textbookverid" : @(item.verid),
                               @"gradeid" : @(item.gradeid),
                               @"textbookvolid" : @(item.volid)
                               };
        [self.chaperItemArr removeAllObjects];
        [SVProgressHUD showWithStatus:@"正在请求数据..."];
        [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/mobile/question/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

            if ([responseObject[@"retcode"] isEqual: @(0)]) {
                for (NSArray *tempArr in responseObject[@"retlist"]) {
                    if([ChaperContentItem chaperContentItemWithArray:tempArr] == nil){
                        continue;
                    }
                   [self.chaperItemArr addObject:[ChaperContentItem chaperContentItemWithArray:tempArr]];
                }
                ChapterChoiceController *choiceVc = [[ChapterChoiceController alloc] init];
                choiceVc.chapterItemArray = self.chaperItemArr;
                [self.navigationController pushViewController:choiceVc animated:YES];
                [SVProgressHUD dismiss];
            }else{
                [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                
                [SVProgressHUD dismiss];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
            [SVProgressHUD dismiss];
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
