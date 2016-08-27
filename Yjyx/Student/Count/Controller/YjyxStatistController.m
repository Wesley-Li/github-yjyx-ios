//
//  YjyxStatistController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStatistController.h"
#import "YjyxStatisticModel.h"
#import "iCarousel.h"
#import "UIImageView+WebCache.h"
#import "PNChart.h"

@interface YjyxStatistController ()<iCarouselDataSource, iCarouselDelegate, PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *cycleBgview;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UILabel *finishTaskNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishQuestionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctQuestionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongQuestionNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *lineChartScrollview;


@property (nonatomic, strong) NSMutableArray *dataSource;// 学科数据源
@property (nonatomic, strong) NSMutableArray *lineChartDataSource;// 折线图数据源



@end

@implementation YjyxStatistController

- (NSMutableArray *)dataSource {

    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)lineChartDataSource {

    if (!_lineChartDataSource) {
        self.lineChartDataSource = [NSMutableArray array];
    }
    return _lineChartDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"统计";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = COMMONCOLOR;
    self.lineImageView.backgroundColor = COMMONCOLOR;
    
    [self getDataFromNet];
    
    
}

- (void)getDataFromNet {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"m_get_student_task_and_question_count", @"action", nil];
    [manager GET:[BaseURL stringByAppendingString:STUDENT_GET_WRONG_LIST_GET] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                YjyxStatisticModel *model = [[YjyxStatisticModel alloc] init];
                [model initModelWithDic:dic];
                [self.dataSource addObject:model];
                
            }
            
            [self configureICarousel];
            
            
            if (self.dataSource.count != 0) {
                
                // 初次赋值
                YjyxStatisticModel *model = self.dataSource[0];
                
                // 赋值总数据信息
                self.finishTaskNumLabel.text = [NSString stringWithFormat:@"%@", model.tasks_num];
                self.finishQuestionNumLabel.text = [NSString stringWithFormat:@"%@", model.questiontotal == nil ? @0 : model.questiontotal];
                self.correctQuestionNumLabel.text = [NSString stringWithFormat:@"%@", model.questioncorrect == nil ? @0 : model.questioncorrect];
                self.wrongQuestionNumLabel.text = [NSString stringWithFormat:@"%@", model.questionwrong == nil ? @0 : model.questionwrong];
                
                // 赋值折线图信息
                [self getPNLineChartDataWithSubjectid:model.subjectid];
                
                
            }
            
            
        }else {
            
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"数据请求失败,请检查您的网络" duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}


// 配置iCarousel
- (void)configureICarousel {

    iCarousel *iview = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.cycleBgview.width, self.cycleBgview.height - 1)];
    iview.delegate = self;
    iview.dataSource = self;
    if (self.dataSource.count < 3) {
        iview.type = iCarouselTypeCoverFlow;
    }else {
    
        iview.type = iCarouselTypeRotary;
    }
    
    
    [self.cycleBgview addSubview:iview];
    
}

#pragma mark - iCarousel datasource and delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {

    return self.dataSource.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    if (view == nil) {
        CGFloat height = self.cycleBgview.height - 20;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height*170/224, height)];
        YjyxStatisticModel *model = self.dataSource[index];
        [(UIImageView *)view setImageWithURL:[NSURL URLWithString:model.yj_member]];
    }
    
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

    YjyxStatisticModel *model = self.dataSource[index];
    
    NSLog(@"--------%@", model.subjectid);
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    if (self.dataSource.count != 0) {
        
        YjyxStatisticModel *model = self.dataSource[carousel.currentItemIndex];
        
        // 赋值总数据信息
        self.finishTaskNumLabel.text = [NSString stringWithFormat:@"%@", model.tasks_num];
        self.finishQuestionNumLabel.text = [NSString stringWithFormat:@"%@", model.questiontotal];
        self.correctQuestionNumLabel.text = [NSString stringWithFormat:@"%@", model.questioncorrect];
        self.wrongQuestionNumLabel.text = [NSString stringWithFormat:@"%@", model.questionwrong];
        
        // 赋值折线图信息
        [self getPNLineChartDataWithSubjectid:model.subjectid];
 
    }
    

}

#pragma mark - 折线图数据请求
- (void)getPNLineChartDataWithSubjectid:(NSNumber *)subjectid {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"list_my_latest_finished_tasks", @"action", subjectid, @"subjectid", nil];
    [manager GET:[BaseURL stringByAppendingString:STUDENT_LINECHART_GET] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            self.lineChartDataSource = responseObject[@"retlist"];
            // 配置折线图
            [self configurePNLineChartWithArray:self.lineChartDataSource];
            
        }else {
            
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"数据请求失败,请检查您的网络" duration:1.0 position:SHOW_CENTER complete:nil];
    }];

    
    
}


#pragma mark - 配置折线图及赋值
- (void)configurePNLineChartWithArray:(NSArray *)array {

    for (UIView *view in [self.lineChartScrollview subviews]) {
        [view removeFromSuperview];
    }
    NSInteger num;
    num = ceil(array.count / 30.0);
    self.lineChartScrollview.contentSize = CGSizeMake(num * SCREEN_WIDTH, self.lineChartScrollview.height);
    
    self.titleLabel.text = @"";
    self.rightLabel.text = @"";
    self.wrongLabel.text = @"";
    self.rateLabel.text = @"";
    
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, self.lineChartScrollview.contentSize.width , self.lineChartScrollview.height)];
    lineChart.delegate = self;
    lineChart.backgroundColor = [UIColor clearColor];
    lineChart.showCoordinateAxis =YES;
    lineChart.yFixedValueMax = 100;
    lineChart.yFixedValueMin = 0;
    lineChart.yLabelFont = [UIFont systemFontOfSize:8];
    lineChart.yLabelFormat = @"%1.1f";
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        [arr addObject:[NSString stringWithFormat:@""]];
    }
    [lineChart setXLabels:arr];
    
    [lineChart setYLabels:@[@"0", @"20%", @"40%", @"60%", @"80%", @"100%"]];
    
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
    lineChart.chartData = @[data];
    [lineChart strokeChart];
    [self.lineChartScrollview addSubview:lineChart];
    

    
}



- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex {
    
}


- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex
{
    NSString *title = [[_lineChartDataSource objectAtIndex:pointIndex] objectForKey:@"task__description"];
    
    NSNumber *questionRight = [[[[_lineChartDataSource objectAtIndex:pointIndex] objectForKey:@"summary"] JSONValue] objectForKey:@"correct"];
    
    NSNumber *questionwrong = [[[[_lineChartDataSource objectAtIndex:pointIndex] objectForKey:@"summary"] JSONValue] objectForKey:@"wrong"];
    
    NSString *rate = [NSString stringWithFormat:@"正确率: %.f%%", [questionRight floatValue]*100/([questionRight floatValue] + [questionwrong floatValue])];
    
    self.titleLabel.text = title;
    self.rightLabel.text = [NSString stringWithFormat:@"正确:%@   ", questionRight];
    self.rightLabel.textColor = RGBACOLOR(100, 174, 99, 1);
    self.wrongLabel.text = [NSString stringWithFormat:@"   错误:%@", questionwrong];
    self.rateLabel.text = rate;
    
    
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
