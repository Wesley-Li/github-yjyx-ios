//
//  YjyxThreeStageAnswerController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxThreeStageAnswerController.h"
#import "YjyxThreeStageAnswerCell.h"
#import "YiTeachMicroController.h"
#import "YjyxThreeStageModel.h"
#import "YjyxMemberDetailViewController.h"
#import "ChildrenVideoViewController.h"
#import "YjyxKnowledgeCardView.h"

@interface YjyxThreeStageAnswerController ()<UITableViewDelegate, UITableViewDataSource, ThreeStageAnswerCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) YjyxKnowledgeCardView *knowledgeView;

@property (strong, nonatomic) NSMutableDictionary *heightDict;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) ProductEntity *entity;


@end

@implementation YjyxThreeStageAnswerController
static NSString *ID = @"CELL";


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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 左按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn addTarget:self action:@selector(goPreController) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"comm_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    [self setupRightNavItem];
    
    self.navigationItem.title = @"亿教课堂";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxThreeStageAnswerCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.heightDict = [NSMutableDictionary dictionary];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeight:) name:@"WEBVIEW_HEIGHT2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:@"WEBVIEW_HEIGHT3" object:nil];


}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 设置右按钮
- (void)setupRightNavItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"知识卡" style:UIBarButtonItemStylePlain target:self action:@selector(knowLedgeBtnClick)];
}

- (void)reloadView:(NSNotification *)noti
{
    CGFloat height = [noti.userInfo[@"hight"] floatValue];
    self.height  = height;
    [self.knowledgeView removeFromSuperview];
    self.knowledgeView = nil;
    [self.view addSubview:self.knowledgeView];
    
}



// 知识卡点击
- (void)knowLedgeBtnClick
{
    
    if ([self.view.subviews containsObject:self.knowledgeView]) {
        [self.knowledgeView removeFromSuperview];
    }else{
        [self.view addSubview:self.knowledgeView];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if(_openMember == 1){
        _openMember = 0;
       [self loadData]; 
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if(_openMember == 1){
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if([vc isKindOfClass:[YiTeachMicroController class]]){
                ((YiTeachMicroController *)vc).openMember = 1;
            }
        }
    }
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
        NSLog(@"%@", responseObject);
        [self.threeStageSubjectArr removeAllObjects];
        if ([responseObject[@"retcode"] integerValue] == 0) {
            for (NSDictionary *dict in responseObject[@"questionlist"]) {
                YjyxThreeStageModel *model = [YjyxThreeStageModel threeStageModelWithDict:dict];
                model.canview = responseObject[@"canview"];
                [self.threeStageSubjectArr addObject:model];
                
            }
            [self.tableView reloadData];
        }else{
            
                NSString *str = responseObject[@"msg"] == nil ? responseObject[@"reason"] : responseObject[@"msg"];
                [self.view makeToast:str duration:2.0 position:SHOW_CENTER complete:nil];
           
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        NSLog(@"%@", error.localizedDescription);
    }];
}

// 刷新高度
- (void)refreshHeight:(NSNotification *)noti
{
    YjyxThreeStageAnswerCell *cell = [noti object];
    NSLog(@"%f, %f", [[self.heightDict objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue], cell.height);
    if (![self.heightDict objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] || fabs([[self.heightDict objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2)
    {
        [self.heightDict setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (IBAction)changeSubjectBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goBackBtnClick:(id)sender {
    [self goPreController];
}
- (void)goPreController{
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[YiTeachMicroController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
// 获取会员信息
- (void)getMemberInfo
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"getonememproductinfo";
    param[@"subjectid"] = self.subjectid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/mobile/m_product/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] integerValue] == 0) {
            ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:responseObject];
            self.entity = entity;
        }else{
            [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}

#pragma mark -UITableViewDataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.threeStageSubjectArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxThreeStageAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.threeStageSubjectArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.deleagte = self;
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
#pragma mark - ThreeStageAnswerCellDelegate代理方法
- (void)threeStageAnswerCell:(YjyxThreeStageAnswerCell *)cell analysisBtnClick:(UIButton *)btn
{
//    YjyxStuWrongListCell *cell = (YjyxStuWrongListCell *)sender.superview.superview.superview;
    YjyxThreeStageModel *model = self.threeStageSubjectArr[cell.tag];
//    NSLog(@"%@,%@", model.videoUrl, model.explanation);
    
    if ([model.canview integerValue] == 0) {
        [self getMemberInfo];
        // 非会员
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"查看解题方法需要会员权限，是否前往试用或成为会员?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(self.entity == nil){
                [self.view makeToast:@"您的网络缓慢,请稍候尝试" duration:1.0 position:SHOW_CENTER complete:nil];
                return;
            }
            // 跳转至会员页面
            YjyxMemberDetailViewController *vc = [[YjyxMemberDetailViewController alloc] init];
            vc.productEntity = self.entity;
            vc.jumpType = 1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }else {
        ChildrenVideoViewController *vc = [[ChildrenVideoViewController alloc] init];
        vc.URLString = model.videourl;
        vc.explantionStr = model.explanation;
        vc.title = @"详解";
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}
@end
