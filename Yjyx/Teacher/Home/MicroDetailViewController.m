//
//  MicroDetailViewController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroDetailViewController.h"
#import "MicroDetailModel.h"
#import "MicroSubjectModel.h"
#import "SubjectDetailCell.h"
#import "SubjectTitleCell.h"
#import "MicroNameCell.h"
#import "ReleaseMicroCell.h"
#import "MicroKnowledgeCell.h"
#import "WMPlayer.h"
#import "ReleaseMicroController.h"
#import "OneSubjectController.h"
#import "PublishHomeworkViewController.h"
#import "QuestionDataBase.h"
#import "VideoNumShowCell.h"
@interface MicroDetailViewController ()<SubjectTitleCellDelegate, SubjectDetailCellDelegate, VideoNumShowCellDelegate>
{
    WMPlayer *wmPlayer;
    NSIndexPath *currentIndexPath;
    BOOL isSmallScreen;
    BOOL isStart;
    NSInteger lastSelectedVideoTag;
    NSTimeInterval lastPlayingTaskInterval;
    
}
@property (strong, nonatomic) MicroDetailModel *microDetailM;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDic;
@property (strong, nonatomic) NSMutableDictionary *knowCellHeightDic;
// 所有的题目数组
@property (strong, nonatomic) NSMutableArray *allSubjectArr;
// 保存所有题目的数组,以防用户将题目删除时,恢复
@property (strong, nonatomic) NSMutableArray *saveSubjectArr;
// 多少组
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) ReleaseMicroCell *videoCell;

// 选择题个数
@property (assign, nonatomic) NSInteger choicecount;
// 填空题个数
@property (assign, nonatomic) NSInteger blankcount;

@property (assign, nonatomic) NSInteger flag; // 是否处于编辑状态

@property (strong, nonatomic) NSString *videoURL;
@end

@implementation MicroDetailViewController

static NSString *videoID = @"videoCELL";
static NSString *subjectID = @"subjectCELL";
static NSString *NameID = @"NameCELL";
static NSString *KnowledgeID = @"KnowledgeCELL";
static NSString *TitleID = @"TitleCELL";
static NSString *VideoNumID = @"VideoNum";
#pragma mark - 懒加载
- (NSMutableArray *)allSubjectArr
{
    if (_allSubjectArr == nil) {
        _allSubjectArr = [NSMutableArray array];
    }
    return _allSubjectArr;
}

//- (NSMutableArray *)addMicroArr
//{
//    if (_addMicroArr == nil) {
//        _addMicroArr = [NSMutableArray array];
//    }
//    return _addMicroArr;
//}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMONCOLOR;
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    self.saveSubjectArr = [NSMutableArray array];
    [self loadData];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseMicroCell class]) bundle:nil] forCellReuseIdentifier:videoID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubjectDetailCell class]) bundle:nil] forCellReuseIdentifier:subjectID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubjectTitleCell class]) bundle:nil] forCellReuseIdentifier:TitleID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MicroNameCell class]) bundle:nil] forCellReuseIdentifier:NameID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MicroKnowledgeCell class]) bundle:nil] forCellReuseIdentifier:KnowledgeID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoNumShowCell class]) bundle:nil] forCellReuseIdentifier:VideoNumID];
    // tableview的属性
    self.tableView.contentInset = UIEdgeInsetsMake(-5, 0, -49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COMMONCOLOR;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.cellHeightDic = [NSMutableDictionary dictionary];
    self.knowCellHeightDic = [NSMutableDictionary dictionary];
    // 返回按钮被点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnClicked) name:@"BackButtonClicked" object:nil];
    // 修改标题按钮呗点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyTitleBtnClick:) name:@"ModifyTitleBtnClick" object:nil];
    // 添加按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBtnClick) name:@"AddBtnClick" object:nil];
    // web高度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webviewHeight:) name:@"webviewHeight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(knowLegeWebViewHeight:) name:@"KnowlegewebviewHeight" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //注册全屏播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];

    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeTheVideo:)
                                                 name:WMPlayerClosedNotification
                                               object:nil
     ];

    [self.tableView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated
{
    
//    [wmPlayer removeFromSuperview];
//    [self releaseWMPlayer];
//    wmPlayer.isPlay = NO;
    
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    if (isSmallScreen || wmPlayer.isFullscreen) {
        [self closeTheVideo:nil];
    }else {
        [wmPlayer pause];
    }
    
    
    [SVProgressHUD dismiss];
    // 此处只移除有关视频的通知,避免造成未知问题
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WMPlayerClosedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WMPlayerFullScreenButtonClickedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)dealloc
{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 私有方法
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"m_preview";
    pamar[@"id"] = self.m_id;
    NSLog(@"%@", pamar);
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/yj_lessons/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);

        _microDetailM = [MicroDetailModel microDetailModelWithDict:responseObject[@"lessonobj"]];
       
        for (NSDictionary *tempDict in responseObject[@"questions"][@"choice"][@"questionlist"]) {
            [self.allSubjectArr addObject:[MicroSubjectModel microSubjectModel:tempDict andType:1]];
            self.choicecount++;
        }
        for (NSDictionary *tempDict in responseObject[@"questions"][@"blankfill"][@"questionlist"]) {
            [self.allSubjectArr addObject:[MicroSubjectModel microSubjectModel:tempDict andType:2]];
            self.blankcount++;
        }
        NSArray *currArr = [responseObject[@"lessonobj"][@"quizcontent"] JSONValue][@"questionList"];
        NSInteger j = 0;
        for (NSArray *arr in currArr) {
            if(arr.count == 0){
                continue;
            }
            if ([arr[0] isEqualToString:@"choice"]) {
                for (int i = 0; i < [arr[1] count]; i++) {
                    if(i >= self.allSubjectArr.count){
                        continue;
                    }
                    
                    MicroSubjectModel *model = self.allSubjectArr[i];
                    if([arr[1][i][@"id"] isEqual:model.s_id]){
                    model.isRequireProcess = [arr[1][i][@"requireprocess"] integerValue] == 1 ? YES : NO;
                    j++;
                    }
                }
            }else{
                for (int i = 0; i < [arr[1] count]; i++) {
                    if(j >= self.allSubjectArr.count){
                        continue;
                    }
                    MicroSubjectModel *model = self.allSubjectArr[j];
                    if([arr[1][i][@"id"] isEqual:model.s_id]){
                    model.isRequireProcess = [arr[1][i][@"requireprocess"] integerValue] == 1 ? YES : NO;
                    j++;
                    }
                }
            }
        }
       
        self.count = 4;
        // 设置footerView
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        footerView.backgroundColor = COMMONCOLOR;
        UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        releaseBtn.backgroundColor = RGBACOLOR(0, 128.0, 255.0, 1);
        releaseBtn.width = SCREEN_WIDTH - 20;
        releaseBtn.height = 49;
        releaseBtn.centerX = footerView.centerX;
        releaseBtn.centerY = footerView.height / 2;
        [releaseBtn setTitle:@"发布给学生" forState:UIControlStateNormal];
        releaseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [releaseBtn addTarget:self action:@selector(releaseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [releaseBtn setTintColor:[UIColor whiteColor]];
        [footerView addSubview:releaseBtn];
        self.tableView.tableFooterView = footerView;
        self.videoURL = _microDetailM.videoUrlArr[0];
        [self.saveSubjectArr addObjectsFromArray:self.allSubjectArr];
        NSLog(@"%@", self.saveSubjectArr);
        // 刷新底部view
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
       
        [SVProgressHUD dismiss];
    }];
}
- (void)modifiContentData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"m_modify";
    pamar[@"id"] = self.m_id;
    
    NSLog(@"%@", [_microDetailM.questionList JSONString]);
    NSMutableArray *pamarArr = [NSMutableArray array];
    NSMutableArray *choiceArr = [NSMutableArray array];
    NSMutableArray *blankfillArr = [NSMutableArray array];
    for (MicroSubjectModel *model in _allSubjectArr) {
        NSNumber *levelNum = @1;
        if([model.level isEqualToString:@"中等"]){
            levelNum = @2;
        }else if ([model.level isEqualToString:@"较难"]){
            levelNum = @3;
        }
        if(model.type == 1){
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"id"] = model.s_id;
            
            dict[@"level"] = levelNum;
            dict[@"requireprocess"] = model.isRequireProcess ? @1 : @0;
            [choiceArr addObject:dict];
        }else{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"id"] = model.s_id;
            dict[@"level"] = levelNum;
            dict[@"requireprocess"] = model.isRequireProcess ? @1 : @0;
            [blankfillArr addObject:dict];
        }
            
    }
    NSMutableArray *tempArr1 = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    if(choiceArr.count != 0){
    [tempArr1 addObject:@"choice"];
    [tempArr1 addObject:choiceArr];
    }
    if(blankfillArr.count != 0){
    [tempArr2 addObject:@"blankfill"];
    [tempArr2 addObject:blankfillArr];
    }
    if(tempArr1.count != 0){
        [pamarArr addObject:tempArr1];
    }
    if(tempArr2 .count != 0){
        [pamarArr addObject:tempArr2];
    }

    pamar[@"questions"] = [pamarArr JSONString];
    
    pamar[@"name"] = _microDetailM.name;
    NSLog(@"%@", [pamarArr JSONString]);
    [mgr POST:[BaseURL stringByAppendingString:@"/api/teacher/mobile/lesson/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改内容成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"修改内容时出现错误"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];

}
- (void)modifiTitleData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"m_modify";
    pamar[@"id"] = self.m_id;
   
    pamar[@"name"] = _microDetailM.name;
    NSLog(@"%@", _microDetailM.name);
    [mgr POST:[BaseURL stringByAppendingString:@"/api/teacher/mobile/lesson/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改内容成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"修改内容时出现错误"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}
- (void)backBtnClicked
{
    if (_flag == 1) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"您正处于编辑状态,确认要退出?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:action1];
        [alertVc addAction:action2];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)modifyTitleBtnClick:(NSNotification *)noti
{
    if([noti.userInfo[@"btn"] integerValue] == 1){
        _flag = 1;
    }else{
        _flag = 0;
        [self modifiTitleData];
        if ([self.delegate respondsToSelector:@selector(microDetailViewController:andName:)]) {
            [self.delegate microDetailViewController:self andName:_microDetailM.name];
        }
    }
   
}
- (void)releaseBtnClicked
{
    [self closeTheVideo:nil];
    [self toCell];
    
    if(_microDetailM.isSelected == YES){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionTop];
        [SVProgressHUD showInfoWithStatus:@"请先确认发布的题目,并按下确定键"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SubjectTitleCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
            animation.fromValue = [NSNumber numberWithFloat:1.0f];
            animation.toValue = [NSNumber numberWithFloat:0.0f];
            
             animation.autoreverses = YES;
            animation.repeatCount = MAXFLOAT;
            animation.repeatDuration = 1.5;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [cell.editBtn.layer addAnimation:animation forKey:@"anmi"];
        });
     
    }else{
    ReleaseMicroController *vc = [[ReleaseMicroController alloc] init];
    vc.w_id = self.m_id;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void )addBtnClick
{
    PublishHomeworkViewController *homeVc = [[PublishHomeworkViewController alloc] init];
    [[QuestionDataBase shareDataBase] deleteMicroTable];
    for (MicroSubjectModel *model in _allSubjectArr) {
        [[QuestionDataBase shareDataBase] insertMirco:model];
    }
    [self.navigationController pushViewController:homeVc animated:YES];
}
- (void)setAddMicroArr:(NSMutableArray *)addMicroArr
{
    if(self.choicecount + self.blankcount == addMicroArr.count){
        return;
    }
    _microDetailM.isShouldProcess = NO;
    _addMicroArr = addMicroArr;
    NSMutableArray *choiceArr = [NSMutableArray array];
    NSMutableArray *blankfillArr = [NSMutableArray array];
    NSInteger i = 0;
    NSInteger j = 0;
    for (MicroSubjectModel *model in addMicroArr) {
        if(model.type == 1){
            [choiceArr addObject:model];
            if(i < self.choicecount){
                NSLog(@"%d", [self.allSubjectArr[i] isRequireProcess]);
                model.isRequireProcess = [self.allSubjectArr[i] isRequireProcess];
                i++;
            }
            
        }else{
            [blankfillArr addObject:model];
            if(j <  self.blankcount){
                model.isRequireProcess = [self.allSubjectArr[self.choicecount + j] isRequireProcess];
                j++;
            }
            
        }
        model.btnIsShow = YES;
    }
    [self.allSubjectArr removeAllObjects];
    [self.allSubjectArr addObjectsFromArray:choiceArr];
    [self.allSubjectArr addObjectsFromArray:blankfillArr];
    self.choicecount = choiceArr.count;
    self.blankcount = blankfillArr.count;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:4];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - wmPlayer的方法
-(void)videoDidFinished:(NSNotification *)notice{
    if(wmPlayer != nil){
        [self toCell];
    }
    ReleaseMicroCell *currentCell = (ReleaseMicroCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    wmPlayer.isPlay = NO;
    isStart = NO;
    currentCell.playBtn.hidden = NO;
    [self releaseWMPlayer];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)closeTheVideo:(NSNotification *)obj{
    
    ReleaseMicroCell *currentCell = (ReleaseMicroCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    currentCell.playBtn.hidden = NO;
    wmPlayer.isPlay = NO;
    isStart = NO;
    [self toCell];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                if (isSmallScreen) {
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }else{
                    [self toCell];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                wmPlayer.isFullscreen = YES;
                
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                wmPlayer.isFullscreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}


-(void)toCell{
    ReleaseMicroCell *currentCell = (ReleaseMicroCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [wmPlayer removeFromSuperview];
    NSLog(@"row = %ld",(long)currentIndexPath.row);
    wmPlayer.closeBtn.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = currentCell.backgroundIV.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [currentCell.backgroundIV addSubview:wmPlayer];
        [currentCell.backgroundIV bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    wmPlayer.closeBtn.hidden = YES;
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(SCREEN_WIDTH-40);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-SCREEN_HEIGHT/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toSmallScreen{
    //放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-60-(SCREEN_WIDTH/2)*0.575, SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*0.575);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        wmPlayer.closeBtn.hidden = YES;
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        wmPlayer.fullScreenBtn.selected = NO;
        isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
    }];
    
}
-(void)startPlayVideo:(UIButton *)sender{
    if(self.videoURL == nil){
        [self.view makeToast:@"请检查你的网络连接状态" duration:1.5 position:SHOW_CENTER complete:nil];
        return;
    }
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",(long)currentIndexPath.row);
    
    wmPlayer.isPlay = YES;
    isStart = YES;
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.videoCell = (ReleaseMicroCell *)sender.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        self.videoCell = (ReleaseMicroCell *)sender.superview.superview.subviews;
        
    }
    
    //    isSmallScreen = NO;
    if (isSmallScreen) {
        [self releaseWMPlayer];
        isSmallScreen = NO;
        
    }
    if (wmPlayer) {
        [wmPlayer removeFromSuperview];

         [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
        
    }else{
        wmPlayer = [[WMPlayer alloc]initWithFrame:self.videoCell.backgroundIV.bounds videoURLStr:self.videoURL];
        wmPlayer.closeBtn.hidden = YES;
        
    }
    wmPlayer.backBtn.hidden = YES;
    [wmPlayer setVideoURLStr:self.videoURL];
    [wmPlayer.player play];
     wmPlayer.isPlay = YES;
    // 将按钮放到底部
    [self.videoCell.backgroundIV addSubview:wmPlayer];
    [self.videoCell.backgroundIV bringSubviewToFront:wmPlayer];
    //    [self.videoCell.playBtn.superview sendSubviewToBack:self.videoCell.playBtn];
    self.videoCell.playBtn.hidden = YES;
    
//    [self.tableView reloadData];
    
}
/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    if(wmPlayer == nil){
        return;
    }
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    [wmPlayer.player pause];
    
    //移除观察者
    [wmPlayer.currentItem removeObserver:wmPlayer forKeyPath:@"status"];
    
//    [wmPlayer removeFromSuperview];
//    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    [wmPlayer.durationTimer invalidate];
    wmPlayer.durationTimer = nil;
    
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
//    });
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView ==self.tableView){
        if (wmPlayer==nil) {
            return;
        }
        
        if (wmPlayer.superview) {
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:currentIndexPath];
            CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            if (rectInSuperview.origin.y<-self.videoCell.backgroundIV.frame.size.height||rectInSuperview.origin.y>SCREEN_HEIGHT-64-60) {//往上拖动
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]&&isSmallScreen) {
                    isSmallScreen = YES;
                }else{
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }
                
            }else{
                if ([self.videoCell.backgroundIV.subviews containsObject:wmPlayer]) {
                    
                }else{
                    [self toCell];
                    
                }
            }
        }
        
    }
}

#pragma mark - Table view 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2 || section == 3){
        return 1;
    }else{
        return self.allSubjectArr.count + 1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ReleaseMicroCell *cell = [tableView dequeueReusableCellWithIdentifier:videoID];
        self.videoCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.playBtn.tag = indexPath.row;
      
        // 按钮的显示
        if (wmPlayer.isPlay == YES || isStart == YES) {
            cell.playBtn.hidden = YES;
        }else {
            
            cell.playBtn.hidden = NO;
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
        }
        
        if (wmPlayer&&wmPlayer.superview) {
            if (indexPath.row == currentIndexPath.row) {
                [cell.backgroundIV.superview sendSubviewToBack:cell.backgroundIV];
            }else{
                
                
            }
            
            NSArray *indexpaths = [tableView indexPathsForVisibleRows];
            
            if (![indexpaths containsObject:currentIndexPath]&&currentIndexPath!=nil) {//复用
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]) {
                    wmPlayer.hidden = NO;
                }else{
                    wmPlayer.hidden = YES;
                    
                    
                }
            }else{
                if ([cell.backgroundIV.subviews containsObject:wmPlayer]) {
                    [cell.backgroundIV addSubview:wmPlayer];
                    
                    [wmPlayer.player play];
                    wmPlayer.hidden = NO;
                }
                
            }
        }
        
        return cell;

        
    }else if(indexPath.section == 1){
        MicroNameCell *cell = [tableView dequeueReusableCellWithIdentifier:NameID];
        cell.model = _microDetailM;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){
        VideoNumShowCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoNumID];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _microDetailM;
        return cell;
    }else if(indexPath.section == 3){
        MicroKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:KnowledgeID];
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _microDetailM;
        return cell;
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            SubjectTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleID];
            cell.model = _microDetailM;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else{
            SubjectDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:subjectID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = indexPath.row;
            cell.delegate = self;
            cell.model = self.allSubjectArr[indexPath.row - 1];
            cell.subjectNumLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
            return cell;
        }
        
    }
   
    return nil;

}

- (void)webviewHeight:(NSNotification *)sender {

    SubjectDetailCell *cell = [sender object];
    if (![self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||fabs([[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2) {
        
        [self.cellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:4]] withRowAnimation:UITableViewRowAnimationNone];
    }


}
- (void)knowLegeWebViewHeight:(NSNotification *)noti
{
    MicroKnowledgeCell *cell = [noti object];
    if (![self.knowCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||fabs([[self.knowCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2) {
        
        [self.knowCellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  (SCREEN_WIDTH)*184/320;
    }else if (indexPath.section == 1) {
        return 70;
    }else if(indexPath.section == 2){
        if (_microDetailM.videoUrlArr.count == 1) {
            return 0;
        }else{
        return 80;
        }
    }else if (indexPath.section == 3){
     
        CGFloat height = [[self.knowCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] floatValue];
     
        return height == 0 ? 100 : height;
    
    
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            return 40;
        }else{
            CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] floatValue];
            if(_flag == 1){
                height += 40;
            }
            return height == 0 ? 300 : height;
        }
    }
    return 0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if(indexPath.section == 4 && indexPath.row != 0){
        OneSubjectController *vc = [[OneSubjectController alloc] init];
        MicroSubjectModel *model = self.allSubjectArr[indexPath.row - 1];
        vc.w_id =  [model.s_id stringValue];
        vc.qtype = model.type == 1 ? @"choice" : @"blankfill";
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        if (_microDetailM.videoUrlArr.count == 1) {
            return 0;
        }else{
            return 1;
        }
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
#pragma mark - SubjectTitleCellDelegate代理方法
- (void)subjectTitleCell:(SubjectTitleCell *)cell editBtnClicked:(UIButton *)btn
{
   
    if (btn.selected) {
        for (MicroSubjectModel *model in _allSubjectArr) {
            model.btnIsShow = YES;
        }
        _flag = 1;
    }else{
        _flag = 0;
        if(self.allSubjectArr.count == 0){
            [SVProgressHUD showErrorWithStatus:@"题目不能为空,编辑失败"];
            NSLog(@"%@", self.saveSubjectArr);
            [self.allSubjectArr addObjectsFromArray:self.saveSubjectArr];
            
            if (cell.model) {
                cell.model.isSelected = YES;
            }

            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            for (MicroSubjectModel *model in _allSubjectArr) {
                model.btnIsShow = YES;
            }
            return;
        }
        else{
            [self modifiContentData];
            for (MicroSubjectModel *model in _allSubjectArr) {
                model.btnIsShow = NO;
            }
        }
    }
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSLog(@"987%ld", indexpath.section );
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexpath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadData];
}
- (void)subjectTitleCell:(SubjectTitleCell *)cell requireProcessBtnClicked:(UIButton *)btn
{
    
    if (btn.selected == YES) {
        for (MicroSubjectModel *model in self.allSubjectArr) {
            model.isRequireProcess = YES;
        }
    }else{
        for (MicroSubjectModel *model in self.allSubjectArr) {
            model.isRequireProcess = NO;
        }
    }
    [self.tableView reloadData];
}
#pragma mark - VideoNumShowCellDelegate代理方法
- (void)videoNumShowCell:(VideoNumShowCell *)cell videoNumBtnClick:(UIButton *)btn
{
    if (lastSelectedVideoTag == btn.tag) { //点击同个视频，忽略
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    lastSelectedVideoTag = btn.tag;
    self.videoURL = _microDetailM.videoUrlArr[btn.tag];

    lastPlayingTaskInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeIntervalLocal = lastPlayingTaskInterval;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //延迟0.5秒播放，防止暴力点击
        if (lastPlayingTaskInterval > timeIntervalLocal) { //有新播放任务，放弃本次播放任务
            NSLog(@"有新播放任务，放弃本次播放任务");
            return;
        }
        
        NSLog(@"延时播放开始，对应按钮号：%ld",lastSelectedVideoTag);
    if (isSmallScreen) {// 小屏状态下
        
        [wmPlayer setVideoURLStr:self.videoURL];
        [wmPlayer.player play];
        
    }else {// 正常状态下
    
        ReleaseMicroCell *cell2 = (ReleaseMicroCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self startPlayVideo:cell2.playBtn];
    }
    
    });
   
//    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
#pragma mark - SubjectDetailCell代理方法
- (void)subjectDetailCell:(SubjectDetailCell *)cell deletedBtnClick:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld--%ld", indexPath.section, indexPath.row);
    MicroSubjectModel *model = self.allSubjectArr[indexPath.row - 1];
    if(model.type == 1){
        self.choicecount--;
    }else{
        self.blankcount--;
    }
    [self.allSubjectArr removeObjectAtIndex:(indexPath.row - 1)];
    NSLog(@"%@", self.saveSubjectArr);
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (void)subjectDetailCell:(SubjectDetailCell *)cell moveUpBtnClick:(UIButton *)btn
{
  
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 1) {
        [SVProgressHUD showWithStatus:@"已经是第一行了"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        return;
    }
    MicroSubjectModel *model1 = self.allSubjectArr[indexPath.row - 1];
    MicroSubjectModel *model2 = self.allSubjectArr[indexPath.row - 2];
    if (model1.type != model2.type) {
        [SVProgressHUD showWithStatus:@"填空题与选择题不能混合"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    [self.allSubjectArr exchangeObjectAtIndex:indexPath.row - 1 withObjectAtIndex:indexPath.row - 2];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}
- (void)subjectDetailCell:(SubjectDetailCell *)cell moveDownBtnClick:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld, %ld", indexPath.row, self.allSubjectArr.count);
    if (indexPath.row == self.allSubjectArr.count) {
        [SVProgressHUD showWithStatus:@"已经是最后一行了"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    MicroSubjectModel *model1 = self.allSubjectArr[indexPath.row - 1];
    MicroSubjectModel *model2 = self.allSubjectArr[indexPath.row];
    if (model1.type != model2.type) {
        [SVProgressHUD showWithStatus:@"填空题与选择题不能混合"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    [self.allSubjectArr exchangeObjectAtIndex:indexPath.row - 1 withObjectAtIndex:indexPath.row];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)subjectDetailCell:(SubjectDetailCell *)cell requireProcessBtnClick:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (btn.selected == NO) {
        _microDetailM.isShouldProcess = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}


@end
