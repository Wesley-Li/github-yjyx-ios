//
//  YjyxMemberDetailViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/4/4.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxMemberDetailViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YjyxPayDetailViewController.h"
#import "YjyxStuWrongListViewController.h"
#import "YjyxWorkDetailController.h"
#import "YjyxThreeStageAnswerController.h"
#import "YiTeachMicroController.h"
#import "ChildrenResultViewController.h"


@interface YjyxMemberDetailViewController ()<UIWebViewDelegate>
{
    UIView *chooseView;
    UIView *payView;
    UILabel *payPriceLb;
    NSMutableArray *trailChildAry;//可试用的小孩
    NSMutableArray *openChildAry;//可开通的小孩
    NSString *childrenCid;//开通小孩的ID
    NSString *ppiIndex;//套餐index号
    NSString *AlipayStr;
}

@end

@implementation YjyxMemberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    trailChildAry = [[NSMutableArray alloc] init];
    openChildAry = [[NSMutableArray alloc] init];
    payBtn.hidden = YES;
    if(_productEntity.price_pacakge.count == 0){
        openBtn.enabled = NO;
    }else{
        openBtn.enabled = YES;
    }
    self.navigationItem.title = [_productEntity.subject_name stringByAppendingString:@"会员"];
    titleLb.text = [NSString stringWithFormat:@"%@会员特权",self.productEntity.subject_name];
    NSLog(@"%@", self.productEntity.content);
    
    contentLb = [[UILabel alloc] initWithFrame:CGRectMake(35, 46, SCREEN_WIDTH - 50, 50)];
    contentLb.font = [UIFont systemFontOfSize:12];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[self.productEntity.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    contentLb.attributedText = attString;
    CGFloat height = [contentLb.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    contentLb.frame = CGRectMake(35, 46, SCREEN_WIDTH - 50, height);
    [self.view addSubview:contentLb];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(self.jumpType == 1){
        [self getStudentStatus];
    }else{
    [self getChildrenStatus];
    }
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 家长端中的小孩
//获取小孩状态
- (void)getChildrenStatus
{
    NSMutableArray *cids = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[YjyxOverallData sharedInstance].parentInfo.childrens count]; i++) {
        ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
        [cids addObject:childrenEntity.cid];
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"subjectstatus",@"action",[cids JSONString],@"cids",self.productEntity.subject_id,@"subjectid", nil];
    [[YjxService sharedInstance] getsubjectStatus:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                
                NSMutableArray *childkeys = [[NSMutableArray alloc] init];

                NSArray *dataAry = [result objectForKey:@"data"];
                
                for (int i = 0; i< [dataAry count]; i++) {
                    NSDictionary *dic = [dataAry objectAtIndex:i];
                    [childkeys addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cid"]]];
                }
                [trailChildAry removeAllObjects];
                [openChildAry removeAllObjects];
                for (ChildrenEntity *entity in [YjyxOverallData sharedInstance].parentInfo.childrens){
                    
                    if (![childkeys containsObject:[NSString stringWithFormat:@"%@",entity.cid]]) {
                        [trailChildAry addObject:entity];//可以使用的小孩数组
                    }
                    [openChildAry addObject:entity];//可以开通的小孩数组，默认小孩都可以再次开通
                    
                }
                [self reloadView:result];//显示试用期的小孩
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}


-(void)reloadView:(NSDictionary *)dic
{

    for (UIView *view in _detailView.subviews) {
        if (view.tag>=1000) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *dataAry = [dic objectForKey:@"data"];
    for (int i = 0; i < [dataAry count]; i++) {
        NSDictionary *content = [dataAry objectAtIndex:i];
        NSInteger effctivedays = [[content objectForKey:@"effctivedays"] integerValue];
        ChildrenEntity *entity = [[YjyxOverallData sharedInstance] getChildrenWithCid:[content objectForKey:@"cid"]];
        UILabel *trailLb = [UILabel labelWithFrame:CGRectMake(35, (contentLb.frame.origin.y+contentLb.frame.size.height + 10)+i*25, 200, 20) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:15] context:@""];
        if ([[content objectForKey:@"purchasetype"] integerValue] == 2) {
            if ([[content objectForKey:@"status"] integerValue] ==2) {
                trailLb.text = [NSString stringWithFormat:@"%@:试用期已过期",entity.name];
            }else{
                
                trailLb.text = [NSString stringWithFormat:@"%@:试用天数还剩%@天",entity.name,[content objectForKey:@"effctivedays"]];
            }
        }else{
            
            if ([[content objectForKey:@"status"] integerValue] ==2) {
                trailLb.text = [NSString stringWithFormat:@"%@:会员已过期",entity.name];

            }else {
                if([[content objectForKey:@"effctivedays"] isEqual:@0])
                {
                    trailLb.text = [NSString stringWithFormat:@"%@:会员即将到期",entity.name];

                }else{
                trailLb.text = [NSString stringWithFormat:@"%@:会员剩余%@天",entity.name,[content objectForKey:@"effctivedays"]];
                }
            }
            
        }
        trailLb.tag = 1000+i;
        [_detailView addSubview:trailLb];
    }
    
    _detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (contentLb.frame.origin.y+contentLb.frame.size.height + 20)+dataAry.count*25);
    trailBtn.frame = CGRectMake(trailBtn.frame.origin.x, _detailView.frame.size.height+40, trailBtn.frame.size.width,trailBtn.frame.size.height);
    openBtn.frame = CGRectMake(openBtn.frame.origin.x, trailBtn.frame.origin.y + 45, openBtn.frame.size.width, openBtn.frame.size.height);
    trailBtn.hidden = [trailChildAry count] == 0? YES:NO;
    openBtn.hidden = [openChildAry count] == 0 ? YES:NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -MyEvent
- (IBAction)probationClicked:(UIButton *)sender //试用按钮
{
    sender.userInteractionEnabled = NO;
    if(_jumpType == 0){// 家长端
    if (trailChildAry.count== 0) {
        [self.view makeToast:@"暂无可试用小孩" duration:1.0 position:SHOW_CENTER complete:nil];
         sender.userInteractionEnabled = YES;
        return;
    }
    chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    chooseView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    [self.view addSubview:chooseView];
    CGFloat height = trailChildAry.count*50+70;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-height, SCREEN_WIDTH, height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [chooseView addSubview:contentView];
    
    UILabel *titleLb = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17] context:@"选择小孩"];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 0.5)];
    imageLine.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [contentView addSubview:imageLine];
    
    for (int i = 0 ; i <trailChildAry.count; i++) {
        ChildrenEntity *child = [trailChildAry objectAtIndex:i];
        UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50*(i+1)+8, 35, 35)];
        [headerImg setImageWithURL:[NSURL URLWithString:child.childavatar] placeholderImage:[UIImage imageNamed:@"Personal_children.png"]];
        [contentView addSubview:headerImg];
        
        UILabel *nameLb = [UILabel labelWithFrame:CGRectMake(60, 50*(i+1)+8, 250, 35) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16] context:child.name];
        [contentView addSubview:nameLb];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50*(i+1)+49, SCREEN_WIDTH-10, 0.5)];
        line.backgroundColor = RGBACOLOR(230, 230, 230, 1);
        [contentView addSubview:line];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50*(i+1), SCREEN_WIDTH, 50)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(chooseChildren:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [contentView addSubview:btn];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissChooseView:)];
    chooseView.userInteractionEnabled = YES;
    [chooseView addGestureRecognizer:tap];
    }else{  // 学生端
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"trial",@"action", self.productEntity.productID,@"productid", nil];

        [[YjxService sharedInstance] studentTrialProduct:dic withBlock:^(id result, NSError *error){
            if (result != nil) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    [self getStudentStatus];//开通以后重新刷新界面
                    for (UIViewController *vc in self.navigationController.childViewControllers) {

                        if ([vc isKindOfClass:[YjyxStuWrongListViewController class]] || [vc isKindOfClass:[YjyxWorkDetailController class]] || [vc isKindOfClass:[YjyxThreeStageAnswerController class]] || [vc isKindOfClass:[YiTeachMicroController class]] || [vc isKindOfClass:[ChildrenResultViewController class]]) {

                            ((YjyxStuWrongListViewController *)vc).openMember = 1;
                            
//                            [self.navigationController popToViewController:vc animated:YES];
                           
                        }
                    }
                }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                     sender.userInteractionEnabled = YES;
                }
               
            }else{
                [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
                sender.userInteractionEnabled = YES;
            }
        }];
    }
    
}


-(void)chooseChildren:(id)sender//小孩试用
{
    UIButton *btn = (UIButton *)sender;
    ChildrenEntity *child = [trailChildAry objectAtIndex:btn.tag];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"trial",@"action",child.cid
                         ,@"cid",self.productEntity.productID,@"productid", nil];
    [[YjxService sharedInstance] trialProduct:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [self getChildrenStatus];//开通以后重新刷新界面
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    
                    if ([vc isKindOfClass:[YjyxStuWrongListViewController class]] || [vc isKindOfClass:[YjyxWorkDetailController class]] || [vc isKindOfClass:[YjyxThreeStageAnswerController class]] || [vc isKindOfClass:[YiTeachMicroController class]] || [vc isKindOfClass:[ChildrenResultViewController class]]) {
                        
                        ((YjyxStuWrongListViewController *)vc).openMember = 1;
  
                      
                    }
                }
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                trailBtn.userInteractionEnabled = YES;
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
            trailBtn.userInteractionEnabled = YES;
        }
    }];
    trailBtn.userInteractionEnabled = YES;
    [self dissmissChooseView:nil];
    
}

-(void)dissmissChooseView:(UITapGestureRecognizer *)gesture
{
    trailBtn.userInteractionEnabled = YES;
    [chooseView removeFromSuperview];
    chooseView = nil;
}

//开通，支付
- (IBAction)openClicked:(id)sender
{
    YjyxPayDetailViewController *vc =[[YjyxPayDetailViewController alloc] init];
    vc.productEntity = self.productEntity;
    vc.title = self.navigationItem.title;
    vc.jumpType = self.jumpType;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
}
#pragma mark - 学生端相关
// 获取学生状态
- (void)getStudentStatus
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"subjectstatus",@"action" ,self.productEntity.subject_id,@"subjectid", nil];
    [[YjxService sharedInstance] getStudentSubjectStatus:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            NSLog(@"%@", result);
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {

                [self reloadStudentView:result];//显示试用期的科目
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];


}
// 加载学生这科的状态
-(void)reloadStudentView:(NSDictionary *)dic
{
    
    for (UIView *view in _detailView.subviews) {
        if (view.tag>=1000) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *dataAry = [dic objectForKey:@"data"];
    
    for (int i = 0; i < [dataAry count]; i++) {
        NSDictionary *content = [dataAry objectAtIndex:i];
        NSInteger effctivedays = [[content objectForKey:@"effctivedays"] integerValue];
        OneStudentEntity *entity = [YjyxOverallData sharedInstance].studentInfo;
        UILabel *trailLb = [UILabel labelWithFrame:CGRectMake(35, (contentLb.frame.origin.y+contentLb.frame.size.height + 10)+i*25, SCREEN_WIDTH - 35, 20) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:15] context:@""];
        if ([[content objectForKey:@"purchasetype"] integerValue] == 2) {
            if ([[content objectForKey:@"status"] integerValue] ==2) {
                trailLb.text = [NSString stringWithFormat:@"%@:试用期已过期",entity.realname];
            }else{
                if(effctivedays == 0){
                     trailLb.text = [NSString stringWithFormat:@"%@:会员即将到期",entity.realname];
                }else{
                trailLb.text = [NSString stringWithFormat:@"%@:试用天数还剩%@天",entity.realname,[content objectForKey:@"effctivedays"]];
                }
            }
        }else{
            
            if ([[content objectForKey:@"status"] integerValue] ==2) {
                trailLb.text = [NSString stringWithFormat:@"%@:会员已过期",entity.realname];
                
            }else {
                if(effctivedays == 0)
                {
                    trailLb.text = [NSString stringWithFormat:@"%@:会员即将到期",entity.realname];
                    
                }else{
                    trailLb.text = [NSString stringWithFormat:@"%@:会员剩余%@天",entity.realname,[content objectForKey:@"effctivedays"]];
                }
            }
            
        }
        
//        openBtn.hidden =  [content[@"purchasetype"] integerValue] == 1 && [content[@"status"] integerValue] == 1 ? YES:NO;
        trailLb.tag = 1000+i;
        [_detailView addSubview:trailLb];
    }
    
    _detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (contentLb.frame.origin.y+contentLb.frame.size.height + 20)+dataAry.count*25);
    trailBtn.frame = CGRectMake(trailBtn.frame.origin.x, _detailView.frame.size.height+40, trailBtn.frame.size.width, trailBtn.frame.size.height);
    openBtn.frame = CGRectMake(openBtn.frame.origin.x, trailBtn.frame.origin.y + 45, openBtn.frame.size.width, openBtn.frame.size.height);
    trailBtn.hidden = dataAry.count == 0 ? NO:YES;
   
}





#pragma mark - 支付相关
-(void)selectChildren:(id)sender
{
    for (UIView *view in productView.subviews) {
        if (view.tag >= 100 && view.tag < 999) {
            UIButton *otherbtn = (UIButton *)view;
            [otherbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            otherbtn.layer.borderColor = [UIColor blackColor].CGColor;

        }
    }
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    
    ChildrenEntity *entity = [openChildAry objectAtIndex:(btn.tag-100)];
    childrenCid = [NSString stringWithFormat:@"%@",entity.cid];
    
    if (ppiIndex.length > 0&&childrenCid.length >0) {
        [self showPayView];
    }
}

-(void)selectTime:(id)sender
{
    for (UIView *view in productView.subviews) {
        if (view.tag >= 1000) {
            UIButton *otherbtn = (UIButton *)view;
            [otherbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            otherbtn.layer.borderColor = [UIColor blackColor].CGColor;
            
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    
    ppiIndex = [NSString stringWithFormat:@"%ld",btn.tag-1000];
    
    if (ppiIndex.length > 0&&childrenCid.length >0) {
        [self showPayView];
    }

}

- (void)getPayContent
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"purchase",@"action",childrenCid
                         ,@"cid",self.productEntity.productID,@"productid", ppiIndex,@"ppi",nil];
    [[YjxService sharedInstance] purchaseProduct:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                AlipayStr = [result objectForKey:@"params"];
                NSString *appScheme = @"yjyx";
                [[AlipaySDK defaultService] payOrder:AlipayStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    [self dealPayResult:resultDic];
                }];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];

}

-(void)showPayView
{
    [payView removeFromSuperview];
    payView = nil;
    payView = [[UIView alloc] initWithFrame:CGRectMake(0, productView.frame.origin.y + 110, SCREEN_WIDTH, 75)];
    payView.backgroundColor = [UIColor whiteColor];
    
    UILabel *priceLb = [UILabel labelWithFrame:CGRectMake(15, 0, 50, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13] context:@"支付:"];
    [payView addSubview:priceLb];
    
    NSDictionary *dic = [self.productEntity.price_pacakge objectAtIndex:[ppiIndex integerValue]];

    payPriceLb = [UILabel labelWithFrame:CGRectMake(65, 0, 200, 30) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:13] context:[NSString stringWithFormat:@"%@元",[dic objectForKey:@"price"]]];
    [payView addSubview:payPriceLb];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 31, SCREEN_WIDTH-15, 0.5)];
    lineImage.backgroundColor = RGBACOLOR(220, 220, 220, 1);
    [payView addSubview:lineImage];
    
    UILabel *payMethodLb = [UILabel labelWithFrame:CGRectMake(15, 30, 60, 45) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13] context:@"支付方式"];
    [payView addSubview:payMethodLb];
    
    UILabel *payMethodType = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH -80, 30, 60, 45) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:13] context:@"支付宝"];
    [payView addSubview:payMethodType];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15, 44, 7, 12)];
    arrowImage.image = [UIImage imageNamed:@"member_arrow.png"];
    [payView addSubview:arrowImage];
    
    [self.view addSubview:payView];
    
    
    payBtn.hidden = NO;
    payBtn.frame = CGRectMake(payBtn.frame.origin.x, payView.frame.origin.y + 95, payBtn.frame.size.width, payBtn.frame.size.height);
}

-(IBAction)payBtnClicked:(id)sender
{
    [self getPayContent];
    
}

-(void)dealPayResult:(NSDictionary *)dic
{
    NSString *resultString = [dic objectForKey:@"result"];
    NSString *tradeNo;
    NSArray *resultStringArray = [resultString componentsSeparatedByString:@"&"];
    for (NSString *str in resultStringArray) {
        NSString *newstring = nil;
        newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *ary = [newstring componentsSeparatedByString:@"="];
        if ([[ary objectAtIndex:0] isEqualToString:@"out_trade_no"]) {
            tradeNo = [ary objectAtIndex:1];
        }
        
    }
    
    if ([[dic objectForKey:@"resultStatus"] integerValue] == 9000) {
        UIView *paySuccessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        paySuccessView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
        view1.backgroundColor = [UIColor whiteColor];
        [paySuccessView addSubview:view1];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 65,33, 130, 80)];
        imageView.image = [UIImage imageNamed:@"member_paysuccess.png"];
        [view1 addSubview:imageView];
        
        UILabel *succesLb = [UILabel labelWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 20) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:20] context:@"恭喜您，购买成功!"];
        succesLb.textAlignment = NSTextAlignmentCenter;
        [view1 addSubview:succesLb];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 120)];
        view2.backgroundColor = [UIColor whiteColor];
        UILabel *lable1 = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:[NSString stringWithFormat:@"订单号:%@",tradeNo]];
        lable1.backgroundColor = [UIColor clearColor];
        [view2 addSubview:lable1];
        
        UILabel *label2 = [UILabel labelWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-15, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:[NSString stringWithFormat:@"会员类别:%@",self.productEntity.subject_name]];
        label2.backgroundColor = [UIColor clearColor];
        [view2 addSubview:label2];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *db = [[NSDateFormatter alloc] init];
        [db setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *s1 = [db stringFromDate:date];
        
        UILabel *label3 = [UILabel labelWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-15, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:[NSString stringWithFormat:@"付款时间:%@",s1]];
        label3.backgroundColor = [UIColor clearColor];
        [view2 addSubview:label3];
        
        UILabel *label4 = [UILabel labelWithFrame:CGRectMake(15, 90, SCREEN_WIDTH-15, 30) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@""];
        label4.backgroundColor = [UIColor clearColor];
        [view2 addSubview:label4];
        
        [paySuccessView addSubview:view2];
        
        [self.view addSubview:paySuccessView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshjurisdiction" object:nil];
        
    }else{
        [self.view makeToast:@"支付失败" duration:1.5 position:SHOW_CENTER complete:nil];

    }
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
