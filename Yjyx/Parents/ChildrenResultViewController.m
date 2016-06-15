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

@interface ChildrenResultViewController ()
{
    NSArray *letterAry;
    NSString *subjectID;//科目ID，会员跳转时需要
    NSMutableDictionary *selectDic;//判断cell是否展开
}

@end

@implementation ChildrenResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:13],NSFontAttributeName,nil]];
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self loadBackBtn];
    [self getchildResult:self.taskResultId];
    letterAry = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"M", nil];
    _blankfills = [[NSDictionary alloc] init];
    _choices = [[NSDictionary alloc] init];
    _resultblankfills = [[NSArray alloc] init];
    _resultchoices = [[NSArray alloc] init];
    selectDic = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"RCLabelReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshJurisdiction) name:@"refreshjurisdiction" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadTable
{
    [_resultTable reloadData];
}

-(void)refreshJurisdiction
{
    [self getchildResult:self.taskResultId];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RCLabelReload" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshjurisdiction" object:nil];
    [super viewWillDisappear:YES];
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
                subjectID = [[result objectForKey:@"data"] objectForKey:@"subjectid"];
                _blankfills = [[result objectForKey:@"data"] objectForKey:@"blankfills"];
                _choices = [[result objectForKey:@"data"] objectForKey:@"choices"];
                _resultchoices = [[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"choice"];
                _resultblankfills = [[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"blankfill"];
                [_resultTable reloadData];
                for (int i = 0; i<[_resultchoices count]+[_resultblankfills count]; i++) {
                    [selectDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
                }
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
    if ([_resultchoices count]>0&&[_resultblankfills  count]>0) {
        return 2;
    }else if ([_resultblankfills count]==0&&[_resultchoices count]==0){
        return 0;
    }else {
    
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_resultchoices count]>0) {
            return [_resultchoices count];
        }
        return [_resultblankfills count];
    }else{
        return [_resultblankfills count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        if ([_resultchoices count]>0) {
            if ([self isShowTitle:_resultchoices type:1]) {
                return 25;
            }else{
                return 0;
            }
        }else{
            if ([self isShowTitle:_resultblankfills type:2]) {
                return 25;
            }else{
                return 0;
            }
        }
    }else{
        if ([self isShowTitle:_resultblankfills type:2]) {
            return 25;
        }else{
            return 0;
        }
    }
//    return 25;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_resultchoices count]>0) {
            if ([self isShowTitle:_resultchoices type:1]) {
                UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
                return titlelb;
            }else{
                return nil;
            }

        }else{
            if ([self isShowTitle:_resultblankfills type:2]) {
                UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
                return titlelb;
            }else{
                return nil;
            }

        }
    }else{
        if ([self isShowTitle:_resultblankfills type:2]) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }else{
            return nil;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_resultchoices count]>0) {//有选择题
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_choices objectForKey:key] objectForKey:@"content"];
            if (content == nil) {
                return 0;
            }
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            return optimalSize.height +55;
        }else{//只有填空题
            
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            if (content == nil) {
                return 0;
            }
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+[_resultchoices count]]];
            NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
            NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];

            NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
            if ([isOpne isEqualToString:@"0"]) {
                return optimalSize.height + 50;
            }else{
                CGFloat height = 0;
                for (int i = 0; i< [resultary count]; i++) {
                    
                    NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[tureAnswerAry objectAtIndex:i]];
                    CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                    
                    //自己答案
                    NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[resultary objectAtIndex:i]];
                    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                    
                    height = height + (turesize.height>size.height?turesize.height:size.height) +5;
                    
                }
                return optimalSize.height + 50 + height;
                
            }

        }
    }else
    {
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
        NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        if (content == nil) {
            return 0;
        }
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
        templabel.userInteractionEnabled = NO;
        templabel.font = [UIFont systemFontOfSize:14];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        
        NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+[_resultchoices count]]];
        NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
        NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];

        NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
        if ([isOpne isEqualToString:@"0"]) {
            return optimalSize.height + 50;
        }else{
            CGFloat height = 0;
            for (int i = 0; i< [resultary count]; i++) {
                NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[tureAnswerAry objectAtIndex:i]];
                CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                
                //自己答案
                NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[resultary objectAtIndex:i]];
                CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                
                height = height + (turesize.height>size.height?turesize.height:size.height) +5;
            }
            return optimalSize.height + 50 + height;

        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH-10, 120-4)];
    bg.backgroundColor = [UIColor clearColor];
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = RGBACOLOR(225, 225, 225, 1).CGColor;
    
    if (indexPath.section == 0) {
        if ([_resultchoices count]>0) {//选择题
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_choices objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            if (content == nil) {
                return cell;
            }
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 50);
            [cell.contentView addSubview:bg];
            
            [bg addSubview:templabel];
            
            
            UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
            imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
            [cell.contentView addSubview:imageLine];
            NSString *tureAnswer = nil;
            if ([[[_choices objectForKey:key] objectForKey:@"answer"] containsString:@"|"]) {
                NSArray *tempArr =  [[[_choices objectForKey:key] objectForKey:@"answer"] componentsSeparatedByString:@"|"];
                for (NSString *str in tempArr) {
                    NSString *tempStr = [letterAry objectAtIndex:[str integerValue]];
                    if (tureAnswer == nil) {
                        tureAnswer = [NSString stringWithFormat:@"%@", tempStr];
                    }else{
                    tureAnswer = [NSString stringWithFormat:@"%@%@", tureAnswer,tempStr];
                    }
                }
                
            }else{
            tureAnswer = [letterAry objectAtIndex:[[[_choices objectForKey:key] objectForKey:@"answer"] integerValue]];
            }
            UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 150, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:14] context:[NSString stringWithFormat:@"正确答案:%@",tureAnswer]];
            [cell.contentView addSubview:answerLb];
            
            UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, optimalSize.height+19, 60, 20)];
            explainText.tag = indexPath.row;
            [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
//            [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
            [explainText setTitle:@"解题方法" forState:UIControlStateNormal];
            [explainText setCornerRadius:5];
            explainText.titleLabel.font = [UIFont systemFontOfSize:12];
            explainText.backgroundColor = RGBACOLOR(22, 156, 111, 1);
            [cell.contentView addSubview:explainText];
            
            NSLog(@"%@", [_choices objectForKey:key]);
            
            if ([[[_choices objectForKey:key] objectForKey:@"showview"] isEqual:@1]) {
                explainText.hidden = NO;
            }else {
            
                explainText.hidden = YES;
            }
            

            NSString *myanswer1 = [[NSString alloc] initWithFormat:@""];
            NSArray *resultary = [[_resultchoices objectAtIndex:indexPath.row] objectAtIndex:1];
            for (int i = 0; i< [resultary count]; i++) {
                myanswer1 = [myanswer1 stringByAppendingString:[NSString stringWithFormat:@"%@ ",[letterAry objectAtIndex:[[resultary objectAtIndex:i] integerValue]]]];
            }
            
            NSString *myanswer = [[NSString alloc] initWithFormat:@""];
            NSInteger answerCount = [[[_choices objectForKey:key] objectForKey:@"choicecount"] integerValue];
            for (int i =0 ; i< answerCount; i++) {
                myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@"%@ ",[letterAry objectAtIndex:i]]];
            }
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:myanswer];
            
            BOOL isture = [[[_resultchoices objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];

            NSRange range = [myanswer rangeOfString:myanswer1];
            if (isture) {
                [attributeString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(100, 174, 99, 1) range:range];
            }else{
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            }
            [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            
            UILabel *childrenAnswer = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 40, optimalSize.height +12, SCREEN_WIDTH/2 - 50, 38)];
            childrenAnswer.attributedText = attributeString;
            childrenAnswer.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:childrenAnswer];
            
            UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, optimalSize.height+15, 30, 28)];
            [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
            [cell.contentView addSubview:truebtn];
            
        }else{//填空题
            
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
            
            //题目内容
            NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            if (content == nil) {
                return cell;
            }
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
            NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
            
            NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+[_resultchoices count]]];
            
            CGFloat height = optimalSize.height +22;
            
            NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
            if ([isOpne isEqualToString:@"0"]) {
                //正确答案
                NSString *tureAnswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[tureAnswerAry objectAtIndex:0]];
                UILabel *turemyanswerLb = [UILabel labelWithFrame:CGRectMake(65, optimalSize.height+22, SCREEN_WIDTH/2 - 110, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureAnswer];
                [bg addSubview:turemyanswerLb];
                
                //自己答案
                NSString *myanswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[resultary objectAtIndex:0]];
                UILabel *myanswerLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, optimalSize.height+22, SCREEN_WIDTH/2 - 90, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:myanswer];
                [bg addSubview:myanswerLb];
            }else{
                for (int i = 0; i< [resultary count]; i++) {
                    //正确答案
                    NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[tureAnswerAry objectAtIndex:i]];
                    UILabel *turecontentLb = [UILabel labelWithFrame:CGRectMake(65, height, SCREEN_WIDTH/2 - 110, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureStr];
                    turecontentLb.numberOfLines = 0;
                    [turecontentLb sizeToFit];
                    CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                    
                    //自己答案
                    NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[resultary objectAtIndex:i]];
                    UILabel *contentLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:contentStr];
                    contentLb.numberOfLines = 0;
                    [contentLb sizeToFit];
                    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                    
                    height = height + (turesize.height>size.height?turesize.height:size.height) +5;
                    
                    UIImageView *imageline = [[UIImageView alloc] initWithFrame:CGRectMake(40, height-2, SCREEN_WIDTH - 100, 1)];
                    imageline.backgroundColor = RGBACOLOR(230, 230, 230, 1);
                    [bg addSubview:imageline];
                    [bg addSubview:contentLb];
                    [bg addSubview:turecontentLb];
                }
                
            }
            
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , 20 + height);
            [cell.contentView addSubview:bg];
            
            [bg addSubview:templabel];
            
            UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
            imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
            [cell.contentView addSubview:imageLine];
            
            
            
            //正确答案
            UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 60, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:14] context:[NSString stringWithFormat:@"正确答案"]];
            [cell.contentView addSubview:answerLb];
            
            
            
            //解析图标显示
            UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, optimalSize.height+19, 60, 20)];
            explainText.tag = indexPath.row+100;
            [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
            [explainText setTitle:@"解题方法" forState:UIControlStateNormal];
            [explainText setCornerRadius:5];
            explainText.titleLabel.font = [UIFont systemFontOfSize:12];
            explainText.backgroundColor = RGBACOLOR(22, 156, 111, 1);
//            [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:explainText];
            
            if ([[[_blankfills objectForKey:key] objectForKey:@"showview"] isEqual:@1]) {
                explainText.hidden = NO;
            }else {
            
                explainText.hidden = YES;
            }
            
            
            //收起展开按钮显示
            UIButton *expandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, optimalSize.height+21, 16, 16)];
            
            if ([isOpne isEqualToString:@"0"]) {
                [expandBtn setImage:[UIImage imageNamed:@"homework_open.png"] forState:UIControlStateNormal];
            }else{
                [expandBtn setImage:[UIImage imageNamed:@"homework_close.png"] forState:UIControlStateNormal];
            }
            [expandBtn addTarget:self action:@selector(showMoreContent:) forControlEvents:UIControlEventTouchUpInside];
            expandBtn.tag = [_resultchoices count] + indexPath.row;
            
            
            if ([self showArrow:indexPath.row]) {
                [cell.contentView addSubview:expandBtn];
            }
            
            
            //对错按钮显示
            UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, optimalSize.height+15, 30, 28)];
            BOOL isture = [[[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
            [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
            [cell.contentView addSubview:truebtn];
            

        }
        
        
    }else{//填空题
        
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
        
        //题目内容
        NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        if (content == nil) {
            return cell;
        }
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
        templabel.userInteractionEnabled = NO;
        templabel.font = [UIFont systemFontOfSize:14];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        
        NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
        NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
        
        NSString *isOpne = [selectDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row+[_resultchoices count]]];
        
        CGFloat height = optimalSize.height +22;
        NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
        if ([isOpne isEqualToString:@"0"]) {
            //正确答案
            NSString *tureAnswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[tureAnswerAry objectAtIndex:0]];
            UILabel *turemyanswerLb = [UILabel labelWithFrame:CGRectMake(65, optimalSize.height+22, SCREEN_WIDTH/2 - 110, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureAnswer];
            [bg addSubview:turemyanswerLb];
            
            //自己答案
            NSString *myanswer = [NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[resultary objectAtIndex:0]];
            UILabel *myanswerLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, optimalSize.height+22, SCREEN_WIDTH/2 - 90, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:myanswer];
            [bg addSubview:myanswerLb];
        }else{
            for (int i = 0; i< [resultary count]; i++) {
                //正确答案
                NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[tureAnswerAry objectAtIndex:i]];
                UILabel *turecontentLb = [UILabel labelWithFrame:CGRectMake(65, height, SCREEN_WIDTH/2 - 110, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureStr];
                turecontentLb.numberOfLines = 0;
                [turecontentLb sizeToFit];
                CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                
                //自己答案
                NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:i],[resultary objectAtIndex:i]];
                UILabel *contentLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:contentStr];
                contentLb.numberOfLines = 0;
                [contentLb sizeToFit];
                CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                
                height = height + (turesize.height>size.height?turesize.height:size.height) +5;
                
                UIImageView *imageline = [[UIImageView alloc] initWithFrame:CGRectMake(40, height-2, SCREEN_WIDTH - 100, 1)];
                imageline.backgroundColor = RGBACOLOR(230, 230, 230, 1);
                [bg addSubview:imageline];
                [bg addSubview:contentLb];
                [bg addSubview:turecontentLb];
            }

        }
        

        bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , 20 + height);
        [cell.contentView addSubview:bg];
        
        [bg addSubview:templabel];
        
        UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
        imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
        [cell.contentView addSubview:imageLine];
        

        
        //正确答案
        UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 60, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:14] context:[NSString stringWithFormat:@"正确答案"]];
        [cell.contentView addSubview:answerLb];

        

        //解析图标显示
        UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, optimalSize.height+19, 60, 20)];
        explainText.tag = indexPath.row+100;
        [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [explainText setTitle:@"解题方法" forState:UIControlStateNormal];
        [explainText setCornerRadius:5];
        explainText.titleLabel.font = [UIFont systemFontOfSize:12];
        explainText.backgroundColor = RGBACOLOR(22, 156, 111, 1);
//        [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:explainText];
        
        if ([[[_blankfills objectForKey:key] objectForKey:@"showview"] isEqual:@1]) {
            explainText.hidden = NO;
        }else {
            
            explainText.hidden = YES;
        }

    

        

        //收起展开按钮显示
        UIButton *expandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, optimalSize.height+21, 16, 16)];

        if ([isOpne isEqualToString:@"0"]) {
            [expandBtn setImage:[UIImage imageNamed:@"homework_open.png"] forState:UIControlStateNormal];
        }else{
            [expandBtn setImage:[UIImage imageNamed:@"homework_close.png"] forState:UIControlStateNormal];
        }
        [expandBtn addTarget:self action:@selector(showMoreContent:) forControlEvents:UIControlEventTouchUpInside];
        expandBtn.tag = [_resultchoices count] + indexPath.row;
        if ([self showArrow:indexPath.row]) {
            [cell.contentView addSubview:expandBtn];
        }
        
        //对错按钮显示
        UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, optimalSize.height+15, 30, 28)];
        BOOL isture = [[[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
        [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
        [cell.contentView addSubview:truebtn];
        
        
    }
    
    
    return cell;
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
    NSString *videoUrl;
    NSString *explantionStr;
    if (btn.tag/100 == 0) {//选择题
        NSInteger index = btn.tag;
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:index] firstObject]];
        videoUrl = [[_choices objectForKey:key] objectForKey:@"videourl"];
        explantionStr =[[_choices objectForKey:key] objectForKey:@"explanation"];
    }else{//填空题
        NSInteger index = btn.tag%100;
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:index] firstObject]];
        videoUrl = [[_blankfills objectForKey:key] objectForKey:@"videourl"];
        explantionStr = [[_blankfills objectForKey:key] objectForKey:@"explanation"];
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
-(BOOL)showArrow:(NSInteger)index
{
    NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:index] firstObject]];
    NSArray *tureAnswerAry = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
    NSArray *resultary = [[_resultblankfills objectAtIndex:index] objectAtIndex:1];
    
    CGFloat height = 0;
    NSArray *cornerAry =[NSArray arrayWithObjects:@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨",@"⑩",@"⑪",@"⑫",@"⑬",@"⑭",@"⑮",@"⑯",@"⑰",@"⑱",@"⑲",@"⑳", nil];
    
    NSString *tureStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[tureAnswerAry objectAtIndex:0]];
    UILabel *turecontentLb = [UILabel labelWithFrame:CGRectMake(45, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:tureStr];
    turecontentLb.numberOfLines = 0;
    [turecontentLb sizeToFit];
    CGSize turesize = [tureStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    //自己答案
    NSString *contentStr =[NSString stringWithFormat:@"%@%@",[cornerAry objectAtIndex:0],[resultary objectAtIndex:0]];
    UILabel *contentLb = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2+30, height, SCREEN_WIDTH/2 - 90, 12) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:contentStr];
    contentLb.numberOfLines = 0;
    [contentLb sizeToFit];
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2 - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    height = height + (turesize.height>size.height?turesize.height:size.height) +5;
    
    if (height<25&&[resultary count]<2) {
        return NO;
    }else{
        return YES;
    }
}


/*
是否显示标题
*/
-(BOOL)isShowTitle:(NSArray *)array type:(NSInteger)type
{
    BOOL showTitle = NO;
    for (int i = 0; i< [array count]; i++) {
        NSString *key = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] firstObject]];
        NSString *content;
        if (type == 1) {
            content = [[_choices objectForKey:key] objectForKey:@"content"];
        }else{
            content = [[_blankfills objectForKey:key] objectForKey:@"content"];
        }
        if (content.length > 0) {
            return YES;
        }
    }
    return showTitle;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
