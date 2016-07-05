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
#import "OneSubjectController.h"
#import "MicroDetailViewController.h"
#import "MicroSubjectModel.h"
#import "MicroDetailViewController.h"
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

@property (assign, nonatomic) NSInteger flag;


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

- (NSMutableDictionary *)tagDic {

    if (!_tagDic) {
        self.tagDic = [NSMutableDictionary dictionary];
    }
    
    return _tagDic;
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
    if(_flag == 1){
      [self.bottom_button setTitle:[NSString stringWithFormat:@"确定(已选%ld题)", [[[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"2"] count]] forState:UIControlStateNormal];
    }else{
    [self.bottom_button setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", [[[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"1"] count]] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    
   
    for (UIViewController *vc in self.parentViewController.childViewControllers) {
        if([vc isKindOfClass:[MicroDetailViewController class]]){
            _flag = 1;
            break;
        }
    }
    self.last_id = @0;
    [self readDataFromNetWork];
    
    self.bottom_button.backgroundColor = RGBACOLOR(3, 138, 228, 1);

    self.title = self.t_text;
    // 导航栏右按钮的使用
    self.siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _siftBtn.frame = CGRectMake(0, 0, 50, 50);
    [_siftBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [_siftBtn addTarget:self action:@selector(sift:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_siftBtn];
    
    // tableview的属性设置
    self.tableView.backgroundColor = COMMONCOLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -49, 0);
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
        
//        self.tagDic = [@{@"knowledgetreeidvalue":_knowledgetreeidvalue} mutableCopy];
        [self.tagDic setObject:self.knowledgetreeidvalue forKey:@"knowledgetreeidvalue"];
        
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
            
            NSLog(@"%@", responseObject);
            
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
    cell.flag = _flag;
    cell.item = self.dataSoruce[indexPath.row];
    
    if (cell.item != nil) {
        NSMutableArray *arr = [NSMutableArray array];
        if (_flag == 1) {
            arr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", cell.item.t_id] andQuestionType:cell.item.subject_type andJumpType:@"2"];
        }else{
           arr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", cell.item.t_id] andQuestionType:cell.item.subject_type andJumpType:@"1"];
        }
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
    MicroSubjectModel *m_model = [[MicroSubjectModel alloc] init];
    m_model.s_id = [NSNumber numberWithInteger: model.t_id];
    m_model.content = model.content_text;
    NSLog(@"%@", model.subject_type);

    m_model.type = [model.subject_type integerValue];
    NSString *str = @"简单";
    if(model.level == 2){
        str = @"中等";
    }else if(model.level == 3){
        str = @"较难";
    }
    m_model.level = str;
    NSLog(@"%@", m_model);
    sender.selected = !sender.selected;
    model.add = sender.selected;
  
    if (sender.selected) {
        NSMutableArray *arr = [NSMutableArray array];
        if(_flag == 0){
        [[QuestionDataBase shareDataBase] insertQuestion:model];
        arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"1"];
        }else{
            [[QuestionDataBase shareDataBase] insertMirco:m_model];
            arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"2"];
        }
        NSNotification *notice = [NSNotification notificationWithName:@"bottomBtnNameChange" object:nil userInfo:@{@"key":arr}];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }else {
        NSMutableArray *arr = [NSMutableArray array];
        if (_flag == 0) {
            [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", model.t_id] andQuestionType:model.subject_type andJumpType:@"1"];
            arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"1"];
        }else{
            [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%@", m_model.s_id] andQuestionType:[NSString stringWithFormat:@"%ld", m_model.type] andJumpType:@"2"];
            arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"2"];
        }
        NSNotification *notice = [NSNotification notificationWithName:@"bottomBtnNameChange" object:nil userInfo:@{@"key":arr}];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }
    
}

// 通知回调
- (void)notice:(NSNotification *)sender {

    NSLog(@"%@",sender.userInfo[@"key"]);
    if(_flag == 1){
        [self.bottom_button setTitle:[NSString stringWithFormat:@"确定(已选%ld题)", [sender.userInfo[@"key"] count]] forState:UIControlStateNormal];
    }else{
       [self.bottom_button setTitle:[NSString stringWithFormat:@"点击预览作业(已选%ld题)", [sender.userInfo[@"key"] count]] forState:UIControlStateNormal];
    }
    
    


}

// 点击题目进入详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    OneSubjectController *oneVC = [[OneSubjectController alloc] init];
    
    ChaperContentItem *model = self.dataSoruce[indexPath.row];
    oneVC.chaperContentModel = model;

    NSString *str = @"choice";
    if ([model.subject_type isEqualToString:@"2"]) {
        str = @"blankfill";
     }
    oneVC.qtype = str;
    oneVC.w_id = [NSString stringWithFormat:@"%ld", model.t_id];
    oneVC.is_select = model.add ? 1 : 0;
  
    
    [self.navigationController pushViewController:oneVC animated:YES];
    
}



// 点击底部预览
- (IBAction)bottomBtnClick:(UIButton *)sender {
 
    QuestionPreviewController *previewVC = [[QuestionPreviewController alloc] init];
    
    NSMutableArray *arr = [NSMutableArray array];
    if (_flag == 1) {
        arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"2"];
        for (UIViewController *vc in self.parentViewController.childViewControllers) {
            if ([vc isKindOfClass:[MicroDetailViewController class]]) {
                MicroDetailViewController *vc1 = (MicroDetailViewController *)vc;
                vc1.addMicroArr = arr;
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        
        
    }else{
        arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"1"];
        if (arr.count == 0) {
            
            [self.view makeToast:@"您还没有选择题目,请选择" duration:1.0 position:SHOW_BOTTOM complete:nil];
        }else {
            
            previewVC.selectArr = [arr mutableCopy];
            previewVC.navigationItem.title = @"预览作业";
            [self.navigationController pushViewController:previewVC animated:YES];
            
        }
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
