//
//  ChildrenResultViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenResultViewController.h"
#import "ChildrenExplantionViewController.h"
#import "ChildrenVideoViewController.h"
#import "KWFormViewQuickBuilder.h"
#import "YjyxMemberDetailViewController.h"
#import "SummaryResultModel.h"
#import "ChildrenResultModel.h"
#import "ChildrenResultCell.h"
#import "ResultModel.h"
#import "YjyxAnonatationController.h"


#define ID @"result"
@interface ChildrenResultViewController ()<UIWebViewDelegate>
{
    NSArray *letterAry;
    NSString *subjectID;//科目ID，会员跳转时需要
    NSMutableDictionary *selectDic;//判断cell是否展开
    NSNumber *total_right;
    NSNumber *total_wrong;
    NSNumber *questionRight;
    NSNumber *questionWrong;
    

}

@property (nonatomic,strong) NSMutableArray *resultblankfills;//填充题答案
@property (nonatomic,strong) NSMutableArray *resultchoices;//选择题答案
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (nonatomic, strong) NSMutableDictionary *choiceModelDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillModelDic;
@property (nonatomic, strong) NSMutableDictionary *summaryChoiceModelDic;
@property (nonatomic, strong) NSMutableDictionary *summaryBlankModelDic;

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) NSMutableDictionary *choiceCellHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillExpandDic;

@end

@implementation ChildrenResultViewController


- (NSMutableArray *)resultchoices {
    
    if (!_resultchoices) {
        self.resultchoices = [NSMutableArray array];
    }
    return _resultchoices;
}

- (NSMutableArray *)resultblankfills {
    
    if (!_resultblankfills) {
        self.resultblankfills = [NSMutableArray array];
    }
    return _resultblankfills;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:13],NSFontAttributeName,nil]];
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self loadBackBtn];

    letterAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"M", nil];
    
    selectDic = [[NSMutableDictionary alloc] init];
    
    self.choiceModelDic = [[NSMutableDictionary alloc] init];
    self.blankfillModelDic = [[NSMutableDictionary alloc] init];
    self.summaryChoiceModelDic = [[NSMutableDictionary alloc] init];
    self.summaryBlankModelDic = [[NSMutableDictionary alloc] init];
    
    self.choiceCellHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillExpandDic = [[NSMutableDictionary alloc] init];
    
    // 获取数据源
    [self getchildResult:self.taskResultId];
    
    // 注册加载完成高度的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableviewCellHeight:) name:@"WEBVIEW_HEIGHT" object:nil];
    
    // 注册cell
    [self.resultTable registerNib:[UINib nibWithNibName:NSStringFromClass([ChildrenResultCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    
    
}

// 通知方法
- (void)refreshTableviewCellHeight:(NSNotification *)sender {

    ChildrenResultCell *cell = [sender object];
    
    // 保存高度
    if (cell.indexPath.section == 0) {
        
        if (![self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
        {
            [self.choiceCellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.resultTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else {
        if (![self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
        {
            
            NSLog(@"%@", [self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]);
            NSLog(@"%.f", cell.height);
            
            [self.blankfillHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.resultTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:1 ]] withRowAnimation:UITableViewRowAnimationNone];
            
        }

    }

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden = NO;
}



- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
//    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Request
-(void)getchildResult:(NSString *)resultId
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:resultId,@"id", nil];
    [[YjxService sharedInstance] getChildrenTaskResult:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                
                NSLog(@"%@", result);
                [self.resultchoices removeAllObjects];
                [self.resultblankfills removeAllObjects];
                
                subjectID = [[result objectForKey:@"data"] objectForKey:@"subjectid"];
                total_right = [result[@"data"][@"task__total_correct"] isEqual:[NSNull null]] ? @0 : result[@"data"][@"task__total_correct"];
                total_wrong = [result[@"data"][@"task__total_wrong"] isEqual:[NSNull null]] ? @0 : result[@"data"][@"task__total_wrong"];
                questionRight = [result[@"data"][@"summary"][@"correct"] isEqual:[NSNull null]] ? @0 : result[@"data"][@"summary"][@"correct"];
                questionWrong = [result[@"data"][@"summary"][@"wrong"] isEqual:[NSNull null]] ? @0 : result[@"data"][@"summary"][@"wrong"];
                
                NSString *questionRate = [questionRight floatValue] + [questionWrong floatValue] == 0 ? @"0%" : [NSString stringWithFormat:@"%.f%%", [questionRight floatValue] * 100 / ([questionRight floatValue] + [questionWrong floatValue])];
                NSString *taskRate = [total_right floatValue] + [total_wrong floatValue] == 0 ? @"0%" : [NSString stringWithFormat:@"%.f%%", [total_right floatValue] * 100 / ([total_right floatValue] + [total_wrong floatValue])];
                NSString *summaryString = [NSString stringWithFormat:@"对%@题  错%@题  |  任务正确率%@  |  作业平均正确率%@", questionRight, questionWrong, questionRate, taskRate];
                NSMutableAttributedString *summaryAttributString = [[NSMutableAttributedString alloc] initWithString:summaryString];
                
                // 正则匹配
                NSString *reg = @"[0-9]+|%";
                NSError *error = nil;
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:reg options:NSRegularExpressionCaseInsensitive error:&error];
                NSArray *array = [regex matchesInString:summaryString options:0 range:NSMakeRange(0, summaryString.length)];
                if (array.count) {
                    for (int i = 0; i < array.count; i++) {
                        NSTextCheckingResult *result = array[i];
                        NSRange range = result.range;
                        [summaryAttributString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e71419"] range:range];
                    }

                }
                
                self.summaryLabel.attributedText = summaryAttributString;
                
                // 选择题每题答题概要信息
                NSDictionary *summaryChoiceDic = [[[result objectForKey:@"data"] objectForKey:@"summary_perquestion"] objectForKey:@"choice"];
                for (NSString *key in [summaryChoiceDic allKeys]) {
                    SummaryResultModel *model = [[SummaryResultModel alloc] init];
                    [model initModelWithDic:[summaryChoiceDic objectForKey:key]];
                    [self.summaryChoiceModelDic setObject:model forKey:key];
                }
                
                // 填空题每题答题概要信息
                NSDictionary *summaryBlankfillDic = [[[result objectForKey:@"data"] objectForKey:@"summary_perquestion"] objectForKey:@"blankfill"];
                for (NSString *key in [summaryBlankfillDic allKeys]) {
                    SummaryResultModel *model = [[SummaryResultModel alloc] init];
                    [model initModelWithDic:[summaryBlankfillDic objectForKey:key]];
                    [self.summaryBlankModelDic setObject:model forKey:key];
                }
                
                // 选择题内容
                NSDictionary *choiceDic = [[result objectForKey:@"data"] objectForKey:@"choices"];
                for (NSString *key in [choiceDic allKeys]) {
                    ChildrenResultModel *model = [[ChildrenResultModel alloc] init];
                    [model initModelWithDic:[choiceDic objectForKey:key]];
                    model.answerCount = [choiceDic objectForKey:key][@"choicecount"];
                    [self.choiceModelDic setObject:model forKey:key];
                }
                
                
                // 填空题内容
                NSDictionary *blankfillDic = [[result objectForKey:@"data"] objectForKey:@"blankfills"];
                for (NSString *key in [blankfillDic allKeys]) {
                    ChildrenResultModel *model = [[ChildrenResultModel alloc] init];
                    [model initModelWithDic:[blankfillDic objectForKey:key]];
                    model.answerCount = [blankfillDic objectForKey:key][@"blankcount"];
                    [self.blankfillModelDic setObject:model forKey:key];
                }
                
                // 选择题学生答题结果
                NSArray *resultChoiceArr = [[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"choice"];
                for (NSArray *arr in resultChoiceArr) {
                    ResultModel *model = [[ResultModel alloc] init];
                    [model initModelWithArray:arr];
                    [self.resultchoices addObject:model];
                }
                
                
                // 填空题学生答题结果
                NSArray *resultBlankfillArr = [[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"blankfill"];
                for (NSArray *arr in resultBlankfillArr) {
                    ResultModel *model = [[ResultModel alloc] init];
                    [model initModelWithArray:arr];
                    [self.resultblankfills addObject:model];
                }
                
        
                [_resultTable reloadData];
                
                
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}



#pragma mark -UITablevViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
   
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {// 选择题
        return self.resultchoices.count;
    }else {// 填空题
    
        return self.resultblankfills.count;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        if (_resultchoices.count > 0) {
            return 25;
        }else {
        
            return 0;
        }
    }else {
    
        if (_resultblankfills.count > 0) {
            return 25;
        }else {
        
            return 0;
        }
        
    }
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        if (_resultchoices.count > 0) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
            return titlelb;

        }else {
        
            return nil;
        }
        
    }else {
        
        if (_resultblankfills.count > 0) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }else {
        
            return nil;
        }
        
        
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.section == 0) {
        
        CGFloat height = [[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        
        if (height == 0) {
            
            return 300;
            
        }else {
        
            return height;
        }
        

    }else {
    
        CGFloat height = [[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        
        if (height == 0) {
            
            return 300;
            
        }else {
            
            return height;
        }

    }
     
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildrenResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.indexPath = indexPath;
    
    if (cell.solutionBtn.hidden == NO) {
        [cell.solutionBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (cell.annotationBtn.hidden == NO) {
        [cell.annotationBtn addTarget:self action:@selector(getTheAnotation:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.section == 0) {
        ResultModel *resultModel = self.resultchoices[indexPath.row];
        // 选择题
        ChildrenResultModel *model = [self.choiceModelDic objectForKey:[NSString stringWithFormat:@"%@", resultModel.q_id]];
        SummaryResultModel *su_model = [self.summaryChoiceModelDic objectForKey:[NSString stringWithFormat:@"%@", resultModel.q_id]];
        model.questionType = @"choice";
        resultModel.questionType = @"choice";
        
        [cell setSubviewsWithChildrenResultModel:model andResultModel:resultModel andSummaryResultModel:su_model];
        
//        [cell setSubviewsWithChildrenResultModel:model andResultModel:resultModel];
        
        cell.tag = indexPath.row;
    
        
    }else {
        
        // 填空题
        ResultModel *resultModel = self.resultblankfills[indexPath.row];
        NSLog(@"^^^^^^^^%@", resultModel.q_id);
        ChildrenResultModel *model = [self.blankfillModelDic objectForKey:[NSString stringWithFormat:@"%@", resultModel.q_id]];
        SummaryResultModel *su_model = [self.summaryBlankModelDic objectForKey:[NSString stringWithFormat:@"%@", resultModel.q_id]];
        model.questionType = @"blankfill";
        resultModel.questionType = @"blankfill";
        [cell.expandBtn addTarget:self action:@selector(changeCellHeight:) forControlEvents:UIControlEventTouchUpInside];
        cell.expandBtn.selected = [[self.blankfillExpandDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue];
        
        NSString *expand = [self.blankfillExpandDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        
        if (expand == nil) {
            cell.expandBtn.selected = NO;
        }else {
            cell.expandBtn.selected = [expand boolValue];
        }
        
        [cell setSubviewsWithChildrenResultModel:model andResultModel:resultModel andSummaryResultModel:su_model];
//        [cell setSubviewsWithChildrenResultModel:model andResultModel:resultModel];
        
        cell.tag = indexPath.row;
        
    }
    

    return cell;
    
    
}


- (void)changeCellHeight:(UIButton *)sender {

    ChildrenResultCell *cell = (ChildrenResultCell *)sender.superview.superview.superview;
    cell.expandBtn.selected = !cell.expandBtn.selected;
    
    if (cell.expandBtn.selected == YES) {
        [self.blankfillExpandDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld", cell.indexPath.row]];
    }else {
        [self.blankfillExpandDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld", cell.indexPath.row]];
    }
    
    [_resultTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:cell.indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 40;
    //固定section 随着cell滚动而滚动
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

#pragma mark -myevent
-(void)playVideo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ChildrenResultCell *cell = (ChildrenResultCell *)btn.superview.superview.superview;
    
    NSString *videoUrl;
    NSString *explantionStr;
    
    if (cell.indexPath.section == 0) {//选择题
        ResultModel *rmodel = self.resultchoices[cell.indexPath.row];
//        NSLog(@"%@", rmodel.q_id);
        ChildrenResultModel *model = [self.choiceModelDic objectForKey:[NSString stringWithFormat:@"%@", rmodel.q_id]];
        
        videoUrl = model.videourl;
        explantionStr = model.explanation;
    }else{//填空题
        ResultModel *rmodel = self.resultblankfills[cell.indexPath.row];
        ChildrenResultModel *model = [self.blankfillModelDic objectForKey:[NSString stringWithFormat:@"%@", rmodel.q_id]];
        
        videoUrl = model.videourl;
        explantionStr = model.explanation;
    }

    //判断是否有权限查看视频解析
    
    if (videoUrl.length == 0 &&explantionStr.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"查看解题方法需要会员权限，是否前往试用或成为会员?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    }else{
        ChildrenVideoViewController *vc = [[ChildrenVideoViewController alloc] init];
        vc.URLString = videoUrl;
        vc.explantionStr = explantionStr;
        vc.title = @"详解";
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)getTheAnotation:(UIButton *)sender {

    ChildrenResultCell *cell = (ChildrenResultCell *)sender.superview.superview.superview;
    
    YjyxAnonatationController *anonatationVC = [[YjyxAnonatationController alloc] init];

    if (cell.indexPath.section == 0) {//选择题
        ResultModel *rmodel = self.resultchoices[cell.indexPath.row];
        anonatationVC.processArr = [rmodel.writeprocess mutableCopy];
    }else{//填空题
        ResultModel *rmodel = self.resultblankfills[cell.indexPath.row];
        anonatationVC.processArr = [rmodel.writeprocess mutableCopy];
        
    }
    
    [self.navigationController pushViewController:anonatationVC animated:YES];

}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getonememproductinfo",@"action",subjectID,@"subjectid",nil];
        [[YjxService sharedInstance] getOneMemberProduct:dic withBlock:^(id result, NSError *error){//查看商品详情
            [self.view hideToastActivity];
            if (result) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                     ProductEntity *entity = [ProductEntity wrapProductEntityWithDic:result];
                    
                    YjyxMemberDetailViewController *detail = [[YjyxMemberDetailViewController alloc] init];
                    detail.title = [entity.subject_name stringByAppendingString:@"会员"];
                    detail.productEntity = entity;
                    [detail setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:detail animated:YES];
                }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }else{
                [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];

    }
}


- (void)dealloc {

    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
是否现实展开箭头
*/
//-(BOOL)showArrow:(NSInteger)index
//{
//    NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:index] firstObject]];
//    NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
//    NSArray *resultary = [[_resultblankfills objectAtIndex:index] objectAtIndex:1];
//    
//    CGFloat height = 0;
//    NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
//    
//    NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[tureAnswerAry objectAtIndex:0]];
//    UILabel *turecontentLb = [UILabel labelWithFrame:CGRectMake(45, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureStr];
//    turecontentLb.numberOfLines = 0;
//    [turecontentLb sizeToFit];
//    CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    
//    //自己答案
//    NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[resultary objectAtIndex:0]];
//    UILabel *contentLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:contentStr];
//    contentLb.numberOfLines = 0;
//    [contentLb sizeToFit];
//    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    
//    height = height + (turesize.height>size.height?turesize.height:size.height) +5;
//    
//    if (height<25&&[resultary count]<2) {
//        return NO;
//    }else{
//        return YES;
//    }
//}


/*
是否显示标题
*/
//-(BOOL)isShowTitle:(NSArray *)array type:(NSInteger)type
//{
//    BOOL showTitle = NO;
//    for (int i = 0; i< [array count]; i++) {
//        NSString *key = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] firstObject]];
//        NSString *content;
//        if (type == 1) {
//            content = [[_choices objectForKey:key] objectForKey:@"content"];
//        }else{
//            content = [[_blankfills objectForKey:key] objectForKey:@"content"];
//        }
//        if (content.length > 0) {
//            return YES;
//        }
//    }
//    return showTitle;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
