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
#import "RCLabel.h"
#import "KWFormViewQuickBuilder.h"
#import "YjyxMemberDetailViewController.h"
#import "ChildrenResultModel.h"
#import "ChildrenResultCell.h"
#import "ResultModel.h"


#define ID @"result"
@interface ChildrenResultViewController ()<UIWebViewDelegate>
{
    NSArray *letterAry;
    NSString *subjectID;//科目ID，会员跳转时需要
    NSMutableDictionary *selectDic;//判断cell是否展开

}

@property (nonatomic,strong) NSMutableArray *resultblankfills;//填充题答案
@property (nonatomic,strong) NSMutableArray *resultchoices;//选择题答案

@property (nonatomic, strong) NSMutableDictionary *choiceModelDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillModelDic;

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) NSMutableDictionary *choiceCellHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillHeightDic;

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
    
    self.choiceCellHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillHeightDic = [[NSMutableDictionary alloc] init];
    
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
                
                
                [self.resultchoices removeAllObjects];
                [self.resultblankfills removeAllObjects];
                
                subjectID = [[result objectForKey:@"data"] objectForKey:@"subjectid"];
                
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
    
    if (indexPath.section == 0) {
        ResultModel *resultModel = self.resultchoices[indexPath.row];
        
        // 选择题
        ChildrenResultModel *model = [self.choiceModelDic objectForKey:[NSString stringWithFormat:@"%@", resultModel.q_id]];
        
        model.questionType = @"choice";
        resultModel.questionType = @"choice";
        
        [cell setSubviewsWithChildrenResultModel:model andResultModel:resultModel];
        
        if (cell.solutionBtn.hidden == NO) {
            [cell.solutionBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.tag = indexPath.row;
    
        
    }else {
        
        // 填空题
        ResultModel *resultModel = self.resultblankfills[indexPath.row];
        ChildrenResultModel *model = [self.blankfillModelDic objectForKey:[NSString stringWithFormat:@"%@", resultModel.q_id]];
        model.questionType = @"blankfill";
        resultModel.questionType = @"blankfill";
        [cell setSubviewsWithChildrenResultModel:model andResultModel:resultModel];
        cell.tag = indexPath.row;
        
    }
    

    return cell;
    
    
//    static NSString *simpleCell = @"simpleCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleCell];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    for (UIView *subview in cell.contentView.subviews) {
//        [subview removeFromSuperview];
//    }
//    
//    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH-10, 120-4)];
//    bg.backgroundColor = [UIColor clearColor];
//    bg.layer.borderWidth = 1;
//    bg.layer.borderColor = RGBACOLOR(225, 225, 225, 1).CGColor;
//    
//    if (indexPath.section == 0) {
//        if ([_resultchoices count]>0) {//选择题
//            NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:indexPath.row] firstObject]];
//            
//      
//            NSString *content = [[_choices objectForKey:key] objectForKey:@"content"];
//            
//            UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 1000)];
//            [web loadHTMLString:content baseURL:nil];
//            
//            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//            if (content == nil) {
//                return cell;
//            }
//            
//            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
//            templabel.userInteractionEnabled = NO;
//            templabel.font = [UIFont systemFontOfSize:14];
//            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
//         
//            templabel.componentsAndPlainText = componentsDS;
//            CGSize optimalSize = [templabel optimumSize];
//            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 50);
//            
//            ChildrenResultModel *model = [[ChildrenResultModel alloc] init];
//            [model initModelWithDic:[_choices objectForKey:key]];
//            model.height = bg.frame.size.height;
//            [self.choiceModelArr addObject:model];
//            
//            
//            [cell.contentView addSubview:bg];
//            
//            [bg addSubview:web];
//            
//            // 分割线
//            UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, web.height + 8, SCREEN_WIDTH - 16, 1)];
//            imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
//            [cell.contentView addSubview:imageLine];
//            // 如果是多项选择
//            NSString *tureAnswer = nil;
//            if ([[[_choices objectForKey:key] objectForKey:@"answer"] containsString:@"|"]) {
//                NSArray *tempArr =  [[[_choices objectForKey:key] objectForKey:@"answer"] componentsSeparatedByString:@"|"];
//                for (NSString *str in tempArr) {
//                    NSString *tempStr = [letterAry objectAtIndex:[str integerValue]];
//                    if (tureAnswer == nil) {
//                        tureAnswer = [NSString stringWithFormat:@"%@", tempStr];
//                    }else{
//                    tureAnswer = [NSString stringWithFormat:@"%@%@", tureAnswer,tempStr];
//                    }
//                }
//                
//            }else{
//            tureAnswer = [letterAry objectAtIndex:[[[_choices objectForKey:key] objectForKey:@"answer"] integerValue]];
//            }
//            UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, web.height + 12, 150, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:14] context:[NSString stringWithFormat:@"正确答案:%@",tureAnswer]];
//            [cell.contentView addSubview:answerLb];
//            
//            UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, web.height+19, 60, 20)];
//            explainText.tag = indexPath.row;
//            [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
////            [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
//            // 解题方法按钮
//            [explainText setTitle:@"解题方法" forState:UIControlStateNormal];
//            [explainText setCornerRadius:5];
//            explainText.titleLabel.font = [UIFont systemFontOfSize:12];
//            explainText.backgroundColor = RGBACOLOR(22, 156, 111, 1);
//            [cell.contentView addSubview:explainText];
//            
////            NSLog(@"%@", [_choices objectForKey:key]);
//            //  是否是会员
//            if ([[[_choices objectForKey:key] objectForKey:@"showview"] isEqual:@1]) {
//                explainText.hidden = NO;
//            }else {
//            
//                explainText.hidden = YES;
//            }
//            
//
//            NSString *myanswer1 = [[NSString alloc] initWithFormat:@""];
//            NSArray *resultary = [[_resultchoices objectAtIndex:indexPath.row] objectAtIndex:1];
//            NSLog(@"%@", _resultchoices);
//            NSLog(@"%@", resultary);
//            for (int i = 0; i< [resultary count]; i++) {
//                myanswer1 = [myanswer1 stringByAppendingString:[NSString stringWithFormat:@" %@",[letterAry objectAtIndex:[[resultary objectAtIndex:i] integerValue]]]];
//            }
//            
//            NSString *myanswer = [[NSString alloc] initWithFormat:@""];
//            NSInteger answerCount = [[[_choices objectForKey:key] objectForKey:@"choicecount"] integerValue];
//            NSLog(@"%ld", answerCount);
//            for (int i =0 ; i< answerCount; i++) {
//                myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@" %@",[letterAry objectAtIndex:i]]];
//            }
//            NSLog(@"%@", myanswer);
//            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:myanswer];
//            
//            BOOL isture = [[[_resultchoices objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
//            
//            for (int i = 0; i < resultary.count; i++) {
//                NSRange range =  NSMakeRange([resultary[i] integerValue] * 2 + 1, 1);
////                BOOL isture = [[[_resultchoices objectAtIndex:indexPath.row] objectAtIndex:1][i] boolValue];
//                if (isture) {
//                    [attributeString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(100, 174, 99, 1) range:range];
//                }else{
//                    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//                }
//                [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
//            }
////            NSLog(@"%@", [_resultchoices objectAtIndex:indexPath.row]);
////            NSRange range = [myanswer rangeOfString:myanswer1];
////            NSLog(@"%@", NSStringFromRange(range));
////            if (isture) {
////                [attributeString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(100, 174, 99, 1) range:range];
////            }else{
////                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
////            }
////            [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
//            
//            UILabel *childrenAnswer = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 40, optimalSize.height +12, SCREEN_WIDTH/2 - 50, 38)];
//            childrenAnswer.attributedText = attributeString;
//            childrenAnswer.font = [UIFont systemFontOfSize:13];
//            [cell.contentView addSubview:childrenAnswer];
//            
//            UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, optimalSize.height+15, 30, 28)];
//            [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
//            [cell.contentView addSubview:truebtn];
//            
//        }else{//填空题
//            
//            NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
//            
//            //题目内容
//            NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
//            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//            if (content == nil) {
//                return cell;
//            }
//            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
//            templabel.userInteractionEnabled = NO;
//            templabel.font = [UIFont systemFontOfSize:14];
//            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
//            templabel.componentsAndPlainText = componentsDS;
//            CGSize optimalSize = [templabel optimumSize];
//            
//            NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
//            NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
//            
//            NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+[_resultchoices count]]];
//            
//            CGFloat height = optimalSize.height +22;
//            
//            NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
//            if ([isOpne isEqualToString:@"0"]) {
//                //正确答案
//                NSString *tureAnswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[tureAnswerAry objectAtIndex:0]];
//                UILabel *turemyanswerLb = [UILabel labelWithFrame:CGRectMake(65, optimalSize.height+22, SCREEN_WIDTH/2 - 110, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureAnswer];
//                [bg addSubview:turemyanswerLb];
//                
//                //自己答案
//                NSString *myanswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[resultary objectAtIndex:0]];
//                UILabel *myanswerLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, optimalSize.height+22, SCREEN_WIDTH/2 - 90, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:myanswer];
//                [bg addSubview:myanswerLb];
//            }else{
//                for (int i = 0; i< [resultary count]; i++) {
//                    //正确答案
//                    NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[tureAnswerAry objectAtIndex:i]];
//                    UILabel *turecontentLb = [UILabel labelWithFrame:CGRectMake(65, height, SCREEN_WIDTH/2 - 110, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureStr];
//                    turecontentLb.numberOfLines = 0;
//                    [turecontentLb sizeToFit];
//                    CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//                    
//                    //自己答案
//                    NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[resultary objectAtIndex:i]];
//                    UILabel *contentLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:contentStr];
//                    contentLb.numberOfLines = 0;
//                    [contentLb sizeToFit];
//                    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//                    
//                    height = height + (turesize.height>size.height?turesize.height:size.height) +5;
//                    
//                    UIImageView *imageline = [[UIImageView alloc] initWithFrame:CGRectMake(40, height-2, SCREEN_WIDTH - 100, 1)];
//                    imageline.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//                    [bg addSubview:imageline];
//                    [bg addSubview:contentLb];
//                    [bg addSubview:turecontentLb];
//                }
//                
//            }
//            
//            
//            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , 20 + height);
//            
//            ChildrenResultModel *model = [[ChildrenResultModel alloc] init];
//            [model initModelWithDic:[_blankfills objectForKey:key]];
//            model.height = bg.frame.size.height;
//            [self.blankfillModelArr addObject:model];
//            
//            [cell.contentView addSubview:bg];
//            
//            [bg addSubview:templabel];
//            
//            UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
//            imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
//            [cell.contentView addSubview:imageLine];
//            
//            
//            
//            //正确答案
//            UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 60, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:14] context:[NSString stringWithFormat:@"正确答案"]];
//            [cell.contentView addSubview:answerLb];
//            
//            
//            
//            //解析图标显示
//            UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, optimalSize.height+19, 60, 20)];
//            explainText.tag = indexPath.row+100;
//            [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
//            [explainText setTitle:@"解题方法" forState:UIControlStateNormal];
//            [explainText setCornerRadius:5];
//            explainText.titleLabel.font = [UIFont systemFontOfSize:12];
//            explainText.backgroundColor = RGBACOLOR(22, 156, 111, 1);
////            [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
//            [cell.contentView addSubview:explainText];
//            
//            if ([[[_blankfills objectForKey:key] objectForKey:@"showview"] isEqual:@1]) {
//                explainText.hidden = NO;
//            }else {
//            
//                explainText.hidden = YES;
//            }
//            
//            
//            //收起展开按钮显示
//            UIButton *expandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, optimalSize.height+21, 16, 16)];
//            
//            if ([isOpne isEqualToString:@"0"]) {
//                [expandBtn setImage:[UIImage imageNamed:@"homework_open.png"] forState:UIControlStateNormal];
//            }else{
//                [expandBtn setImage:[UIImage imageNamed:@"homework_close.png"] forState:UIControlStateNormal];
//            }
//            [expandBtn addTarget:self action:@selector(showMoreContent:) forControlEvents:UIControlEventTouchUpInside];
//            expandBtn.tag = [_resultchoices count] + indexPath.row;
//            
//            
//            if ([self showArrow:indexPath.row]) {
//                [cell.contentView addSubview:expandBtn];
//            }
//            
//            
//            //对错按钮显示
//            UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, optimalSize.height+15, 30, 28)];
//            BOOL isture = [[[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
//            [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
//            [cell.contentView addSubview:truebtn];
//            
//
//        }
//        
//        
//    }else{//填空题
//        
//        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
//        
//        //题目内容
//        NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
//        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
//        if (content == nil) {
//            return cell;
//        }
//        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
//        templabel.userInteractionEnabled = NO;
//        templabel.font = [UIFont systemFontOfSize:14];
//        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
//        templabel.componentsAndPlainText = componentsDS;
//        CGSize optimalSize = [templabel optimumSize];
//        
//        NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
//        NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
//        
//        NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+[_resultchoices count]]];
//        
//        CGFloat height = optimalSize.height +22;
//        NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
//        if ([isOpne isEqualToString:@"0"]) {
//            //正确答案
//            NSString *tureAnswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[tureAnswerAry objectAtIndex:0]];
//            UILabel *turemyanswerLb = [UILabel labelWithFrame:CGRectMake(65, optimalSize.height+22, SCREEN_WIDTH/2 - 110, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureAnswer];
//            [bg addSubview:turemyanswerLb];
//            
//            //自己答案
//            NSString *myanswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[resultary objectAtIndex:0]];
//            UILabel *myanswerLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, optimalSize.height+22, SCREEN_WIDTH/2 - 90, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:myanswer];
//            [bg addSubview:myanswerLb];
//        }else{
//            for (int i = 0; i< [resultary count]; i++) {
//                //正确答案
//                NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[tureAnswerAry objectAtIndex:i]];
//                UILabel *turecontentLb = [UILabel labelWithFrame:CGRectMake(65, height, SCREEN_WIDTH/2 - 110, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureStr];
//                turecontentLb.numberOfLines = 0;
//                [turecontentLb sizeToFit];
//                CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//                
//                //自己答案
//                NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[resultary objectAtIndex:i]];
//                UILabel *contentLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:contentStr];
//                contentLb.numberOfLines = 0;
//                [contentLb sizeToFit];
//                CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//                
//                height = height + (turesize.height>size.height?turesize.height:size.height) +5;
//                
//                UIImageView *imageline = [[UIImageView alloc] initWithFrame:CGRectMake(40, height-2, SCREEN_WIDTH - 100, 1)];
//                imageline.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//                [bg addSubview:imageline];
//                [bg addSubview:contentLb];
//                [bg addSubview:turecontentLb];
//            }
//
//        }
//        
//
//        bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , 20 + height);
//        
//        ChildrenResultModel *model = [[ChildrenResultModel alloc] init];
//        [model initModelWithDic:[_blankfills objectForKey:key]];
//        model.height = bg.frame.size.height;
//        [self.blankfillModelArr addObject:model];
//
//        
//        [cell.contentView addSubview:bg];
//        
//        [bg addSubview:templabel];
//        
//        UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
//        imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
//        [cell.contentView addSubview:imageLine];
//        
//
//        
//        //正确答案
//        UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 60, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:14] context:[NSString stringWithFormat:@"正确答案"]];
//        [cell.contentView addSubview:answerLb];
//
//        
//
//        //解析图标显示
//        UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, optimalSize.height+19, 60, 20)];
//        explainText.tag = indexPath.row+100;
//        [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
//        [explainText setTitle:@"解题方法" forState:UIControlStateNormal];
//        [explainText setCornerRadius:5];
//        explainText.titleLabel.font = [UIFont systemFontOfSize:12];
//        explainText.backgroundColor = RGBACOLOR(22, 156, 111, 1);
////        [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
//        [cell.contentView addSubview:explainText];
//        
//        if ([[[_blankfills objectForKey:key] objectForKey:@"showview"] isEqual:@1]) {
//            explainText.hidden = NO;
//        }else {
//            
//            explainText.hidden = YES;
//        }
//
//    
//
//        
//
//        //收起展开按钮显示
//        UIButton *expandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, optimalSize.height+21, 16, 16)];
//
//        if ([isOpne isEqualToString:@"0"]) {
//            [expandBtn setImage:[UIImage imageNamed:@"homework_open.png"] forState:UIControlStateNormal];
//        }else{
//            [expandBtn setImage:[UIImage imageNamed:@"homework_close.png"] forState:UIControlStateNormal];
//        }
//        [expandBtn addTarget:self action:@selector(showMoreContent:) forControlEvents:UIControlEventTouchUpInside];
//        expandBtn.tag = [_resultchoices count] + indexPath.row;
//        if ([self showArrow:indexPath.row]) {
//            [cell.contentView addSubview:expandBtn];
//        }
//        
//        //对错按钮显示
//        UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, optimalSize.height+15, 30, 28)];
//        BOOL isture = [[[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
//        [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
//        [cell.contentView addSubview:truebtn];
//        
//        
//    }
//    
//    
//    return cell;
}





-(void)showMoreContent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    [selectDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    if ([isOpne isEqualToString:@"0"]) {
        [selectDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }else{
        [selectDic setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    [_resultTable reloadData];
    
    NSInteger section = btn.tag>=[_resultchoices count]?1:0;
    if ([_resultchoices count] == 0) {
        section = 0;
    }
    
    NSInteger row = btn.tag -[_resultchoices count];
    [_resultTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"查看解题方法需要会员权限，是否前往试用或成为会员" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    }else{
        ChildrenVideoViewController *vc = [[ChildrenVideoViewController alloc] init];
        vc.URLString = videoUrl;
        vc.explantionStr = explantionStr;
        vc.title = @"详解";
        [self.navigationController pushViewController:vc animated:YES];

    }
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
