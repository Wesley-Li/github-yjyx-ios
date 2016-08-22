//
//  YiTeachChapterViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/8/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YiTeachChapterViewController.h"
#import "GradeContentItem.h"
#import "TreeNode.h"
#import "TreeTableView.h"
#import "YjyxThreeStageController.h"


@interface YiTeachChapterViewController ()<TreeTableCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *chapterArr;
@property (nonatomic, copy) NSNumber *root_id;

@end

@implementation YiTeachChapterViewController

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
    
    UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 setImage:[UIImage imageNamed:@"comm_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.title = @"亿教课堂";
    
    [self readDataFromNetWork];
    
    
}

// 网络请求
- (void)readDataFromNetWork {
    
    [SVProgressHUD showWithStatus:@"正在拼命加载数据....."];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getbookunit", @"action", _version_id, @"verid", _subject_id, @"subjectid", _classes_id, @"gradeid", _book_id, @"volid", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[BaseURL stringByAppendingString:@"/api/student/vgsv/"] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
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
            tableview.bounces = NO;
            [self.view addSubview:tableview];
            
            [SVProgressHUD dismissWithDelay:0.1];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:0.8];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
    
}

#pragma mark - TreeTableCellDelegate
// cell的点击方法
-(void)cellClick:(TreeNode *)item1{

    YjyxThreeStageController *threeStageVc = [[YjyxThreeStageController alloc] init];
    [self.navigationController pushViewController:threeStageVc animated:YES];
    
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