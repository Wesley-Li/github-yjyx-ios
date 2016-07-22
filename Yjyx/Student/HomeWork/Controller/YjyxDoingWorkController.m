//
//  YjyxDoingWorkController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDoingWorkController.h"
#import <WebKit/WebKit.h>
#import "YjyxDoingView.h"
#import "YjyxDoingWorkModel.h"
#import "YjyxWorkResultView.h"
#import "YjyxDraftView.h"
#import "Masonry.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "SVProgressHUD.h"
#import "UploadImageTool.h"

#import "YjyxWorkDetailController.h"
#import "YjyxOneSubjectViewController.h"
@interface YjyxDoingWorkController ()<UIWebViewDelegate, UIScrollViewDelegate, DoingViewDelegate, WorkResultDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TZImagePickerControllerDelegate>
{
    NSInteger count; // 题目的个数
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    NSMutableArray *_urlArr;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait; //
@property (weak, nonatomic) IBOutlet UIButton *answerWorkCardBtn; // 答题卡按钮

@property (strong, nonatomic) NSMutableArray *doWorkArr;  // 模型数组
@property (strong, nonatomic) NSMutableArray *answerArr;  // 答案数组
@property (assign, nonatomic) NSInteger stuDoWorkNum;

@property (weak, nonatomic) IBOutlet UILabel *titlenumberLabel;  // 当前题号
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;  // 总题数
@property (weak, nonatomic) IBOutlet UILabel *workNameLabel; // 作业描述
@property (weak, nonatomic) IBOutlet UILabel *consumeTimeLabel;

@property (assign, nonatomic) NSInteger consumeTime; // 消耗的时间
@property (strong, nonatomic) NSTimer *timer;

//@property (weak, nonatomic) UIView *bg_view; // 解题步骤的背景
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableDictionary *viewDict; // 保存图片数组的字典
@property (strong, nonatomic) NSMutableDictionary *urlDict; // 保存图片url的字典

@property (assign, nonatomic) NSInteger flag;
@property (weak, nonatomic) YjyxDraftView *draftV;


@property (strong, nonatomic) NSMutableArray *countTimeArr; // 每道题计时数组
@property (assign, nonatomic) NSInteger preTime;
@property (assign, nonatomic) NSInteger preIndex;
@end

@implementation YjyxDoingWorkController
- (YjyxDraftView *)draftV
{
    if (_draftV == nil) {
        YjyxDraftView *draftV = [YjyxDraftView draftView];
//        draftV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        draftV.x = 0;
        draftV.y = -SCREEN_HEIGHT;
        draftV.width = SCREEN_WIDTH;
        draftV.height = SCREEN_HEIGHT;
        self.draftV = draftV;
    }
    return _draftV;
}
- (NSMutableArray *)countTimeArr
{
    if (_countTimeArr == nil) {
        _countTimeArr = [NSMutableArray array];
    }
    return _countTimeArr;
}
#pragma mark - view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _doWorkArr = [NSMutableArray array];
    _answerArr = [NSMutableArray array];

    if([self.type isEqual:@1]){
        if(self.jumpDoworkArr != nil){
            // 开启定时器
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            _timer = timer;
            self.doWorkArr = self.jumpDoworkArr;
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%ld", self.doWorkArr.count];
            self.titlenumberLabel.text = [NSString stringWithFormat:@"%@", self.doWorkArr.count > 0 ? @"1" : @"0"];
        
            count = self.doWorkArr.count;
            
            
            for (int i = 0; i < count; i++) {
                NSMutableArray *arr = [NSMutableArray array];
                [self.answerArr addObject:arr];
            }
            for (int i = 0; i < self.doWorkArr.count; i++) {
                NSNumber *timeNum = [[NSNumber alloc ] initWithInt:0];
                [self.countTimeArr addObject:timeNum];
            }
            self.preTime = 0;
            self.preIndex = 1;
            if(count == 0){
                [SVProgressHUD showInfoWithStatus:@"暂没有添加作业..."];
            }
        }else{
           [self loadData];
        }
       
    }else{
        if (self.jumpDoworkArr != nil) {
            // 开启定时器
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            _timer = timer;
            self.doWorkArr = self.jumpDoworkArr;
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%ld", self.doWorkArr.count];
            self.titlenumberLabel.text = [NSString stringWithFormat:@"%@", self.doWorkArr.count > 0 ? @"1" : @"0"];
            //            self.workNameLabel.text = responseObject[@"retobj"][@"examobj"][@"name"];
            count = self.doWorkArr.count;
        
            for (int i = 0; i < count; i++) {
                NSMutableArray *arr = [NSMutableArray array];
                [self.answerArr addObject:arr];
            }
            for (int i = 0; i < self.doWorkArr.count; i++) {
                NSNumber *timeNum = [[NSNumber alloc ] initWithInt:0];
                [self.countTimeArr addObject:timeNum];
            }
            self.preTime = 0;
            self.preIndex = 1;
            if(count == 0){
                [SVProgressHUD showInfoWithStatus:@"暂没有添加作业..."];
            }

        }else{
        [self loadMicroData];
        }
    }
    
    [self setupScrollView];
    self.workNameLabel.text = self.desc;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
   
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    NSLog(@"++++%@", NSStringFromCGRect(self.scrollView.frame));
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    NSLog(@"---%@", NSStringFromCGRect(self.scrollView.frame));
}
- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"--+++%@", NSStringFromCGRect(self.scrollView.frame));
    if(_flag == 0){
    if([self.type integerValue] == 1){
        if(self.jumpDoworkArr != nil){
            [self scrollViewAddChildSubview:self.doWorkArr];
            _flag = 1;
        }
    }else{
        if(self.jumpDoworkArr != nil){
            [self scrollViewAddChildSubview:self.doWorkArr];
            _flag = 1;
        }
    }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [SVProgressHUD dismiss];
    
}
- (void)dealloc
{
    [self.timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 键盘的弹出和退下
// 键盘弹出
- (void)keyboardWillShow:(NSNotification *)aNotification
{
  
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.centerY = SCREEN_HEIGHT / 2 - height;
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.centerY = SCREEN_HEIGHT / 2;
    }];
}

#pragma mark - 私有方法
// 加载普通作业数据
- (void)loadData
{
    [self.view makeToastActivity:SHOW_CENTER];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_get_task_exam_preview_data";
    param[@"taskid"] = self.taskid;
    param[@"examid"] = self.examid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.view hideToastActivity];
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] integerValue] == 0) {
            
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 1;
                [self.doWorkArr addObject:model];
            }
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 2;
                [self.doWorkArr addObject:model];
            }
   
                
                NSInteger i = 0;
                for (NSArray *arr in [responseObject[@"retobj"][@"examobj"][@"questionlist"] JSONValue]) {
                    if(arr.count == 0){
                        continue;
                    }
                    if ([arr[0] isEqualToString:@"choice"]) {
                        for (NSDictionary *dict in arr[1]) {
                            YjyxDoingWorkModel *model = self.doWorkArr[i];
                            if([model.t_id isEqual:dict[@"id"]]){
                            model.requireprocess = dict[@"requireprocess"];
                            i++;
                            }
                        }
                    }
                    if ([arr[0] isEqualToString:@"blankfill"]) {
                        for (NSDictionary *dict in arr[1]) {
                            YjyxDoingWorkModel *model = self.doWorkArr[i];
                            if([model.t_id isEqual:dict[@"id"]]){
                            model.requireprocess = dict[@"requireprocess"];
                            i++;
                            }
                        }
                    }
                }
            for (int i = 0; i < self.doWorkArr.count; i++) {
                NSNumber *timeNum = [[NSNumber alloc ] initWithInt:0];
                [self.countTimeArr addObject:timeNum];
            }
            NSLog(@"%@", self.countTimeArr);
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%ld", self.doWorkArr.count];
            self.titlenumberLabel.text = [NSString stringWithFormat:@"%@", self.doWorkArr.count > 0 ? @"1" : @"0"];
//            self.workNameLabel.text = responseObject[@"retobj"][@"examobj"][@"name"];
            count = self.doWorkArr.count;
            [self scrollViewAddChildSubview:self.doWorkArr];
        
            for (int i = 0; i < count; i++) {
                NSMutableArray *arr = [NSMutableArray array];
                [self.answerArr addObject:arr];
            }
            self.preTime = 0;
            self.preIndex = 1;
            if(count == 0){
                [SVProgressHUD showInfoWithStatus:@"暂没有添加作业..."];
            }
        
        }else{
        [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}
//  加载微课数据
- (void)loadMicroData
{
    [self.view makeToastActivity:SHOW_CENTER];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_get_task_lesson_preview_data";
    param[@"taskid"] = self.taskid;
    param[@"lessonid"] = self.examid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.view hideToastActivity];
//        NSLog(@"%@", responseObject);
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
        if ([responseObject[@"retcode"] integerValue] == 0) {
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"]) {
//                [responseObject[@"retobj"][@"lessonobj"][@"quizcontent"] JSONValue][@"questionList"]
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 1;
                [self.doWorkArr addObject:model];
            }
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 2;
                [self.doWorkArr addObject:model];
            }
            
            NSInteger i = 0;
            for (NSArray *arr in [responseObject[@"retobj"][@"lessonobj"][@"quizcontent"] JSONValue][@"questionList"]) {
                if(arr.count == 0){
                    continue;
                }
                if ([arr[0] isEqualToString:@"choice"]) {
                    for (NSDictionary *dict in arr[1]) {
                        YjyxDoingWorkModel *model = self.doWorkArr[i];
                        if([model.t_id isEqual:dict[@"id"]]){
                        model.requireprocess = dict[@"requireprocess"];
                        i++;
                        }
                    }
                }
                if ([arr[0] isEqualToString:@"blankfill"]) {
                    for (NSDictionary *dict in arr[1]) {
                        
                        YjyxDoingWorkModel *model = self.doWorkArr[i];
                        if([model.t_id isEqual:dict[@"id"]]){
                        model.requireprocess = dict[@"requireprocess"];
                        i++;
                        }
                    }
                }
            }
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%ld", self.doWorkArr.count];
            self.titlenumberLabel.text = [NSString stringWithFormat:@"%@", self.doWorkArr.count > 0 ? @"1" : @"0"];
            //            self.workNameLabel.text = responseObject[@"retobj"][@"examobj"][@"name"];
            count = self.doWorkArr.count;
            [self scrollViewAddChildSubview:self.doWorkArr];
            
            for (int i = 0; i < count; i++) {
                NSMutableArray *arr = [NSMutableArray array];
                [self.answerArr addObject:arr];
            }
            for (int i = 0; i < self.doWorkArr.count; i++) {
                NSNumber *timeNum = [[NSNumber alloc ] initWithInt:0];
                [self.countTimeArr addObject:timeNum];
            }
            self.preTime = 0;
            self.preIndex = 1;
            if(count == 0){
                [SVProgressHUD showInfoWithStatus:@"暂没有添加作业..."];
            }
        }else{
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
    }];
}

//  设置scrollView属性
- (void)setupScrollView
{
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * count , self.scrollView.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;  
}
// scrollV添加子控件
- (void)scrollViewAddChildSubview:(NSArray *)arr
{
    
    // 解题步骤相关数组
    NSMutableDictionary *viewDict = [NSMutableDictionary dictionary];
    _viewDict = viewDict;
    // 保存解题步骤的url数组
    NSMutableDictionary *urlDict = [NSMutableDictionary dictionary];
    _urlDict = urlDict;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * arr.count, self.scrollView.height);
    for (int i = 0; i < arr.count; i++) {
        YjyxDoingWorkModel *model = self.doWorkArr[i];
        // 上传过程的view
        UIView *bgView = [[UIView alloc] init];
        // 标题label
        UILabel *label = [[UILabel alloc] init];
        if([model.requireprocess integerValue] == 1){ // 需要上传解题过程
        label.text = @"上传解答";
        [label sizeToFit];
        label.x = 5;
        label.y = 2;
        label.textColor = STUDENTCOLOR;
        [bgView addSubview:label];
        // 添加scrollView的背景图片
        UIView *bgCollectionView = [[UIView alloc] init];
        bgCollectionView.tag = i;
//        self.bg_view = bgCollectionView;
        CGFloat margin = 0;
        CGFloat itemWH = (SCREEN_WIDTH - 6 * margin) / 5;
        _itemWH = itemWH;
        bgCollectionView.x = 0;
        bgCollectionView.y = CGRectGetMaxY(label.frame) + 5;
        bgCollectionView.width = SCREEN_WIDTH;
        bgCollectionView.height = itemWH;
        [bgView addSubview:bgCollectionView];
        
        [self.scrollView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView).offset(i * SCREEN_WIDTH);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.equalTo(bgCollectionView.mas_bottom).offset(5);
        }];
     
        bgView.backgroundColor = [UIColor whiteColor];
        NSArray *currentArr = [self configureCollectionView:bgCollectionView];
      
        
        NSString *str = [NSString stringWithFormat:@"%d", i];
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:4];
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *assetArr = [NSMutableArray array];
        [arr1 addObject:currentArr.firstObject];
        [arr1 addObject:tempArr];
        [arr1 addObject:assetArr];
        [arr1 addObject:currentArr.lastObject];
        [viewDict setObject:arr1 forKey:str];
        
            NSMutableArray *urlArray = [NSMutableArray array];
            [urlDict setObject:urlArray forKey:str];
        }
        // 添加webview
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame =  CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height - 81);
        if([model.requireprocess integerValue] == 1){
        webView.y = CGRectGetMaxY(label.frame)+ _itemWH + 11;
        webView.height = self.scrollView.height - 81 - webView.y;
        }
        webView.delegate = self;
        [self.scrollView addSubview:webView];
        webView.tag = i + 1;
        webView.scrollView.bounces = NO;
        NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
        [webView loadHTMLString:jsString baseURL:nil];
        
        // 添加答案控件
        YjyxDoingView *answerView = [YjyxDoingView doingView];
        answerView.frame =  CGRectMake(i * SCREEN_WIDTH, self.scrollView.height - 79, SCREEN_WIDTH, 80);
        answerView.delegate = self;
        answerView.tag = i + 1;
        [self.scrollView addSubview:answerView];
        if (i == arr.count - 1) {
            [answerView.nextWorkBtn setTitle:@"提交" forState:UIControlStateNormal];
            answerView.nextWorkBtn.backgroundColor = STUDENTCOLOR;
        }
        if(model.questiontype == 1){
            answerView.scrollView.hidden = YES;
        }else{
            answerView.choiceAnswerView.hidden = YES;
            NSInteger index =  [model.blankcount integerValue];
            answerView.count = index;
            answerView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 70, 40 * index);
        }
        
    }
}
// 记时的方法
- (void)countTime
{
    _consumeTime++;

    self.consumeTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", _consumeTime / 60, _consumeTime % 60];
   
}
// 草稿纸的点击
- (IBAction)dfartBtnClick:(UIButton *)sender {
   
    [self.view addSubview:self.draftV];
    [UIView animateWithDuration:0.5 animations:^{
        self.draftV.y = 0;
    }];
   
  
}
// 返回按钮被点击
- (IBAction)backBtnClick:(id)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您并没有提交您的做题信息,一旦退出将清除您所有的做题信息!" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alertVc animated:YES completion:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSInteger flag = 0;
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if([vc isKindOfClass:[YjyxOneSubjectViewController class]]){
                [self.navigationController popToViewController:vc animated:YES];
                flag = 1;
                break;
            }
        }
        if(flag == 0){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    
    

}
//  答题卡按钮被点击
- (IBAction)answerResultBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
   
    if (sender.selected) {

        [self countStuAnswer];
        YjyxWorkResultView *workResultV = [[YjyxWorkResultView alloc] init];
        workResultV.delegate = self;
        workResultV.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
       
        [workResultV setWorkType:self.doWorkArr andArr:self.answerArr];
        [self.view addSubview:workResultV];
    }else{
      
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[YjyxWorkResultView class]]) {
                [view removeFromSuperview];
                break;
            }
        }
        
    }
     NSLog(@"%ld", _stuDoWorkNum);
}
// 统计学生做题答案
- (void)countStuAnswer{
    _stuDoWorkNum = 0;
    for (UIView *view in self.scrollView.subviews) {
        if([view isKindOfClass:[YjyxDoingView class]]){
            
            NSInteger index = view.tag - 1;
            NSMutableArray *arr = self.answerArr[index];
            [arr removeAllObjects];
            YjyxDoingWorkModel *model = self.doWorkArr[view.tag - 1];
            if (model.questiontype == 2) {
                for (UIView *subview in view.subviews) {
                    if ([subview isKindOfClass:[UIScrollView class]]) {
                        for (UIView *finalSubview in subview.subviews){
                            [arr addObject: ((UITextField *)finalSubview).text];
                        }
                    }
                }
            }else{
                for (UIView *subview in view.subviews) {
                    if ([subview isKindOfClass:[UIView class]]) {
                        for (UIView *finalSubview in subview.subviews) {
                            
                            if ([finalSubview isKindOfClass:[UIButton class]]) {
                                
                                if(((UIButton *)finalSubview).selected == YES){
                                    [arr addObject:@(finalSubview.tag - 1)];
                                }
                            }
                        }
                    }
                }
            }
            if (arr.count > 0) {
                _stuDoWorkNum++;
            }
        }
    }

}
// 弹出温馨提示
- (void)presentPromptMessage{
    NSString *str = [NSString stringWithFormat:@"您还有%ld题没有完成,确定提交?", self.answerArr.count - _stuDoWorkNum];
    if (_stuDoWorkNum == self.answerArr.count) {
        str = @"您已完成所有作业,确认提交?";
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertVc animated:YES completion:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self scrollViewDidEndDecelerating:self.scrollView];
        [self submitHomeWork];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVc addAction:action1];
    [alertVc addAction:action2];
}
// 提交作业
- (void)submitHomeWork
{
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    coverView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:coverView];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    param[@"taskid"] = self.taskid;
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    NSMutableArray *choiceArr = [NSMutableArray array];
    NSMutableArray *blankArr = [NSMutableArray array];
    [resultDict setObject:choiceArr forKey:@"choice"];
    [resultDict setObject:blankArr forKey:@"blankfill"];
    [resultDict setObject:@(self.consumeTime) forKey:@"spendTime"];
    NSInteger corretIndex = 0;
    NSInteger wrongIndex = 0;
    for (int i = 0; i < self.doWorkArr.count; i++) {
        YjyxDoingWorkModel *model = self.doWorkArr[i];
        if (model.questiontype == 1) { // 选择题
            NSMutableArray *oneChoiceArr = [NSMutableArray array];
            [oneChoiceArr addObject:model.t_id];
            [oneChoiceArr addObject:self.answerArr[i]];
            // 正确答案数组
            NSMutableArray *tureAnswerArr = [NSMutableArray array];
            if([model.answer containsString:@"|"]){
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSString *str in [model.answer componentsSeparatedByString:@"|"]) {
                    [tempArr addObject:[NSNumber numberWithInteger:[str integerValue]]];
                }
                tureAnswerArr = tempArr;
            }else{
                
                [tureAnswerArr addObject:[NSNumber numberWithInteger:[model.answer integerValue]]];
            }
            NSLog(@"%@------%@", self.answerArr[i] , model.answer);
            //  自己答案与正确答案比较
            if ([tureAnswerArr isEqualToArray:self.answerArr[i]]) {
                bool bool_true = true;
                
                corretIndex++;
                [oneChoiceArr addObject:@(bool_true)];
            }else{
                bool bool_false = false;
                wrongIndex++;
                [oneChoiceArr addObject:@(bool_false)];
            }
            
            [oneChoiceArr addObject:self.countTimeArr[i]];
            [choiceArr addObject:oneChoiceArr];
            NSMutableDictionary *processDict = [NSMutableDictionary dictionary];
            [oneChoiceArr addObject:processDict];
            if ([model.requireprocess integerValue] == 1) {
                NSString *numStr = [NSString stringWithFormat:@"%d", i];
                NSMutableArray *processArr = [NSMutableArray array];
                for (NSString *str in self.urlDict[numStr]) {
                    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                    [tempDict setObject:str forKey:@"img"];
                    [tempDict setObject:[NSMutableArray array] forKey:@"teachervoice"];
                    [processArr addObject:tempDict];
                }
                [processDict setObject:processArr forKey:@"writeprocess"];
            }else{
                [processDict setObject:[NSMutableArray array] forKey:@"writeprocess"];
                
            }
            
            
        }else{ // 填空题
            NSMutableArray *oneBlankArr = [NSMutableArray array];
            [oneBlankArr addObject:model.t_id];
            [oneBlankArr addObject:self.answerArr[i]];
            
            //  自己答案与正确答案比较
            if ([[model.answer JSONValue] isEqualToArray:self.answerArr[i]]) {
                corretIndex++;
                [oneBlankArr addObject:@1];
            }else{
                wrongIndex++;
                [oneBlankArr addObject:@0];
            }
            
            [oneBlankArr addObject:self.countTimeArr[i]];
            [choiceArr addObject:oneBlankArr];
            NSMutableDictionary *processDict = [NSMutableDictionary dictionary];
            [oneBlankArr addObject:processDict];
            if ([model.requireprocess integerValue] == 1) {
                NSString *numStr = [NSString stringWithFormat:@"%d", i];
                NSMutableArray *processArr = [NSMutableArray array];
                for (NSString *str in self.urlDict[numStr]) {
                    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                    [tempDict setObject:str forKey:@"img"];
                    [tempDict setObject:[NSMutableArray array] forKey:@"teachervoice"];
                    [processArr addObject:tempDict];
                }
                [processDict setObject:processArr forKey:@"writeprocess"];
            }else{
                [processDict setObject:[NSMutableArray array] forKey:@"writeprocess"];
                
            }
            
            
        }
        
    }
    
    NSString *examresult = [resultDict JSONString];
    //    param[@"examresult"] = examresult;
    
    param[@"submit"] = @"true";
    NSMutableDictionary *summary = [NSMutableDictionary dictionary];
    [summary setObject:@(corretIndex) forKey:@"correct"];
    [summary setObject:@(wrongIndex) forKey:@"wrong"];
    
    param[@"summary"] = [summary JSONString];
    [SVProgressHUD showWithStatus:@"正在提交,请稍等..."];
    if([self.type isEqual:@1]){ // 普通作业
        param[@"examresult"] = examresult;
        param[@"examid"] = self.examid;
        param[@"action"] = @"task_exam_save_result";
        [mgr POST:[BaseURL stringByAppendingString:STUDENT_UPLOAD_WORK_POST] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"retcode"] integerValue] == 0) {
                [self.view makeToast:@"提交完成" duration:0.5 position:SHOW_CENTER complete:^{
                    YjyxWorkDetailController *vc = [[YjyxWorkDetailController alloc] init];
                    vc.t_id = responseObject[@"tasktrackid"];
                    vc.title = self.desc;
                    vc.taskType = self.type;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                
            }else{
                NSLog(@"%@", responseObject[@"reason"]);
                [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
                 [coverView removeFromSuperview];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
        }];
    }else{ // 微课作业
        param[@"action"] = @"task_lesson_save_result";
        param[@"lessonresult"] = examresult;
        param[@"lessonid"] = self.examid;
        
        [mgr POST:[BaseURL stringByAppendingString:STUDENT_UPLOAD_WORK_POST] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           
            NSLog(@"%@", responseObject);
            if ([responseObject[@"retcode"] integerValue] == 0) {
                [self.view makeToast:@"提交完成" duration:0.5 position:SHOW_CENTER complete:^{
                    YjyxWorkDetailController *vc = [[YjyxWorkDetailController alloc] init];
                    vc.t_id = responseObject[@"tasktrackid"];
                    vc.title = self.desc;
                    vc.taskType = self.type;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
               
            }else{
                NSLog(@"%@", responseObject[@"reason"]);
                [self.view makeToast:responseObject[@"msg"] duration:0.5 position:SHOW_CENTER complete:nil];
                 [coverView removeFromSuperview];
                [SVProgressHUD dismiss];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
            [coverView removeFromSuperview];
            [SVProgressHUD dismiss];
        }];
        
    }
    
}

#pragma mark - UICollectionView
- (NSArray *)configureCollectionView:(UIView *)bg_view {
    
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 0;
  
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 0, SCREEN_WIDTH, _itemWH) collectionViewLayout:layout];
    collectionView.tag = 200 + bg_view.tag;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [bg_view addSubview:collectionView];
    [collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    return @[collectionView, layout];
    
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSLog(@"%@", NSStringFromCGRect(_collectionView.frame));
//    NSLog(@"%ld", _selectedPhotos.count);
    NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    NSString *str = [NSString stringWithFormat:@"%ld", index];
    _collectionView = self.viewDict[str][0];
    _selectedPhotos = self.viewDict[str][1];
    _selectedAssets = self.viewDict[str][2];
    return _selectedPhotos.count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    NSString *str = [NSString stringWithFormat:@"%ld", index];
 
    _collectionView = self.viewDict[str][0];
    _selectedPhotos = self.viewDict[str][1];
    _selectedAssets = self.viewDict[str][2];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    NSString *str = [NSString stringWithFormat:@"%ld", index];
    _collectionView = self.viewDict[str][0];
    _selectedPhotos = self.viewDict[str][1];
    _selectedAssets = self.viewDict[str][2];
    _layout = self.viewDict[str][3];
    
    _urlArr = self.urlDict[str];
    if (indexPath.row == _selectedPhotos.count) {
        [self pickPhotoButtonClick:nil];
    } else { // preview photos / 预览照片
     
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
       
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray<PHAsset *> *assets, BOOL isSelectOriginalPhoto) {
//            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//            _selectedAssets = [NSMutableArray arrayWithArray:assets];
     
            
            NSMutableArray *tempArr = [NSMutableArray array];
            [tempArr addObjectsFromArray:assets];

            [_selectedAssets removeAllObjects];
            [_selectedPhotos removeAllObjects];
            [_selectedPhotos addObjectsFromArray:photos];
            [_selectedAssets addObjectsFromArray:tempArr];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [UploadImageTool uploadImages:_selectedPhotos progress:nil success:^(NSArray *urlArr) {
                [_urlArr removeAllObjects];
                [_urlArr addObjectsFromArray:urlArr];
            } failure:^{
                [self.view makeToast:@"添加解题步骤图片失败" duration:0.5 position:SHOW_CENTER complete:nil];
            }];
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            
//            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
  
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    NSString *str = [NSString stringWithFormat:@"%ld", index];
    _collectionView = self.viewDict[str][0];
    _selectedPhotos = self.viewDict[str][1];
    _selectedAssets = self.viewDict[str][2];
    _layout = self.viewDict[str][3];
    _urlArr = self.urlDict[str];
    if(sender.tag >= _urlArr.count){
        [SVProgressHUD showWithStatus:@"正在上传,请稍等..."];
        return;
    }
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    if (!(_selectedAssets.count == 0)) {
         [_selectedAssets removeObjectAtIndex:sender.tag];
    }
    [_urlArr removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    
    // 设置支持最多照片数目
    int maxCount = 5;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    
    // 不可以选择原图,太费流量
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//    NSLog(@"%@", photos);
    [_selectedAssets removeAllObjects];
    [_selectedPhotos removeAllObjects];
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    
    [UploadImageTool uploadImages:_selectedPhotos progress:nil success:^(NSArray *urlArr) {
        [_urlArr removeAllObjects];
        [_urlArr addObjectsFromArray:urlArr];
    } failure:^{
        [self.view makeToast:@"添加解题步骤图片失败" duration:0.5 position:SHOW_CENTER complete:nil];
    }];
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
//    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

/// User finish picking video,
/// 用户选择好了视频
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
//    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
//    _layout.itemCount = _selectedPhotos.count;
//    // open this code to send video / 打开这段代码发送视频
//    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
//    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//    // Export completed, send video here, send by outputPath or NSData
//    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
//    
//    // }];
//    [_collectionView reloadData];
//    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if (img.width > %f) {\
    img.style.maxWidth = %f; \
    }\
    } \
    }";
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 10, SCREEN_WIDTH - 10];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
//    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == YES) {
        NSLog(@"-----");
    }else{
    NSLog(@"没有减速");
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%@", self.viewDict);
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.titlenumberLabel.text = [NSString stringWithFormat:@"%ld", index + 1];

    NSNumber *num = self.countTimeArr[_preIndex - 1];
    NSInteger conTime = self.consumeTime - self.preTime;
    NSInteger numInt = [num integerValue];
    numInt  += conTime;
    NSLog(@"%ld", numInt);
    num = [[NSNumber alloc ] initWithInt:numInt];
    self.countTimeArr[_preIndex - 1] = num;
    self.preTime = self.consumeTime;
    self.preIndex = index + 1;

}
#pragma mark - DoingViewDelegate
- (void)doingView:(YjyxDoingView *)view nextWorkBtnIsClick:(UIButton *)btn
{
    if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"下一题"]) {
        
        [self.scrollView setContentOffset:CGPointMake(view.tag  * SCREEN_WIDTH, 0) animated:YES];
       self.titlenumberLabel.text = [NSString stringWithFormat:@"%ld", view.tag + 1];
        NSNumber *num = self.countTimeArr[_preIndex - 1];
        NSInteger conTime = self.consumeTime - self.preTime;
        NSInteger numInt = [num integerValue];
        numInt  += conTime;
        NSLog(@"%ld", numInt);
        num = [[NSNumber alloc ] initWithInt:numInt];
        self.countTimeArr[_preIndex - 1] = num;
        self.preTime = self.consumeTime;
        self.preIndex = view.tag + 1;
    }else{
        [self countStuAnswer];
        [self presentPromptMessage];
        
    }
}
#pragma mark - WorkResultDelegate
// 题号按钮点击
- (void)workResultView:(YjyxWorkResultView *)view workNumBtnClick:(UIButton *)btn
{
    [self answerResultBtnClick:self.answerWorkCardBtn];
    [self.scrollView setContentOffset:CGPointMake((btn.tag - 1) * SCREEN_WIDTH, 0) animated:YES];
    self.titlenumberLabel.text = [NSString stringWithFormat:@"%ld", btn.tag];

    
    
}
// 提交按钮被点击
- (void)workResultView:(YjyxWorkResultView *)view sumbitBtnClick:(UIButton *)btn
{
    NSLog(@"%@", self.countTimeArr);
    [self presentPromptMessage];
}
@end
