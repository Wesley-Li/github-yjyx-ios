//
//  YjyxThreeStageController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxThreeStageController.h"
#import "YjyxThreeStageSubjectCell.h"
#import "YjyxThreeStageModel.h"
#import "YjyxKnowledgeCardView.h"
#import "YjyxThreeStageAnswerController.h"
@interface YjyxThreeStageController ()<UITableViewDelegate, UITableViewDataSource, ThreeStageSubjectCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *threeStageArr;

@property (strong, nonatomic) NSMutableArray *randomFiveArr;

@property (strong, nonatomic) NSMutableDictionary *heightDict;

@property (weak, nonatomic) YjyxKnowledgeCardView *knowledgeView;

@property (assign, nonatomic) CGFloat height;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation YjyxThreeStageController
static NSString *ID = @"CELL";
#pragma mark - 懒加载
- (NSMutableArray *)threeStageArr
{
    if (_threeStageArr == nil) {
        _threeStageArr = [NSMutableArray array];
    }
    return _threeStageArr;
}
- (NSMutableArray *)randomFiveArr
{
    if (_randomFiveArr == nil) {
        _randomFiveArr = [NSMutableArray array];
    }
    return _randomFiveArr;
}
- (NSMutableDictionary *)heightDict
{
    if(_heightDict == nil){
        _heightDict = [NSMutableDictionary dictionary];
    }
    return _heightDict;
}
- (YjyxKnowledgeCardView *)knowledgeView
{
    if (_knowledgeView == nil) {
        YjyxKnowledgeCardView  *knowledgeView = [YjyxKnowledgeCardView knowledgeCardView];
        self.knowledgeView = knowledgeView;
        [_knowledgeView setKnowledgeContent:self.knowledge andHeight:self.height];
        _knowledgeView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    return _knowledgeView;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.navigationItem.title = @"亿教课堂";
    [self setupRightNavItem];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
   

    NSLog(@"%@", self.qidlist);

    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxThreeStageSubjectCell class]) bundle:nil] forCellReuseIdentifier:ID];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeight:) name:@"WEBVIEW_HEIGHT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:@"WEBVIEW_HEIGHT3" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
     NSMutableArray *tempArr = [NSMutableArray array];
    [self.randomFiveArr removeAllObjects];
    // 随机难度的5道题目
    if (self.qidlist.count <= 5) {
        [self.randomFiveArr addObjectsFromArray:self.qidlist];
    }else{
        while (self.randomFiveArr.count < 5) {
            int r = arc4random() % self.qidlist.count;
            if ([tempArr containsObject:@(r)]) {
                continue;
            }
            [tempArr addObject:@(r)];
            NSLog(@"%@", tempArr);
            [self.randomFiveArr addObject:self.qidlist[r]];
        }
    }
  
    [self.tableView setContentOffset:CGPointZero animated:YES];
    // 加载网络数据
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -私有方法
// 网络数据请求
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_getmany";
    param[@"subjectid"] = self.subjectid;
    param[@"qidlist"] = [self.randomFiveArr JSONString];
    NSLog(@"%@", param);
    [self.view makeToastActivity:SHOW_CENTER];
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/yj_questions/choice/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.view hideToastActivity];
//        NSLog(@"%@", responseObject);
        [self.threeStageArr removeAllObjects];
        if ([responseObject[@"retcode"] integerValue] == 0) {
            for (NSDictionary *dict in responseObject[@"questionlist"]) {
                YjyxThreeStageModel *model = [YjyxThreeStageModel threeStageModelWithDict:dict];
                model.canview = responseObject[@"canview"];
                [self.threeStageArr addObject:model];
                
            }
            self.submitBtn.enabled = YES;
            [self.tableView reloadData];
        }else{
            if (self.qidlist.count == 0) {
                self.submitBtn.enabled = NO;
                [self.view makeToast:@"暂没有添加题目,敬请期待..." duration:2.0 position:SHOW_CENTER complete:nil];
            }else{
                NSString *str = responseObject[@"msg"] == nil ? responseObject[@"reason"] : responseObject[@"msg"];
                [self.view makeToast:str duration:2.0 position:SHOW_CENTER complete:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        NSLog(@"%@", error.localizedDescription);
    }];
}
// 设置右按钮
- (void)setupRightNavItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"知识卡" style:UIBarButtonItemStylePlain target:self action:@selector(knowLedgeBtnClick)];
}
// 知识卡点击
- (void)knowLedgeBtnClick
{
    if (self.qidlist.count == 0) {
        return;
    }
    if ([self.view.subviews containsObject:self.knowledgeView]) {
        
        [self.knowledgeView removeFromSuperview];
        self.knowledgeView = nil;
    }else{
        [self.view addSubview:self.knowledgeView];
    }
    
}
// 刷新高度
- (void)refreshHeight:(NSNotification *)noti
{
    YjyxThreeStageSubjectCell *cell = [noti object];
    
    if (fabs([[self.heightDict objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2)
    {
        [self.heightDict setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)reloadView:(NSNotification *)noti
{
    CGFloat height = [noti.userInfo[@"hight"] floatValue];
    self.height  = height;
    [self.knowledgeView removeFromSuperview];
    self.knowledgeView = nil;
    [self.view addSubview:self.knowledgeView];
    
}
// 提交作业
- (IBAction)submitWorkBtnClick:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认提交作业?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        YjyxThreeStageAnswerController *vc = [[YjyxThreeStageAnswerController alloc] init];
        vc.threeStageSubjectArr = self.threeStageArr;
        vc.subjectid  = self.subjectid;
        vc.randomFiveArr = self.randomFiveArr;
        vc.knowledge = self.knowledge;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark -UITableViewDataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.threeStageArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxThreeStageSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.threeStageArr[indexPath.row];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[self.heightDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    
    if (height == 0) {
        
        return 300;
        
    }else {
        
        return height;
    }
}
#pragma mark -ThreeStageSubjectCellDelegate代理方法
- (void)threeStageSubjectCell:(YjyxThreeStageSubjectCell *)cell doingSubjectBtnClick:(UIButton *)btn
{
    YjyxThreeStageModel *model = self.threeStageArr[cell.tag];
    if(btn.selected == YES){
        if(model.stuAnswer == nil){
            model.stuAnswer = [NSString stringWithFormat:@"%ld", btn.tag - 200];
        }else{
            model.stuAnswer = [NSString stringWithFormat:@"%@|%ld", model.stuAnswer, btn.tag - 200];
        }
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithArray: [model.stuAnswer componentsSeparatedByString:@"|"]];
        if([arr containsObject:[NSString stringWithFormat:@"%ld", btn.tag - 200]]){
            [arr removeObject:[NSString stringWithFormat:@"%ld", btn.tag - 200]];
        }
        
        model.stuAnswer = [arr componentsJoinedByString:@"|"];
        if(arr.count == 0){
            model.stuAnswer = nil;
        }
    }
}
@end
