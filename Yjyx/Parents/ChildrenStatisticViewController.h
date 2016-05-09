//
//  ChildrenStatisticViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/18.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface ChildrenStatisticViewController : BaseViewController
{
    NSInteger type;//区分目前选中哪个模块
    //底部三个按钮
    IBOutlet UIButton *subjectBtn;
    IBOutlet UIButton *taskBtn;
    IBOutlet UIButton *billionBtn;
    
    IBOutlet UISegmentedControl *segmentedControl1;
    IBOutlet UISegmentedControl *segmentedControl2;
    IBOutlet UISegmentedControl *segmentedControl3;

    
    IBOutlet UIView *subjectView;//题目页面,题目相关数据
    ChildrenEntity *childrenEntity;//选中的小孩
    NSMutableArray *achievementAry;//单个小孩所有科目的数据
    NSDictionary *linechartDic;//单个小孩，单个科目的数据
    UILabel *detailLb;
    UILabel *subjectLb;
    UILabel *childrensubLb;
    PNPieChart *pieChart;
    PNLineChart *pieLineChart;
    UILabel *label1;//做题数目
    UILabel *label2;//正确率
    UILabel *label3;//日前
    
    IBOutlet UIView *taskView;//任务页面，任务相关数据
    NSMutableArray *taskDataAry;//任务数据
    PNPieChart *taskPieChart;//任务饼状图
    UILabel *taskSubjectlb;
    UILabel *taskhomeworkLb;
    UILabel *taskweikeLb;
    UILabel *childrentaskLb;

    
    
    IBOutlet UIView *billionView;//亿教课页面，亿教课相关数据
    PNPieChart *billionPieChart;//任务饼状图
    UILabel *childrenbillionLb;
    NSDictionary *billionDic;
    UILabel *billionCountLb;

}

@end
