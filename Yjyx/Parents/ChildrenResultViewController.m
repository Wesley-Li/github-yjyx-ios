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

@interface ChildrenResultViewController ()
{
    NSArray *letterAry;
}

@end

@implementation ChildrenResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"RCLabelReload" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadTable
{
    [_resultTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RCLabelReload" object:nil];
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
                _blankfills = [[result objectForKey:@"data"] objectForKey:@"blankfills"];
                _choices = [[result objectForKey:@"data"] objectForKey:@"choices"];
                _resultchoices = [[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"choice"];
                _resultblankfills = [[[result objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"blankfill"];
                NSDictionary *dic = [[_choices allValues] firstObject];
                NSLog(@"%@",[dic objectForKey:@"content"]);
                [_resultTable reloadData];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
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
    }
    return 1;
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
    return 25;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_resultchoices count]>0) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
            return titlelb;
        }else{
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }
    }else{
        UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
        return titlelb;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_resultchoices count]>0) {//有选择题
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_choices objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:12];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            return optimalSize.height +55;
        }else{//只有填空题
            
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:12];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
            NSInteger answerCount = [resultary count]%3 == 0?([resultary count]/3):([resultary count]/3 +1);
            CGFloat answerHeight = 20*(answerCount-1);
            return optimalSize.height +55 + answerHeight;
        }
    }else
    {
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
        NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
        templabel.font = [UIFont systemFontOfSize:12];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        
        NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
        NSInteger answerCount = [resultary count]%3 == 0?([resultary count]/3):([resultary count]/3 +1);
        CGFloat answerHeight = 20*(answerCount-1);
        return optimalSize.height +55 + answerHeight;
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
        if ([_resultchoices count]>0) {//只有选择题
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_choices objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:12];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 50);
            [cell.contentView addSubview:bg];
            
            [bg addSubview:templabel];
            
            
            UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
            imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
            [cell.contentView addSubview:imageLine];
            NSLog(@"%@",_resultchoices);
          
            NSString *tureAnswer = [letterAry objectAtIndex:[[[_choices objectForKey:key] objectForKey:@"answer"] integerValue]];
            
            UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 60, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:15] context:[NSString stringWithFormat:@"正确:%@",tureAnswer]];
            [cell.contentView addSubview:answerLb];
            
            UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, optimalSize.height+12, 60, 38)];
            explainText.tag = indexPath.row+indexPath.section *10;
            [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
            [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:explainText];
            
            if ([[[_choices objectForKey:key] objectForKey:@"videourl"] length] == 0&&[[[_blankfills objectForKey:key] objectForKey:@"explanation"] length] == 0) {
                explainText.hidden = YES;
            }else{
                explainText.hidden = NO;
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
            
            NSRange range = [myanswer rangeOfString:myanswer1];
            
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            
            UILabel *childrenAnswer = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 40, optimalSize.height +12, SCREEN_WIDTH/2 - 50, 38)];
            childrenAnswer.attributedText = attributeString;
            childrenAnswer.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:childrenAnswer];
            
            UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, optimalSize.height+12, 40, 38)];
            BOOL isture = [[[_resultchoices objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
            [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
            [cell.contentView addSubview:truebtn];
            
        }else{//只有填空题
            NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
            NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.font = [UIFont systemFontOfSize:12];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
            NSInteger answerCount = [resultary count]%3 == 0?([resultary count]/3):([resultary count]/3 +1);
            CGFloat answerHeight = 20*(answerCount-1);
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 50 + answerHeight);
            [cell.contentView addSubview:bg];
            
            [bg addSubview:templabel];
            
            
            UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
            imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
            [cell.contentView addSubview:imageLine];
            
            //正确答案
            UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 30, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:15] context:[NSString stringWithFormat:@"正确"]];
            [cell.contentView addSubview:answerLb];
            
            NSArray *myAnswer = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
            NSInteger myanswerCount = [myAnswer count]%3 == 0?([myAnswer count]/3):([myAnswer count]/3 +1);
            KWFormViewQuickBuilder *mybuilder = [[KWFormViewQuickBuilder alloc] init];
            for (int i = 0; i < myanswerCount; i++) {
                NSString *str1 = (i+(i*3))>=[resultary count]?@"":[myAnswer objectAtIndex:(i*3)];
                NSString *str2 = (1+(i*3))>=[resultary count]?@"":[myAnswer objectAtIndex:(1+(i*3))];
                NSString *str3 = (2+(i*3))>=[resultary count]?@"":[myAnswer objectAtIndex:(2+(i*3))];
                [mybuilder addRecord:@[str1,str2,str3]];
            }
            
            KWFormView *myanswerformView = [mybuilder startCreatWithWidths:@[@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3)] startPoint:CGPointMake(45 , optimalSize.height + 22)];
            [cell.contentView addSubview:myanswerformView];
            
            //解析图标显示
            UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, optimalSize.height+12, 60, 38)];
            explainText.tag = indexPath.row+indexPath.section *100;
            [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
            [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:explainText];
            
            if ([[[_blankfills objectForKey:key] objectForKey:@"videourl"] length] == 0&&[[[_blankfills objectForKey:key] objectForKey:@"explanation"] length] == 0) {
                explainText.hidden = YES;
            }else{
                explainText.hidden = NO;
            }
            
            
            //小孩答案显示
            NSString *myanswer = [[NSString alloc] initWithFormat:@""];
            for (int i = 0; i< [resultary count]; i++) {
                myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@" %@",[resultary objectAtIndex:i] ]];
            }
        
            KWFormViewQuickBuilder *builder = [[KWFormViewQuickBuilder alloc] init];
            for (int i = 0; i < answerCount; i++) {
                NSString *str1 = (i*3)>=[resultary count]?@"":[resultary objectAtIndex:(i*3)];
                NSString *str2 = (1+(i*3))>=[resultary count]?@"":[resultary objectAtIndex:(1+i*3)];
                NSString *str3 = (2+(i*3))>=[resultary count]?@"":[resultary objectAtIndex:(2+i*3)];
                [builder addRecord:@[str1,str2,str3]];
            }
            
            KWFormView *answerformView = [builder startCreatWithWidths:@[@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3)] startPoint:CGPointMake(SCREEN_WIDTH/2 +40, optimalSize.height + 12)];
            [cell.contentView addSubview:answerformView];

            
            UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, optimalSize.height+12, 40, 38)];
            BOOL isture = [[[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
            [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
            [cell.contentView addSubview:truebtn];

        }
        
        
    }else{
        
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:indexPath.row] firstObject]];
        
        
        
        NSString *content = [[_blankfills objectForKey:key] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
        templabel.font = [UIFont systemFontOfSize:12];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        
        
        
        
        
        NSArray *resultary = [[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:1];
        NSInteger answerCount = [resultary count]%3 == 0?([resultary count]/3):([resultary count]/3 +1);
        CGFloat answerHeight = 20*(answerCount-1);
        bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 50 + answerHeight);
        [cell.contentView addSubview:bg];
        
        [bg addSubview:templabel];
        
        
        UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(8, optimalSize.height + 8, SCREEN_WIDTH - 16, 1)];
        imageLine.backgroundColor = RGBACOLOR(220, 220, 220, 1);
        [cell.contentView addSubview:imageLine];
        NSLog(@"%@",_resultchoices);
        NSString *myanswer = [[NSString alloc] initWithFormat:@""];
        for (int i = 0; i< [resultary count]; i++) {
            myanswer = [myanswer stringByAppendingString:[NSString stringWithFormat:@" %@",[resultary objectAtIndex:i] ]];
        }
        
        //正确答案
        UILabel *answerLb = [UILabel labelWithFrame:CGRectMake(10, optimalSize.height + 12, 30, 38) textColor:RGBACOLOR(100, 174, 99, 1) font:[UIFont systemFontOfSize:15] context:[NSString stringWithFormat:@"正确"]];
        [cell.contentView addSubview:answerLb];
        
        NSArray *myAnswer = [[[_blankfills objectForKey:key] objectForKey:@"answer"] JSONValue];
        NSInteger myanswerCount = [myAnswer count]%3 == 0?([myAnswer count]/3):([myAnswer count]/3 +1);
        KWFormViewQuickBuilder *mybuilder = [[KWFormViewQuickBuilder alloc] init];
        for (int i = 0; i < myanswerCount; i++) {
            NSString *str1 = (i+(i*3))>=[resultary count]?@"":[myAnswer objectAtIndex:(i*3)];
            NSString *str2 = (1+(i*3))>=[resultary count]?@"":[myAnswer objectAtIndex:(1+(i*3))];
            NSString *str3 = (2+(i*3))>=[resultary count]?@"":[myAnswer objectAtIndex:(2+(i*3))];
            [mybuilder addRecord:@[str1,str2,str3]];
        }
        
        KWFormView *myanswerformView = [mybuilder startCreatWithWidths:@[@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3)] startPoint:CGPointMake(45 , optimalSize.height + 22)];
        [cell.contentView addSubview:myanswerformView];

        
        //解析图标显示
        UIButton *explainText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, optimalSize.height+12, 60, 38)];
        explainText.tag = indexPath.row+indexPath.section *100;
        [explainText addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [explainText setImage:[UIImage imageNamed:@"homework_1.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:explainText];
        
        if ([[[_blankfills objectForKey:key] objectForKey:@"videourl"] length] == 0&&[[[_blankfills objectForKey:key] objectForKey:@"explanation"] length] == 0) {
            explainText.hidden = YES;
        }else{
            explainText.hidden = NO;
        }

    

        
        //小孩答案显示
        KWFormViewQuickBuilder *builder = [[KWFormViewQuickBuilder alloc] init];
        for (int i = 0; i < answerCount; i++) {
            NSString *str1 = (i+(i*3))>=[resultary count]?@"":[resultary objectAtIndex:(i*3)];
            NSString *str2 = (1+(i*3))>=[resultary count]?@"":[resultary objectAtIndex:(1+(i*3))];
            NSString *str3 = (2+(i*3))>=[resultary count]?@"":[resultary objectAtIndex:(2+(i*3))];
            [builder addRecord:@[str1,str2,str3]];
        }
        
        KWFormView *answerformView = [builder startCreatWithWidths:@[@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3),@((SCREEN_WIDTH/2 - 90)/3)] startPoint:CGPointMake(SCREEN_WIDTH/2 +40, optimalSize.height + 22)];
        [cell.contentView addSubview:answerformView];


        UIButton *truebtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, optimalSize.height+12, 40, 38)];
        BOOL isture = [[[_resultblankfills objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
        [truebtn setImage:[UIImage imageNamed:isture?@"homework_3":@"homework_4"] forState:UIControlStateNormal];
        [cell.contentView addSubview:truebtn];
        
        
    }
    
    
    return cell;
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
    if (btn.tag/100 == 0) {
        NSInteger index = btn.tag%100;
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultchoices objectAtIndex:index] firstObject]];
        videoUrl = [[_choices objectForKey:key] objectForKey:@"videourl"];
        explantionStr = [[_choices objectForKey:key] objectForKey:@"explanation"];
    }else{
        NSInteger index = btn.tag%100;
        NSString *key = [NSString stringWithFormat:@"%@",[[_resultblankfills objectAtIndex:index] firstObject]];
        videoUrl = [[_blankfills objectForKey:key] objectForKey:@"videourl"];
        explantionStr = [[_blankfills objectForKey:key] objectForKey:@"explanation"];
    }
    ChildrenVideoViewController *vc = [[ChildrenVideoViewController alloc] init];
    vc.URLString = videoUrl;
    vc.explantionStr = [explantionStr stringByReplacingOccurrencesOfString:@"" withString:@""];
    vc.title = @"详解";
    [self.navigationController pushViewController:vc animated:YES];
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
