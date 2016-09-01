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
#import "YiTeachMicroController.h"




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
            
            if ([responseObject[@"content"] count] == 0) {
                
                UIImage *image = [UIImage imageNamed:@"isbuilding"];
                UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
                imageV.width = SCREEN_WIDTH - 80;
                imageV.height = image.size.height *imageV.width/image.size.width;
                imageV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                
                [self.view addSubview:imageV];

                
            }else {
            
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
            }
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:0.8];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismissWithDelay:0.8];

        NSLog(@"%@", error);
        
    }];
    
    
    
}

#pragma mark - TreeTableCellDelegate
// cell的点击方法
-(void)cellClick:(TreeNode *)item1{

    YiTeachMicroController *microVC = [[YiTeachMicroController alloc] init];
    
    microVC.version_id = self.version_id;
    microVC.subject_id = self.subject_id;
    microVC.classes_id = self.classes_id;
    microVC.book_id = self.book_id;
    microVC.textbookunitid = item1.nodeId;
    
    [self.navigationController pushViewController:microVC animated:YES];

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"m_getbootunit_lesson", @"action", self.version_id, @"textbookverid", self.subject_id, @"subjectid", self.classes_id, @"gradeid", self.book_id, @"textbookvolid", microVC.textbookunitid, @"textbookunitid", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[BaseURL stringByAppendingString:@"/api/student/product_yjmemeber/"] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            if ([responseObject[@"showview"] isEqual:@0]) {
                [self.view makeToast:@"暂无亿教课程" duration:1.0 position:SHOW_BOTTOM complete:nil];
            }else {
                
                
            }
            
        }else {
            
            [self.view makeToast:responseObject[@"msg"] duration:1 position:SHOW_CENTER complete:nil];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络出错了" duration:1 position:SHOW_CENTER complete:nil];
        
    }];

    
    
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
