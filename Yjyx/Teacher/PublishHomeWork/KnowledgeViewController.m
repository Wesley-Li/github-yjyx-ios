//
//  KnowledgeViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "GradeContentItem.h"
#import "TreeNode.h"
#import "TreeTableView.h"
#import "ChapterChoiceController.h"

@interface KnowledgeViewController ()<TreeTableCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *chapterArr;
@property (nonatomic, copy) NSNumber *root_id;

@end

@implementation KnowledgeViewController

- (NSMutableArray *)dataSource {

    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)chapterArr {

    if (!_chapterArr) {
        self.chapterArr = [NSMutableArray array];
    }
    return _chapterArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readDataFromNetWork];
    
}

// 网络请求
- (void)readDataFromNetWork {

    [SVProgressHUD showWithStatus:@"正在拼命加载数据"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getknowledgestruct", @"action", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_POST_CHAPTER_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            self.root_id = responseObject[@"id"];
            
            for (NSDictionary *dic in responseObject[@"content"]) {
                GradeContentItem *item = [GradeContentItem gradeContentItem:dic];
                [self.chapterArr addObject:item];
                
                TreeNode *node = [TreeNode treeNodeWithDictionary:item];
                [self.dataSource addObject:node];
            }
            
            
            self.automaticallyAdjustsScrollViewInsets = NO;
            TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT - 64) withData:self.dataSource];
            tableview.treeTableCellDelegate = self;
            tableview.chapterArray = self.chapterArr;
            
            [self.view addSubview:tableview];

            
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            [SVProgressHUD dismissWithDelay:0.8];
            
        }else {
        
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:0.8];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}


#pragma mark - TreeTableCellDelegate

- (void)cellClick:(GradeContentItem *)item1 andVerVolItem:(GradeVerVolItem *)item andTreeNode:(TreeNode *)node {

    ChapterChoiceController *chapterVC = [[ChapterChoiceController alloc] init];
    
    chapterVC.knowledgetreeidvalue = [NSString stringWithFormat:@"%@=%@", self.root_id, item1.g_id];
    
    
    
    [self.navigationController pushViewController:chapterVC animated:YES];
    

    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end