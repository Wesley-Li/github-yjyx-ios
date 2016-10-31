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


#import "YjyxDoWorkCollectionCell.h"
#import <WebKit/WebKit.h>
@interface YjyxDoingWorkController ()<UIWebViewDelegate, UIScrollViewDelegate, DoingViewDelegate, WorkResultDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TZImagePickerControllerDelegate, UIWebViewDelegate, DoWorkCollectionCellDelegate>

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait; //
@property (weak, nonatomic) IBOutlet UIButton *answerWorkCardBtn; // 答题卡按钮

@property (strong, nonatomic) NSMutableArray *doWorkArr;  // 模型数组
@property (strong, nonatomic) NSMutableArray *answerArr;  // 答案数组
@property (assign, nonatomic) NSInteger stuDoWorkNum;

@property (weak, nonatomic) IBOutlet UILabel *titlenumberLabel;  // 当前题号
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;  // 总题数
@property (weak, nonatomic) IBOutlet UILabel *workNameLabel; // 作业描述
@property (weak, nonatomic) IBOutlet UILabel *consumeTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (assign, nonatomic) NSInteger consumeTime; // 消耗的时间
//@property (strong, nonatomic) NSTimer *timer;

//@property (weak, nonatomic) UIView *bg_view; // 解题步骤的背景
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableDictionary *viewDict; // 保存图片数组的字典
@property (strong, nonatomic) NSMutableDictionary *urlDict; // 保存图片url的字典

@property (assign, nonatomic) NSInteger flag;
@property (weak, nonatomic) YjyxDraftView *draftV;
@property (assign, nonatomic) NSInteger prekeyIndex; // 记录键盘前一次在的界面索引
@property (assign, nonatomic) CGSize preSize; // 记录webview的contentsize

@property (strong, nonatomic) NSMutableArray *countTimeArr; // 每道题计时数组
@property (assign, nonatomic) NSInteger preTime;
@property (assign, nonatomic) NSInteger preIndex;

@property (strong, nonatomic) NSDate *oldDate;

@property (weak, nonatomic) UIScrollView *answerScrollV;

@property (weak, nonatomic) IBOutlet UICollectionView *bgCollectionView;



@end

@implementation YjyxDoingWorkController
dispatch_source_t timer;
static NSString *ID = @"BGCEll";
#pragma mark - 懒加载
- (YjyxDraftView *)draftV
{
    if (_draftV == nil) {
        YjyxDraftView *draftV = [YjyxDraftView draftView];
        draftV.x = 0;
        draftV.y = -SCREEN_HEIGHT;
        draftV.width = SCREEN_WIDTH;
        draftV.height = SCREEN_HEIGHT;
        self.draftV = draftV;
    }
    return _draftV;
}
- (NSMutableArray *)jumpDoworkArr
{
    if (_jumpDoworkArr == nil) {
        _jumpDoworkArr = [NSMutableArray array];
    }
    return _jumpDoworkArr;
}
#pragma mark - view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    if(![self.workTitle isEqualToString:@""] || ![self.workTitle isEqual:[NSNull null]] || self.workTitle != nil){
        self.workNameLabel.text = self.workTitle;
    }
    if (self.jumpDoworkArr.count == 0) {
        [self loadData];
        self.titlenumberLabel.text = @"0";
    }else{
        self.totalTitleLabel.text = [NSString stringWithFormat:@"%ld", self.jumpDoworkArr.count];
        self.titlenumberLabel.text = @"1";
        
        [self createTimer];
    }
    [self.bgCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxDoWorkCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroud) name:UIApplicationWillResignActiveNotification object:nil];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewwillAppear");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewdidappear");
    [self createTimer];
}
- (void)viewDidDisappear:(BOOL)animated
{
   [self releaseTimer];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)dealloc
{
    NSLog(@"delloc");
    
}
#pragma mark - 私有方法
- (void)loadData
{
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    coverView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:coverView];
    [coverView makeToastActivity:SHOW_CENTER];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_get_task_exam_preview_data";
    param[@"taskid"] = self.taskid;
    param[@"examid"] = self.examid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.view hideToastActivity];
        NSLog(@"%@", responseObject);
        [coverView removeFromSuperview];
        if ([responseObject[@"retcode"] isEqual:@0]) {
            self.subject_id = responseObject[@"retobj"][@"examobj"][@"subjectid"];
            NSArray  *choices = responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"];
            NSArray  *blankfills = responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"];
            if(choices.count + blankfills.count == 0){
                [self.view makeToast:@"题目已经被老师删除了" duration:3.0 position:SHOW_CENTER complete:nil];
                return ;
            }
            
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 1;
                [self.jumpDoworkArr addObject:model];
            }
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 2;
                [self.jumpDoworkArr addObject:model];
            }
            
            
            NSInteger i = 0;
            for (NSArray *arr in [responseObject[@"retobj"][@"examobj"][@"questionlist"] JSONValue]) {
                if(arr.count == 0){
                    continue;
                }
                if ([arr[0] isEqualToString:@"choice"]) {
                    for (NSDictionary *dict in arr[1]) {
                        if(i >= self.jumpDoworkArr.count){
                            continue;
                        }
                        YjyxDoingWorkModel *model = self.jumpDoworkArr[i];
                        if([dict[@"id"] isEqual:model.t_id]){
                            model.requireprocess = dict[@"requireprocess"];
                            i++;
                        }
                        
                        
                    }
                }
                if ([arr[0] isEqualToString:@"blankfill"]) {
                    for (NSDictionary *dict in arr[1]) {
                        if(i >= self.jumpDoworkArr.count){
                            continue;
                        }
                        YjyxDoingWorkModel *model = self.jumpDoworkArr[i];
                        if([dict[@"id"] isEqual:model.t_id]){
                            model.requireprocess = dict[@"requireprocess"];
                            i++;
                        }
                    }
                }
            }
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%ld", self.jumpDoworkArr.count];
            self.titlenumberLabel.text = @"1";
            [self createTimer];
            [self.bgCollectionView reloadData];
        }else{
            [self.view makeToast:@"获取作业失败" duration:1.0 position:SHOW_CENTER complete:nil];
           
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        [coverView removeFromSuperview];
        [self.view makeToast:@"获取作业失败" duration:1.0 position:SHOW_CENTER complete:nil];
        
    }];
}



- (void)appDidBecomeActive
{
    if(self.jumpDoworkArr.count != 0){
        NSTimeInterval  timeCount = [[NSDate date] timeIntervalSinceDate:self.oldDate];
        NSLog(@"%ld", _consumeTime);
        _consumeTime += timeCount;
        self.consumeTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", _consumeTime / 60, _consumeTime % 60];
        [self createTimer];
        NSLog(@"++++++++++%f", timeCount);
    }
}
- (void)appDidEnterBackgroud
{
    self.oldDate = [NSDate date];
    [self releaseTimer];
}
// 创建定时器
- (void)createTimer
{

        // 开启定时器
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        _timer = timer;
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0));
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            NSLog(@"Fired");
           
            [self countTime];
        });

       dispatch_resume(timer);
//


}
// 销毁定时器
- (void)releaseTimer
{
    if(timer == nil){
        return;
    }
    dispatch_cancel(timer);
    timer = nil;
//    [_timer invalidate];
//    _timer = nil;
    

}
// 记时的方法
- (void)countTime
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _consumeTime++;
        self.consumeTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", _consumeTime / 60, _consumeTime % 60];
        [self.bgView layoutIfNeeded];
    });
    
    
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
//   初始化bgcollectionview
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 124);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bgCollectionView.collectionViewLayout = layout;
    self.bgCollectionView.pagingEnabled = YES;
    self.bgCollectionView.bounces = NO;
    self.bgCollectionView.showsHorizontalScrollIndicator = NO;
    self.bgCollectionView.showsVerticalScrollIndicator = NO;
}
// 草稿纸的点击
- (IBAction)dfartBtnClick:(UIButton *)sender {
    
    [self.view addSubview:self.draftV];
    [UIView animateWithDuration:0.5 animations:^{
        self.draftV.y = 0;
    }];
}
//  答题卡按钮被点击
- (IBAction)answerResultBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected) {

        CGFloat margin = (SCREEN_WIDTH - 45 * 6) / 7;
        UIScrollView *scrollV = [[UIScrollView alloc] init];
        scrollV.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        scrollV.bounces = NO;
        self.answerScrollV = scrollV;
        scrollV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        scrollV.contentSize = CGSizeMake(SCREEN_WIDTH,  margin + ((self.jumpDoworkArr.count - 1) / 6) * (margin + 45) + 250);

        [self.view addSubview:scrollV];
        YjyxWorkResultView *workResultV = [[YjyxWorkResultView alloc] init];
        NSLog(@"%@", NSStringFromCGRect(workResultV.frame));
        workResultV.delegate = self;
        workResultV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 3*SCREEN_HEIGHT);
        NSLog(@"%@", NSStringFromCGRect(workResultV.frame));

        
        [workResultV setWorkType:self.jumpDoworkArr andArr:self.answerArr];
        
        [scrollV addSubview:workResultV];
        

    }else{
        for (UIView *view in self.view.subviews) {
            if ([view isEqual:self.answerScrollV]) {
                [view removeFromSuperview];
                break;
            }
        }
        
    }
    NSLog(@"%ld", _stuDoWorkNum);
}
- (NSInteger)countDoAnswer
{
    NSInteger countAnswer = 0;
    for (int i = 0; i < self.jumpDoworkArr.count; i++) {
        YjyxDoingWorkModel *model = self.jumpDoworkArr[i];
       
        if(model.questiontype == 1){ // 选择题
            if ( model.answerArr.count != 0) {
                countAnswer++;
            }
        }else{ // 填空题
            NSString *str = [model.blankfillArr componentsJoinedByString:@""];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(![str isEqualToString:@""]){
                countAnswer++;
            }
        }
    }
        return countAnswer;
}
#pragma mark - uicollectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld", self.jumpDoworkArr.count);
    return self.jumpDoworkArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxDoWorkCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    if(indexPath.row == self.jumpDoworkArr.count - 1){
        cell.tag = 1000;
    }else{
        cell.tag = 200 + indexPath.row;
    }
    cell.model = self.jumpDoworkArr[indexPath.row];
    
    return cell;
}
#pragma mark - scrollViewdelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.titlenumberLabel.text = [NSString stringWithFormat:@"%ld", index + 1];
    self.preTime = self.consumeTime;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    NSInteger index = (scrollView.contentOffset.x  + SCREEN_WIDTH / 2)/ SCREEN_WIDTH;
    NSLog(@"%ld", index);
    YjyxDoingWorkModel *model = self.jumpDoworkArr[index];
    model.drainTime += self.consumeTime - self.preTime;
    
}

#pragma mark - 下一题的点击
- (void)doWorkCollectionCell:(YjyxDoWorkCollectionCell *)cell nextWorkBtnIsClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    if(cell.tag == 1000){
        cell.tag = self.jumpDoworkArr.count + 200 - 1;
    }
    YjyxDoingWorkModel *model = self.jumpDoworkArr[cell.tag - 200];
    model.drainTime += self.consumeTime - self.preTime;
    self.preTime = self.consumeTime;
    if([btn.titleLabel.text isEqualToString:@"提交"]){
        [self presentPromptMessage];
    }else{
        [self.bgCollectionView setContentOffset:CGPointMake((cell.tag - 200 + 1)  * SCREEN_WIDTH, 0) animated:YES];
        self.titlenumberLabel.text = [NSString stringWithFormat:@"%ld", cell.tag - 199 + 1];
    }
}
#pragma mark - WorkResultDelegate
// 题号按钮点击
- (void)workResultView:(YjyxWorkResultView *)view workNumBtnClick:(UIButton *)btn
{
    NSInteger index = self.bgCollectionView.contentOffset.x  / SCREEN_WIDTH;
    NSLog(@"%ld", index);
    YjyxDoingWorkModel *model = self.jumpDoworkArr[index];
    model.drainTime += self.consumeTime - self.preTime;
    self.preTime = self.consumeTime;
    
    [self answerResultBtnClick:self.answerWorkCardBtn];
    [self.bgCollectionView setContentOffset:CGPointMake((btn.tag - 1) * SCREEN_WIDTH, 0) animated:YES];
    self.titlenumberLabel.text = [NSString stringWithFormat:@"%ld", btn.tag];
}
// 提交按钮被点击
- (void)workResultView:(YjyxWorkResultView *)view sumbitBtnClick:(UIButton *)btn
{
    NSLog(@"%@", self.countTimeArr);
    [self presentPromptMessage];
}
// 点击答题卡空白处
- (void)workResultView:(YjyxWorkResultView *)view
{
    NSLog(@"%@", view.superview);
    [view.superview  removeFromSuperview];
    self.answerWorkCardBtn.selected = NO;
}
#pragma mark -提交作业
// 弹出温馨提示
- (void)presentPromptMessage{
    NSInteger index = [self countDoAnswer];
    NSString *str = [NSString stringWithFormat:@"您还有%ld题没有完成,确定提交?", self.jumpDoworkArr.count - index];
    if (self.jumpDoworkArr.count - index == 0) {
        str = @"您已完成所有作业,确认提交?";
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertVc animated:YES completion:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self scrollViewWillBeginDragging:self.bgCollectionView];
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
    for (int i = 0; i < self.jumpDoworkArr.count; i++) {
        YjyxDoingWorkModel *model = self.jumpDoworkArr[i];
        if (model.questiontype == 1) { // 选择题
            NSMutableArray *oneChoiceArr = [NSMutableArray array];
            [oneChoiceArr addObject:model.t_id];
            [oneChoiceArr addObject:model.answerArr];
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
            if ([tureAnswerArr isEqualToArray:model.answerArr]) {
                bool bool_true = true;
                
                corretIndex++;
                [oneChoiceArr addObject:@(bool_true)];
            }else{
                bool bool_false = false;
                wrongIndex++;
                [oneChoiceArr addObject:@(bool_false)];
            }
            
            [oneChoiceArr addObject:@(model.drainTime)];
            [choiceArr addObject:oneChoiceArr];
            NSMutableDictionary *processDict = [NSMutableDictionary dictionary];
            [oneChoiceArr addObject:processDict];
            if ([model.requireprocess integerValue] == 1) {
                NSMutableArray *processArr = [NSMutableArray array];
                for (NSString *str in model.processImgUrlArr) {
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
            [oneBlankArr addObject:model.blankfillArr];
            
            //  自己答案与正确答案比较
            if ([[model.answer JSONValue] isEqualToArray:model.blankfillArr]) {
                bool bool_true = true;
                corretIndex++;
                [oneBlankArr addObject:@(bool_true)];
            }else{
                bool bool_false = false;
                wrongIndex++;
                [oneBlankArr addObject:@(bool_false)];
            }
            
            [oneBlankArr addObject:@(model.drainTime)];
            [blankArr addObject:oneBlankArr];
            NSMutableDictionary *processDict = [NSMutableDictionary dictionary];
            [oneBlankArr addObject:processDict];
            if ([model.requireprocess integerValue] == 1) {
                NSMutableArray *processArr = [NSMutableArray array];
                for (NSString *str in model.processImgUrlArr) {
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
    NSLog(@"%@", param);
    [SVProgressHUD showWithStatus:@"正在提交,请稍等..."];
    if([self.type isEqual:@1]){ // 普通作业
        param[@"examresult"] = examresult;
        param[@"examid"] = self.examid;
        param[@"action"] = @"task_exam_save_result";
        NSLog(@"%@", param);
        NSLog(@"%@", self.subject_id);
        [mgr POST:[BaseURL stringByAppendingString:STUDENT_UPLOAD_WORK_POST] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"retcode"] integerValue] == 0) {
                [self.view makeToast:@"提交完成" duration:0.5 position:SHOW_CENTER complete:^{
                    NSLog(@"%@", responseObject);
                    YjyxWorkDetailController *vc = [[YjyxWorkDetailController alloc] init];
                    vc.isFinished = 1;
                    vc.t_id = responseObject[@"tasktrackid"];
                    vc.title = self.workTitle;
                    vc.taskType = self.type;
                    vc.subject_id = self.subject_id;
                    NSLog(@"%@,%@,%@", self.desc, self.type, responseObject[@"tasktrackid"]);
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                
            }else{
                NSLog(@"%@", responseObject[@"reason"]);
                NSString *showStr = responseObject[@"msg"] == nil ? responseObject[@"reason"] : responseObject[@"msg"];
                if([showStr containsString:@"撤销"]){
                    showStr = @"提交失败,该作业不存在,或许老师已经撤销该任务!!";
                }
                [self.view makeToast:showStr duration:0.5 position:SHOW_CENTER complete:nil];
                [coverView removeFromSuperview];
                
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:@"提交作业失败" duration:0.5 position:SHOW_CENTER complete:nil];
            [coverView removeFromSuperview];
            [SVProgressHUD dismiss];
        }];
    }else{ // 微课作业
        param[@"action"] = @"task_lesson_save_result";
        param[@"lessonresult"] = examresult;
        param[@"lessonid"] = self.examid;
        
        [mgr POST:[BaseURL stringByAppendingString:STUDENT_UPLOAD_WORK_POST] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSLog(@"%@", responseObject);
            if ([responseObject[@"retcode"] integerValue] == 0) {
                [self.view makeToast:@"提交完成" duration:0.5 position:SHOW_CENTER complete:^{
                    NSLog(@"%@", responseObject);
                    YjyxWorkDetailController *vc = [[YjyxWorkDetailController alloc] init];
                    vc.isFinished = 1;
                    vc.t_id = responseObject[@"tasktrackid"];
                    vc.title = self.workTitle;
                    vc.taskType = self.type;
                    vc.subject_id = self.subject_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                
            }else{
                NSLog(@"%@", responseObject[@"reason"]);
                NSString *showStr = responseObject[@"msg"] == nil ? responseObject[@"reason"] : responseObject[@"msg"];
                if([showStr containsString:@"撤销"]){
                    showStr = @"提交失败,该作业不存在,或许老师已经撤销该任务!!";
                }
                [self.view makeToast:showStr duration:0.5 position:SHOW_CENTER complete:nil];
                [coverView removeFromSuperview];
                
                
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:@"提交作业失败" duration:0.5 position:SHOW_CENTER complete:nil];
            [coverView removeFromSuperview];
            [SVProgressHUD dismiss];
        }];
        
    }
    
}

@end
