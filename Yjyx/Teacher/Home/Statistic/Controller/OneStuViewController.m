//
//  OneStuViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OneStuViewController.h"
#import "GetTaskViewController.h"
#import "PNChart.h"

@interface OneStuViewController ()<PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *finishView;
@property (weak, nonatomic) IBOutlet UIView *unfinishView;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *unfinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionFinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionWrongLabel;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) NSMutableArray *lineArr;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *corectNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;





@end

@implementation OneStuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lineArr = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self readDataFromNet];
    
    self.questionRightLabel.textColor = RGBACOLOR(100, 174, 99, 1);
    self.questionWrongLabel.textColor = [UIColor redColor];
    
    // 点击手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getFinishedTask:)];
    [self.finishView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getUnfinishedTask:)];
    [self.unfinishView addGestureRecognizer:tap2];
    
    
    
}

- (void)readDataFromNet {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"m_get_student_task_question_ratio", @"action", self.stuID, @"suid", nil];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_STATISTIC_GET] parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            // 任务和题目数据的显示
            NSDictionary *dic = responseObject[@"taskandquestioncount"];
            self.finishLabel.text = [NSString stringWithFormat:@"%@", dic[@"tasks_num"]];
            self.unfinishLabel.text = [NSString stringWithFormat:@"%ld", [dic[@"recv_num"] integerValue] - [dic[@"tasks_num"] integerValue]];
            self.questionFinishLabel.text = [NSString stringWithFormat:@"%@", dic[@"questiontotal"]];
            self.questionRightLabel.text = [NSString stringWithFormat:@"%@", dic[@"questioncorrect"]];
            self.questionWrongLabel.text = [NSString stringWithFormat:@"%@", dic[@"questionwrong"]];
            
            // 折线图显示
            self.lineArr = responseObject[@"chartdata"];
            [self configureTheLineChartWithArray:_lineArr];
            
        }else {
        
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.view makeToast:[NSString stringWithFormat:@"数据请求失败, 请检查您的网络"] duration:1.0 position:SHOW_CENTER complete:nil];
        
    }];

    
}

- (void)configureTheLineChartWithArray:(NSArray *)array {
    
    NSInteger num;
    num = ceil(array.count/30.0);// 每页显示30个点
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *num, self.bgScrollView.frame.size.height);

    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 10, self.bgScrollView.contentSize.width, self.bgScrollView.height - 20)];
    _lineChart.delegate = self;
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.showCoordinateAxis =YES;
    _lineChart.yFixedValueMax = 100;
    _lineChart.yFixedValueMin = 0;
    _lineChart.yLabelFont = [UIFont systemFontOfSize:8];
    _lineChart.yLabelFormat = @"%1.1f";
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        [arr addObject:[NSString stringWithFormat:@""]];
    }
    [_lineChart setXLabels:arr];
    
    [_lineChart setYLabels:@[@"0", @"20%", @"40%", @"60%", @"80%", @"100%"]];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSDictionary *dict = [dic[@"summary"] JSONValue];
        NSNumber *num = [NSNumber numberWithFloat:[dict[@"correct"] floatValue] * 100 / ([dict[@"correct"] floatValue] + [dict[@"wrong"] floatValue])];
        [dataArr addObject:num];
    }
    
    PNLineChartData *data = [PNLineChartData new];
    data.color = RGBACOLOR(22, 156, 111, 1);
    data.itemCount = dataArr.count;
    data.alpha = 1;
    data.inflexionPointStyle = PNLineChartPointStyleCircle;
    data.getData = ^(NSUInteger index){
        CGFloat yValue = [dataArr[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    _lineChart.chartData = @[data];
    [_lineChart strokeChart];
    [self.bgScrollView addSubview:_lineChart];

    
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex {

}


- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex
{
    NSString *title = [[_lineArr objectAtIndex:pointIndex] objectForKey:@"task__description"];
    
    NSNumber *questionRight = [[[[_lineArr objectAtIndex:pointIndex] objectForKey:@"summary"] JSONValue] objectForKey:@"correct"];
    
    NSNumber *questionwrong = [[[[_lineArr objectAtIndex:pointIndex] objectForKey:@"summary"] JSONValue] objectForKey:@"wrong"];
    
    NSString *rate = [NSString stringWithFormat:@"正确率: %.f%%", [questionRight floatValue]*100/([questionRight floatValue] + [questionwrong floatValue])];
    
    self.titleLabel.text = title;
    self.corectNumLabel.text = [NSString stringWithFormat:@"正确:%@   ", questionRight];
    self.corectNumLabel.textColor = RGBACOLOR(100, 174, 99, 1);
    self.wrongNumLabel.text = [NSString stringWithFormat:@"   错误:%@", questionwrong];
    self.rateLabel.text = rate;
    
    
}


- (void)getFinishedTask:(UITapGestureRecognizer *)sender {

    GetTaskViewController *getVC = [[GetTaskViewController alloc] init];
    getVC.navigationItem.title = self.navigationItem.title;
    getVC.tip = 0;
    getVC.stuID = self.stuID;
    [self.navigationController pushViewController:getVC animated:YES];
    
}


- (void)getUnfinishedTask:(UITapGestureRecognizer *)sender {

    GetTaskViewController *getVC = [[GetTaskViewController alloc] init];
    getVC.navigationItem.title = self.navigationItem.title;
    getVC.tip = 1;
    getVC.stuID = self.stuID;
    [self.navigationController pushViewController:getVC animated:YES];
    
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
