//
//  ChapterChoiceController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChapterChoiceController.h"
#import "subjectContentCell.h"
#import "ChaperContentItem.h"
#import "siftContentView.h"
#import "MJRefresh.h"
#import "QuestionPreviewController.h"
#import "QuestionDataBase.h"

#define ID @"subjectContentCell"
@interface ChapterChoiceController ()<UITableViewDelegate, UITableViewDataSource, siftContentViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bottom_button;
@property (nonatomic, strong) UIButton *siftBtn;// 筛选按钮
@property (strong, nonatomic) siftContentView *siftV;// 筛选菜单
@property (nonatomic, strong) NSMutableArray *dataSoruce;// 数据源
@property (nonatomic, strong) NSMutableArray *addArray;// 已选题目

@property (nonatomic, strong) NSNumber *last_id;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) NSMutableDictionary *tagDic;// 标签字典


@end

@implementation ChapterChoiceController

- (NSMutableArray *)dataSoruce {

    if (!_dataSoruce) {
        self.dataSoruce = [NSMutableArray array];
    }
    return _dataSoruce;
}

- (NSMutableArray *)addArray {

    if (!_addArray) {
        self.addArray = [NSMutableArray array];
    }
    return _addArray;
}


// 懒加载筛选view
- (siftContentView *)siftV
{
    if (_siftV == nil) {
        siftContentView *siftV = [siftContentView siftContentViewFromXib];
        siftV.delegate = self;
        siftV.frame = CGRectMake(0,  -(SCREEN_HEIGHT - 64) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        [self.view  insertSubview:siftV aboveSubview:self.tableView];
        _siftV = siftV;
    }
    return _siftV;
}

- (void)viewWillAppear:(BOOL)animated {

    // 注册通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"bottomBtnNameChange" object:nil];
    [self.bottom_button setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", [[[QuestionDataBase shareDataBase] selectAllQuestion] count]] forState:UIControlStateNormal];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    
    self.last_id = @0;
    [self readDataFromNetWork];
    
    self.bottom_button.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    self.tagDic = [NSMutableDictionary dictionary];
    
    // 导航栏右按钮的使用
    self.siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _siftBtn.frame = CGRectMake(0, 0, 50, 50);
    [_siftBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [_siftBtn addTarget:self action:@selector(sift:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_siftBtn];
    
    // tableview的属性设置
    self.tableView.backgroundColor = COMMONCOLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([subjectContentCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    // 加载刷新按钮
    [self loadRefresh];
    
 
    
}


// 加载刷新按钮
- (void)loadRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView  addFooterWithTarget:self action:@selector(loadMoreData)];
}


// 头部刷新 加载新数据
- (void)loadNewData
{
    self.last_id = @0;
    [self readDataFromNetWork];
}


// 尾部刷新 加载更多数据
- (void)loadMoreData
{
    ChaperContentItem *model = self.dataSoruce.lastObject;
    self.last_id = [NSNumber numberWithInteger:model.t_id];
    [self readDataFromNetWork];
}


// 筛选按钮的点击
- (void)sift:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"%zd", btn.selected);

    if(btn.selected){
    self.siftV.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT - 64);
        
    }else{
        
    self.siftV.transform = CGAffineTransformMakeTranslation(0, -(SCREEN_HEIGHT - 64));
        
    }

    
}


// 网络请求
- (void)readDataFromNetWork {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    
    pamar[@"action"] = @"m_search";
    
    // 题目类型
    if (self.questionType == nil) {
        pamar[@"question_type"] = @"choice";
    }else {
    
        pamar[@"question_type"] = self.questionType;
    }
    
    pamar[@"lastid"]  = _last_id;
    
    self.urlString = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"%@?action=%@&question_type=%@&lastid=%@", SEARCH_QUESTION_GET, pamar[@"action"], pamar[@"question_type"], pamar[@"lastid"]]];

    // 章节可选
    if (self.g_id != nil && self.verid != nil && self.gradeid != nil && self.volid != nil) {
      
        // 章节信息
        pamar[@"sgt_dict"] = @{
                               
                               @"textbookunitid" : _g_id,
                               @"textbookverid" : @(_verid),
                               @"gradeid" : @(_gradeid),
                               @"textbookvolid" : @(_volid)
                               };
        
        NSString *aString = [pamar[@"sgt_dict"] JSONString];
        
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"&sgt_dict=%@", aString]];
        
    }
    // 标签信息,知识点可选
    if (self.knowledgetreeidvalue != nil) {
        
        self.tagDic = [@{@"knowledgetreeidvalue":_knowledgetreeidvalue} mutableCopy];
//        [self.tagDic setObject:self.knowledgetreeidvalue forKey:@"knowledgetreeidvalue"];
        
        NSString *tagString = [self.tagDic JSONString];
       
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"&tags=%@", tagString]];
        
    }

    // 标签信息,难度可选
    if (self.level != nil) {
        [self.tagDic setObject:self.level forKey:@"level"];
        NSString *tagString = [self.tagDic JSONString];
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"&tags=%@", tagString]];
    }
    
    NSLog(@"%@", self.urlString);
    
    NSString *urlEcoding = [self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [SVProgressHUD showWithStatus:@"正在请求数据..."];
    [manager GET:urlEcoding parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 临时数组
        NSMutableArray *currentArr = [NSMutableArray array];
        
        if ([responseObject[@"retcode"] isEqual: @0]) {
            
            for (NSArray *tempArr in responseObject[@"retlist"]) {
              
                ChaperContentItem *model = [ChaperContentItem chaperContentItemWithArray:tempArr];

                [currentArr addObject:model];
            
            }
            
//            NSLog(@"%@", currentArr);

            if ([self.last_id isEqual:@0]) {
                
                [self.dataSoruce removeAllObjects];
                [self.dataSoruce addObjectsFromArray:currentArr];
                [self.tableView headerEndRefreshing];
            }else {
            
                [self.dataSoruce addObjectsFromArray:currentArr];
                [self.tableView footerEndRefreshing];
            }
            
            [self.tableView reloadData];
            
            if (self.dataSoruce.count == 0) {
                
                [SVProgressHUD showErrorWithStatus:@"暂时还没有响应题目,我们会尽快添加,敬请期待"];
                [SVProgressHUD dismissWithDelay:2.0];
                
            }else {
                
                [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
                [SVProgressHUD dismissWithDelay:0.8];

            
            }
            
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD dismiss];
    }];

    
}


#pragma mark - UITableView的数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSoruce.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    subjectContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = self.dataSoruce[indexPath.row];
    
    if (cell.item != nil) {
        
        NSMutableArray *arr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", cell.item.t_id] andQuestionType:cell.item.subject_type];
        
        if (arr.count != 0) {
            cell.addBtn.selected = YES;
        }else {
            
            cell.addBtn.selected = NO;
        }

    }
    

    cell.addBtn.tag = indexPath.row + 200;
    [cell.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.subjectNumLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChaperContentItem *item = self.dataSoruce[indexPath.row];
    return item.cellHeight;
}

// 点击加号,选题
- (void)addBtnClick:(UIButton *)sender {

    NSInteger row = sender.tag - 200;
    ChaperContentItem *model = self.dataSoruce[row];
    
    if (!sender.selected) {
        
        sender.selected = YES;
        [[QuestionDataBase shareDataBase] insertQuestion:model];
        NSMutableArray *arr = [[QuestionDataBase shareDataBase] selectAllQuestion];
        NSNotification *notice = [NSNotification notificationWithName:@"bottomBtnNameChange" object:nil userInfo:@{@"key":arr}];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }else {
    
        sender.selected = NO;
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", model.t_id] andQuestionType:model.subject_type];
        NSMutableArray *arr = [[QuestionDataBase shareDataBase] selectAllQuestion];
        NSNotification *notice = [NSNotification notificationWithName:@"bottomBtnNameChange" object:nil userInfo:@{@"key":arr}];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }
    
}

// 通知回调
- (void)notice:(NSNotification *)sender {

    NSLog(@"%@",sender.userInfo[@"key"]);
    [self.bottom_button setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", [sender.userInfo[@"key"] count]] forState:UIControlStateNormal];
    


}

// 点击底部预览
- (IBAction)bottomBtnClick:(UIButton *)sender {
    
    QuestionPreviewController *previewVC = [[QuestionPreviewController alloc] init];
    NSMutableArray *arr = [[QuestionDataBase shareDataBase] selectAllQuestion];

    if (arr.count == 0) {
        
        [self.view makeToast:@"您还没有选择题目,请选择" duration:1.0 position:SHOW_BOTTOM complete:nil];
    }else {
        
        previewVC.selectArr = [arr mutableCopy];
        previewVC.navigationItem.title = @"预览作业";
        [self.navigationController pushViewController:previewVC animated:YES];

    }
    
    
}


#pragma mark - siftContentViewDelegate
- (void)configurePamra {

    self.questionType = self.siftV.questionType;
    self.level = self.siftV.level;
    self.siftBtn.selected = !_siftBtn.selected;
    [self loadNewData];
    
    
}

@end