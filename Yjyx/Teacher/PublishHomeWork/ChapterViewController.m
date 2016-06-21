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

#import "BookViewController.h"




@interface ChapterViewController ()<TreeTableCellDelegate>

@property (weak, nonatomic) UILabel *title_label;
@property (strong, nonatomic) NSMutableArray *chaperItemArr;

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ChapterViewController
#pragma mark - 懒加载
- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (NSMutableArray *)chaperItemArr
{
    if (_chaperItemArr == nil) {
        _chaperItemArr = [NSMutableArray array];
    }
    return _chaperItemArr;
}
- (NSMutableArray *)chaperArr
{
    if (_chaperArr == nil) {
        _chaperArr = [NSMutableArray array];
    }
    return _chaperArr;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMONCOLOR;
//    [self loadBackBtn];
    UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn1 setImage:[UIImage imageNamed:@"comm_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    [self loadData];
    self.navigationItem.title = @"选择出题";
    // 标题label
    [self addTitleLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    self.title_label.text = self.title1;
   

}

- (void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    
    pamar[@"action"] = @"getbookunit";
    pamar[@"gradeid"] = @(_gradeid);
    pamar[@"verid"] = @(_verid);
    pamar[@"volid"] = @(_volid);
    [self.chaperArr removeAllObjects];
    
    [mgr GET:[BaseURL stringByAppendingString:TEACHER_POST_CHAPTER_CONNECT_GET] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] isEqual:@0]) {
            [responseObject writeToFile:@"/Users/wangdapeng/Desktop/文件/5.plist" atomically:YES];
            
            for (NSDictionary *dict in responseObject[@"content"]) {
                
                GradeContentItem *item = [GradeContentItem gradeContentItem:dict];
                [self.chaperArr addObject:item];
            }
            
            
            [self.data removeAllObjects];
            for (GradeContentItem *item in _chaperArr) {
                TreeNode *node = [TreeNode treeNodeWithDictionary:item];
                if (node == nil) {
                    continue;
                }
                [self.data addObject:node];
            }
            self.automaticallyAdjustsScrollViewInsets = NO;
            TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 64+49, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 49) withData:_data];
            tableview.treeTableCellDelegate = self;
            tableview.chapterArray = self.chaperArr;
            tableview.gradeNumItem = self.GradeNumItem;
            tableview.bounces = NO;
            [self.view addSubview:tableview];
        }else{
            
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
- (void)goBack{
    [self.navigationController popToViewController:self.navigationController.childViewControllers[0] animated:YES];
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

    if (self.navigationController.childViewControllers.count == 2) {
            BookViewController *bookVc = [[BookViewController alloc] init];
        bookVc.verVolArr = [self.title1 componentsSeparatedByString:@"-"];
            [self.navigationController pushViewController:bookVc animated:YES];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - TreeTableCellDelegate
// cell的点击方法
-(void)cellClick:(GradeContentItem *)item1 andVerVolItem:(GradeVerVolItem *)item andTreeNode:(TreeNode *)node{

       
        ChapterChoiceController *chapterVC = [[ChapterChoiceController alloc] init];
        
        chapterVC.g_id = item1.g_id;
        chapterVC.gradeid = item.gradeid;
        chapterVC.verid = item.verid;
        chapterVC.volid = item.volid;
        
        [self.navigationController pushViewController:chapterVC animated:YES];
        
    

    
}

@end
