//
//  YjyxPayDetailViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/5/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxPayDetailViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YjyxStuWrongListViewController.h"
#import "YjyxWorkDetailController.h"
#import "YjyxThreeStageAnswerController.h"
#import "YiTeachMicroController.h"
@interface YjyxPayDetailViewController ()
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

@implementation YjyxPayDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    
    openChildAry = [[NSMutableArray alloc] init];
    for (ChildrenEntity *entity in [YjyxOverallData sharedInstance].parentInfo.childrens){
        [openChildAry addObject:entity];//可以开通的小孩数组，默认小孩都可以再次开通
    }
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView
{
    titleLb.text = [NSString stringWithFormat:@"%@会员特权",self.productEntity.subject_name];
    NSString *content = [self.productEntity.content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    // 此处rclabel也不受影响,暂时不改
    contentLb = [[RCLabel alloc] initWithFrame:CGRectMake(35, 46, SCREEN_WIDTH - 50, 999)];
    contentLb.userInteractionEnabled = NO;
    contentLb.font = [UIFont systemFontOfSize:12];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    contentLb.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [contentLb optimumSize];
    contentLb.frame = CGRectMake(35, 46, optimalSize.width, optimalSize.height);
    [self.view addSubview:contentLb];
    
    _detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (contentLb.frame.origin.y+contentLb.frame.size.height + 20));
    
    // 会员种类
    productView = [[UIView alloc] initWithFrame:CGRectMake(0, _detailView.frame.size.height + 8, SCREEN_WIDTH, 90)];
    if(_jumpType == 1){
        productView.height = 80;
    }
    productView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:productView];
    UILabel *typeLb = [UILabel labelWithFrame:CGRectMake(35, 10, SCREEN_WIDTH-35, 20) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12] context:[NSString stringWithFormat:@"会员种类：%@",_productEntity.subject_name]];
    [productView addSubview:typeLb];
    
    if(_jumpType == 0){
    UILabel *childrenLb = [UILabel labelWithFrame:CGRectMake(35, 35, 60, 20) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12] context:@"小孩:"];
    [productView addSubview:childrenLb];
    
    
    for (int i =0 ; i<[openChildAry count]; i++) {
        ChildrenEntity *entity = [openChildAry objectAtIndex:i];
        UIButton *childrenBtn = [[UIButton alloc] initWithFrame:CGRectMake(68+i*50, 38, 43, 15)];
        [childrenBtn setTitle:entity.name forState:UIControlStateNormal];
        [childrenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        childrenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        childrenBtn.layer.borderWidth = 0.5;
        childrenBtn.layer.cornerRadius = 2;
        CGRect childBtnTitle = [childrenBtn.titleLabel.text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        CGRect rect = childrenBtn.frame;
        rect.size.width = childBtnTitle.size.width + 5;
        childrenBtn.frame = rect;
        [childrenBtn addTarget:self action:@selector(selectChildren:) forControlEvents:UIControlEventTouchUpInside];
        childrenBtn.tag = 100+i;
        [productView addSubview:childrenBtn];
        if (i == 0) {
            [self selectChildren:childrenBtn];
        }
    }
    }
    
    UILabel *timeLb = [UILabel labelWithFrame:CGRectMake(35, 60, 80, 20) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12] context:@"时间选择:"];
    if(_jumpType == 1){
        timeLb.y = 38;
    }
    [productView addSubview:timeLb];
    
    for (int i = 0; i < [self.productEntity.price_pacakge count]; i++) {
        NSDictionary *dic = [self.productEntity.price_pacakge objectAtIndex:i];
        
        UIButton *timeBtn = [[UIButton alloc] init];
      
//        timeBtn.frame = CGRectMake(90+i*82, 63, 80, 15);
        NSLog(@"%f", CGRectGetMaxX(timeBtn.frame));
        NSString *str = [NSString stringWithFormat:@"%@元/%@天",[dic objectForKey:@"price"],[dic objectForKey:@"days"]];
        [timeBtn setTitle:str forState:UIControlStateNormal];
        [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        timeBtn.layer.borderWidth = 0.5;
        timeBtn.layer.cornerRadius = 2;
        [timeBtn sizeToFit];
        if(_jumpType == 0){
        timeBtn.frame = CGRectMake(90+i*82, 63, 80, 15);
        }else{
            timeBtn.x = 90 + i*82;
            timeBtn.y = 41;
            timeBtn.height = 15;
            timeBtn.width = timeBtn.width + 2;
        }
        NSLog(@"%@", NSStringFromCGRect(timeBtn.frame));
        [timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        timeBtn.tag = 1000+i;
        [productView addSubview:timeBtn];
        if (i == 0) {
            [self selectTime:timeBtn];
        }
    }
    if(_jumpType == 1){
        [self showPayView];
    }

}


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
    if(_jumpType == 0){
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"purchase",@"action",childrenCid
                         ,@"cid",self.productEntity.productID,@"productid", ppiIndex,@"ppi",nil];
    [[YjxService sharedInstance] purchaseProduct:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                AlipayStr = [result objectForKey:@"params"];
                NSString *appScheme = @"yjyx";
                [[AlipaySDK defaultService] payOrder:AlipayStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    [self dealPayResult:resultDic resultstr:AlipayStr];
                }];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    }else{ // 学生端
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"purchase",@"action", self.productEntity.productID,@"productid", ppiIndex,@"ppi",nil];
        [[YjxService sharedInstance] purchaseStudentProduct:dic withBlock:^(id result, NSError *error){
            [self.view hideToastActivity];
            if (result != nil) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    AlipayStr = [result objectForKey:@"params"];
                    NSString *appScheme = @"yjyx";
                    [[AlipaySDK defaultService] payOrder:AlipayStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        [self dealPayResult:resultDic resultstr:AlipayStr];
                    }];
                }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }else{
                [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }];
    }
    
}

-(void)showPayView
{
    [payView removeFromSuperview];
    payView = nil;
    payView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(productView.frame) + 10, SCREEN_WIDTH, 75)];
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

-(void)dealPayResult:(NSDictionary *)dic resultstr:(NSString*)resultstr
{
    NSString *resultString = resultstr;
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[YjyxStuWrongListViewController class]] || [vc isKindOfClass:[YjyxWorkDetailController class]] || [vc isKindOfClass:[YjyxThreeStageAnswerController class]] || [vc isKindOfClass:[YiTeachMicroController class]]) {
                    ((YjyxStuWrongListViewController *)vc).openMember = 1;
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        });
        
    }else{
        [self.view makeToast:@"支付失败" duration:1.5 position:SHOW_CENTER complete:nil];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
