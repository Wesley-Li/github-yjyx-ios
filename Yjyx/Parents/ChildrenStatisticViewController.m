//
//  ChildrenStatisticViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/18.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChildrenStatisticViewController.h"

@interface ChildrenStatisticViewController ()<PNChartDelegate>
{
    UIView *childrensubView;
    UIView *childrentaskView;
    UIView *childrenbillionView;

}

@end

@implementation ChildrenStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    subjectView.hidden = NO;
    taskView.hidden = YES;
    billionView.hidden = YES;
    
    type = 1;
    self.title = @"数据统计";
    [self loadBackBtn];
    if ([[[YjyxOverallData sharedInstance] parentInfo].childrens count] != 0) {
        childrenEntity = [[[YjyxOverallData sharedInstance] parentInfo].childrens objectAtIndex:0];
        achievementAry = [[NSMutableArray alloc] init];//单个小孩所有科目的数据
        taskDataAry = [[NSMutableArray alloc] init];
        [self getChildrenAchievement:childrenEntity.cid];
        [self initView];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
}

- (void)initView
{
    childrensubLb = [UILabel labelWithFrame:CGRectMake(15, 20, 80, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:childrenEntity.name];
    
    childrentaskLb = [UILabel labelWithFrame:CGRectMake(15, 20, 80, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:childrenEntity.name];
    
    childrenbillionLb = [UILabel labelWithFrame:CGRectMake(15, 20, 80, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:childrenEntity.name];
    
    [subjectView addSubview:childrensubLb];
    [taskView addSubview:childrentaskLb];
    [billionView addSubview:childrenbillionLb];
    
    
    subjectLb = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -200)/2, 95, 200, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:@""];
    subjectLb.textAlignment = NSTextAlignmentCenter;
    [subjectView addSubview:subjectLb];
    
    detailLb = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -200)/2, 115, 200, 15) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:10] context:@""];
    detailLb.textAlignment = NSTextAlignmentCenter;
    [subjectView addSubview:detailLb];
    
    
    label1 = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -200)/2, 245, 200, 10) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:10] context:@""];
    label1.textAlignment = NSTextAlignmentCenter;
    [subjectView addSubview:label1];
    
    label2 = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -200)/2, 260, 200, 10) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:10] context:@""];
    label2.textAlignment = NSTextAlignmentCenter;
    [subjectView addSubview:label2];
    
    label3 = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -200)/2, 230, 200, 10) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:10] context:@""];
    label3.textAlignment = NSTextAlignmentCenter;
    [subjectView addSubview:label3];
    
    taskSubjectlb = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, 145, 250, 10) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] context:@""];
    taskSubjectlb.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:taskSubjectlb];
    
    taskhomeworkLb = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, 175, 250, 10) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:11] context:@""];
    taskhomeworkLb.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:taskhomeworkLb];
    
    taskweikeLb = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, 200, 250, 10) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:11] context:@""];
    taskweikeLb.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:taskweikeLb];
    
//    UILabel *weekLb =  [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, 20, 250, 10) textColor:RGBACOLOR(230, 152, 66, 1) font:[UIFont systemFontOfSize:12] context:@"本周"];
//    weekLb.textAlignment = NSTextAlignmentCenter;
//    [billionView addSubview:weekLb];
    
    UILabel *billionTitle =  [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, 160, 250, 10) textColor:RGBACOLOR(230, 152, 66, 1) font:[UIFont systemFontOfSize:14] context:@"学习亿教课数"];
    billionTitle.textAlignment = NSTextAlignmentCenter;
    [billionView addSubview:billionTitle];
    
    billionCountLb = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, 188, 250, 10) textColor:RGBACOLOR(230, 152, 66, 1) font:[UIFont systemFontOfSize:11] context:@""];
    billionCountLb.textAlignment = NSTextAlignmentCenter;
    [billionView addSubview:billionCountLb];

    
}

-(void)getChildrenAchievement:(NSString *)cid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"question",@"action",cid,@"cid",@"20",@"count",nil];
    [[YjxService sharedInstance] getChildrenachievement:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                achievementAry = [result objectForKey:@"data"];
                if ([achievementAry count] == 0) {
                    [self.view makeToast:@"该小孩暂无相关数据" duration:1.0 position:SHOW_CENTER complete:nil];
                }
                [self setPNChat];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

//题目绘制饼状图
-(void)setPNChat
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *colorAry = [NSArray arrayWithObjects:RGBACOLOR(239, 200, 47, 1),RGBACOLOR(84, 148, 194, 1),RGBACOLOR(136, 216, 193, 1),RGBACOLOR(225, 103, 102, 1), nil];
    for (int i = 0; i<[achievementAry count]; i++) {
        NSDictionary *dic = [achievementAry objectAtIndex:i];
        CGFloat value = [[[dic objectForKey:@"total"] objectForKey:@"ratio"] floatValue];
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value color:[colorAry objectAtIndex:i%4] description:[NSString stringWithFormat:@"%.0f%%%@",value*100,[dic objectForKey:@"course"]]];
        [items addObject:item];
    }
    [pieChart removeFromSuperview];
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 15, 200.0, 200.0) items:items];
    pieChart.descriptionTextColor = [UIColor blackColor];
    pieChart.descriptionTextFont  = [UIFont boldSystemFontOfSize:13];
    pieChart.hideValues = YES;
    pieChart.delegate = self;
    [pieChart strokeChart];
    [subjectView addSubview:pieChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -PNPieChartDelegate
//折线图代理
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex
{
    
}

- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex
{
    NSString *questioncorrect = [[[linechartDic objectForKey:@"items"] objectAtIndex:pointIndex] objectForKey:@"correct"];
    NSString *questionwrong = [[[linechartDic objectForKey:@"items"] objectAtIndex:pointIndex] objectForKey:@"wrong"];
    NSString *dataStr = [[[linechartDic objectForKey:@"items"] objectAtIndex:pointIndex] objectForKey:@"date"];
    label1.text = [NSString stringWithFormat:@"正确%@,错误%@",questioncorrect,questionwrong];
    label2.text = [NSString stringWithFormat:@"正确率%.2f",[[[[linechartDic objectForKey:@"items"] objectAtIndex:pointIndex] objectForKey:@"ratio"] floatValue]* 100];
    label3.text = [NSString stringWithFormat:@"%@",dataStr];

}

//饼状图代理


-(void)userClickedOnPieIndexItem:(NSInteger)pieIndex
{
    if (type == 1) {
        label1.text = @"";
        label2.text = @"";
        label3.text = @"";
        linechartDic = [achievementAry objectAtIndex:pieIndex];
        NSString *questioncorrect = [[linechartDic objectForKey:@"total"] objectForKey:@"questioncorrect"];
        NSString *questionwrong = [[linechartDic objectForKey:@"total"] objectForKey:@"questionwrong"];
        subjectLb.text = [linechartDic objectForKey:@"course"];
        detailLb.text = [NSString stringWithFormat:@"正确%@,错误%@",questioncorrect,questionwrong];
        
        [pieLineChart removeFromSuperview];
        pieLineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, SCREEN_HEIGHT-64-320)];
        pieLineChart.backgroundColor = [UIColor clearColor];
        pieLineChart.showCoordinateAxis =YES;
        pieLineChart.yFixedValueMax = 100;
        pieLineChart.yFixedValueMin = 0;
        pieLineChart.yLabelFont = [UIFont systemFontOfSize:8];
        pieLineChart.yLabelFormat = @"%1.1f";

        [pieLineChart setYLabels:@[@"0",@"20%",@"40%",@"60%",@"80%",@"100%"]];
        pieLineChart.delegate = self;
        NSMutableArray *valueAry = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[linechartDic objectForKey:@"items"] count]; i++) {
            float value = [[[[linechartDic objectForKey:@"items"] objectAtIndex:i] objectForKey:@"ratio"] floatValue]*100;
            [valueAry addObject:[NSNumber numberWithFloat:value]];
        }
        
        NSMutableArray *xLabelAry = [[NSMutableArray alloc] init];
        for (int i = 0; i< [valueAry count]; i++) {
            [xLabelAry addObject:@""];
        }
        [pieLineChart setXLabels:xLabelAry];

        
        PNLineChartData *data = [PNLineChartData new];
        data.color = RGBACOLOR(225, 102, 103, 1);
        data.itemCount = valueAry.count;
        data.alpha = 1;
        data.inflexionPointStyle = PNLineChartPointStyleCircle;
        data.getData = ^(NSUInteger index){
            CGFloat yValue = [valueAry[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        pieLineChart.chartData = @[data];
        [pieLineChart strokeChart];
        [subjectView addSubview:pieLineChart];

    }else if (type == 2)
    {
        taskSubjectlb.text = @"";
        taskhomeworkLb.text = @"";
        taskweikeLb.text = @"";
        NSDictionary *taskDic = [taskDataAry objectAtIndex:pieIndex];
        taskSubjectlb.text = [taskDic objectForKey:@"course"];
        taskhomeworkLb.text  = [NSString stringWithFormat:@"作业数:%ld",[[[taskDic objectForKey:@"total"] objectForKey:@"homework"] integerValue]];
        taskweikeLb.text = [NSString stringWithFormat:@"微课数:%ld",[[[taskDic objectForKey:@"total"] objectForKey:@"lesson"] integerValue]];
        

        
        
    }else{
        
    }
    
}

-(IBAction)selectChildren:(id)sender //切换不同小孩
{
    if (type == 1) {
        if (childrensubView&&childrensubView.hidden == NO) {
            childrensubView.hidden = YES;
            return;
        }
        
        NSInteger height = [YjyxOverallData sharedInstance].parentInfo.childrens.count*40;
        if (childrensubView == nil) {
            childrensubView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-54, SCREEN_HEIGHT-38-64-31-height, 54, height)];
        }
        childrensubView.hidden = NO;
        childrensubView.userInteractionEnabled = YES;
        for (int i=0; i<[YjyxOverallData sharedInstance].parentInfo.childrens.count; i++) {
            ChildrenEntity *entity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*40, 54, 39)];
            [btn setTitle:entity.name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = [UIColor blueColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(chooseChildren:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5+i*40, 54, 0.5)];
            line.backgroundColor = RGBACOLOR(240, 240, 240, 1);
            [childrensubView addSubview:btn];
            [childrensubView addSubview:line];
        }
        [subjectView addSubview:childrensubView];
    }else if (type == 2){
        if (childrentaskView&&childrentaskView.hidden == NO) {
            childrentaskView.hidden = YES;
            return;
        }
        
        NSInteger height = [YjyxOverallData sharedInstance].parentInfo.childrens.count*40;
        if (childrentaskView == nil) {
            childrentaskView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-54, SCREEN_HEIGHT-38-64-31-height, 54, height)];
        }
        childrentaskView.hidden = NO;
        childrentaskView.userInteractionEnabled = YES;
        for (int i=0; i<[YjyxOverallData sharedInstance].parentInfo.childrens.count; i++) {
            ChildrenEntity *entity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*40, 54, 39)];
            [btn setTitle:entity.name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = [UIColor blueColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(chooseChildren:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5+i*40, 54, 0.5)];
            line.backgroundColor = RGBACOLOR(240, 240, 240, 1);
            [childrentaskView addSubview:btn];
            [childrentaskView addSubview:line];
        }
        [taskView addSubview:childrentaskView];
    }
    else{
        if (childrenbillionView&&childrenbillionView.hidden == NO) {
            childrenbillionView.hidden = YES;
            return;
        }
        
        NSInteger height = [YjyxOverallData sharedInstance].parentInfo.childrens.count*40;
        if (childrenbillionView == nil) {
            childrenbillionView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-54, SCREEN_HEIGHT-38-64-31-height, 54, height)];
        }
        childrenbillionView.hidden = NO;
        childrenbillionView.userInteractionEnabled = YES;
        for (int i=0; i<[YjyxOverallData sharedInstance].parentInfo.childrens.count; i++) {
            ChildrenEntity *entity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*40, 54, 39)];
            [btn setTitle:entity.name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = [UIColor blueColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(chooseChildren:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5+i*40, 54, 0.5)];
            line.backgroundColor = RGBACOLOR(240, 240, 240, 1);
            [childrenbillionView addSubview:btn];
            [childrenbillionView addSubview:line];
        }
        [billionView addSubview:childrenbillionView];
    }
   
}

-(void)chooseChildren:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    childrenEntity = [[[YjyxOverallData sharedInstance] parentInfo].childrens objectAtIndex:btn.tag];
    switch (type) {
        case 1:
            [pieLineChart removeFromSuperview];
            childrensubView.hidden = YES;
            detailLb.text = @"";
            subjectLb.text = @"";
            label1.text = @"";
            label2.text = @"";
            label3.text = @"";
            childrensubLb.text = childrenEntity.name;
            [self getChildrenAchievement:childrenEntity.cid];
            break;
        case 2:
            childrentaskView.hidden = YES;
            taskweikeLb.text = @"";
            taskSubjectlb.text = @"";
            taskhomeworkLb.text = @"";
            childrentaskLb.text = childrenEntity.name;
            [self getchildrenTaskWithCid:childrenEntity.cid];
            break;
        case 3:
            childrenbillionView.hidden = YES;
            billionCountLb.text = @"";
            childrenbillionLb.text = childrenEntity.name;
            [self getchildrenbillionWithCid:childrenEntity.cid];
            break;
        default:
            break;
    }
}


//任务
-(void)getchildrenTaskWithCid:(NSString *)cid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"task",@"action",cid,@"cid",@"20",@"count",nil];
    [[YjxService sharedInstance] getChildrenachievement:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                taskDataAry = [result objectForKey:@"data"];
                if ([taskDataAry count] == 0) {
                    [self.view makeToast:@"该小孩暂无相关数据" duration:1.0 position:SHOW_CENTER complete:nil];
                }
                [self setTaskPNChat];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

-(void)setTaskPNChat
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *colorAry = [NSArray arrayWithObjects:RGBACOLOR(218, 0, 0, 1),RGBACOLOR(159, 139, 252, 1),RGBACOLOR(243, 209, 143, 1),RGBACOLOR(173, 234, 254, 1), nil];
    for (int i = 0; i<[taskDataAry count]; i++) {
        NSDictionary *dic = [taskDataAry objectAtIndex:i];
        
        CGFloat value = [[[dic objectForKey:@"total"] objectForKey:@"ratio"] floatValue];
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value color:[colorAry objectAtIndex:i%4] description:[NSString stringWithFormat:@"%.0f%%%@",value*100,[dic objectForKey:@"course"]]];
        [items addObject:item];
    }
    [taskPieChart removeFromSuperview];
    taskPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 250)/2, 60, 250.0, 250.0) items:items];
    taskPieChart.descriptionTextColor = [UIColor whiteColor];
    taskPieChart.descriptionTextFont  = [UIFont boldSystemFontOfSize:13];
    taskPieChart.hideValues = YES;
    taskPieChart.delegate = self;
    [taskPieChart strokeChart];
    [taskView addSubview:taskPieChart];
}

//亿教课
-(void)getchildrenbillionWithCid:(NSString *)cid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"yjlesson",@"action",cid,@"cid",@"20",@"count",nil];
    [[YjxService sharedInstance] getChildrenachievement:dic withBlock:^(id result, NSError *error){
        [self.view hideToastActivity];
        if (result) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                billionDic = result;
                [self setBillionPNChat];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

-(void)setBillionPNChat
{
    billionCountLb.text = [NSString stringWithFormat:@"%@",[billionDic objectForKey:@"data"]];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *colorAry = [NSArray arrayWithObjects:RGBACOLOR(230, 152, 66, 1), nil];
    PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:1 color:[colorAry objectAtIndex:0] description:@""];
    [items addObject:item];
    [billionPieChart removeFromSuperview];
    billionPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 250)/2, 60, 250.0, 250.0) items:items];
    billionPieChart.descriptionTextColor = [UIColor whiteColor];
    billionPieChart.descriptionTextFont  = [UIFont boldSystemFontOfSize:15];
    billionPieChart.hideValues = YES;
    billionPieChart.delegate = self;
    [billionPieChart strokeChart];
    [billionView addSubview:billionPieChart];
}



#pragma mark -MyEvent
-(IBAction)switchView:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
            type = 1;
            [self getChildrenAchievement:childrenEntity.cid];
            subjectView.hidden = NO;
            taskView.hidden = YES;
            billionView.hidden = YES;
            [subjectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [taskBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [billionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 2:
            type = 2;
            [self getchildrenTaskWithCid:childrenEntity.cid];
            subjectView.hidden = YES;
            taskView.hidden = NO;
            billionView.hidden = YES;
            [subjectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [taskBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [billionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 3:
            type = 3;
            [self getchildrenbillionWithCid:childrenEntity.cid];
            subjectView.hidden = YES;
            taskView.hidden = YES;
            billionView.hidden = NO;
            [subjectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [taskBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [billionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        default:
            break;
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
