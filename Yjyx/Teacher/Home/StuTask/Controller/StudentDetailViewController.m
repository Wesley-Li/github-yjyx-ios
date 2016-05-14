//
//  StudentDetailViewController.m
//  Yjyx
//
//  Created by peng on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StudentDetailViewController.h"



#import "studentDetail.h"
#import "FinshedModel.h"


@interface StudentDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ) NSInteger answerCellHeight;



@end

@implementation StudentDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:24/255.0 green:138/255.0 blue:224/255.0 alpha:1.0]];
    self.navigationItem.title = @"卷子";
    
   
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64-49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:244/ 255.0 alpha:1.0];
    
    [self readDataFromNetWork];
    
    
}



- (void)readDataFromNetWork {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettasksubmitdetail", @"action",self.taskID,@"taskid",self.finshedModel.studentID, @"suid",  nil];
    NSLog(@"%@=======",dic);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:T_SESSIONID forHTTPHeaderField:@"sessionid"];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_DETAIL_ACTION_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@-----",responseObject);
        
        
    }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return _answerCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    } else {
        return 0.01;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier1 = @"studentDetailCell1";
    static NSString *identifier2 = @"studentDetailCell2";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用时";
            }else{
           cell.textLabel.text = @"提交时间";
           }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 12, 90, 20)];
        label.textAlignment = NSTextAlignmentRight;
        
        //TODO:时间 后台取值
        if (indexPath.row == 0) {
            label.text = @"五分";
        } else {
            label.text = @"4-26分";
        }
         UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 1)];
          line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:label];
//        [cell.contentView addSubview:label];
        
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 25)];
        label.text = @"答题卡";
        label.font = [UIFont systemFontOfSize:20];

        label.textColor =[UIColor colorWithRed:94/255.0 green:174/255.0 blue:211/255.0 alpha:1.0];

        [cell.contentView addSubview:label];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];

        [self cellAddSubview:cell addSubViewsWithChoiceArr:nil];

        return cell;
    }
    return nil;

}

- (void)cellAddSubview:(UITableViewCell *)cell addSubViewsWithChoiceArr:(NSMutableArray *)arr {

    CGSize size = CGSizeMake(30, 50);// 初始位置
    CGFloat padding = 20;// 间距
    
    CGFloat TWidth = 50;// 宽度
    CGFloat Theight = 120;// 高度
    
    //    NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < 8; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, TWidth, Theight);
        
        size.width += TWidth + padding;
        
        if (cell.frame.size.width- size.width < TWidth + padding) {
            // 换行
            size.width = 30;
            size.height += Theight;
        }
        
        //        taskView.backgroundColor = [UIColor redColor];
//        ChoiceModel *model = self.choiceDataSource[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TWidth, 20)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, TWidth, 20)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, TWidth, TWidth)];
        
        //TODO: 判断对错加载图
        
        imageView.image = [UIImage imageNamed:@"list_btn_right"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 20, TWidth, TWidth);
//        NSString *titleString = [NSString stringWithFormat:@"%.f%%", [model.C_count floatValue]*100/([model.C_count floatValue] + [model.W_count floatValue])];
//        [button setTitle:[NSString stringWithFormat:@"%@", titleString] forState:UIControlStateNormal];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        label2.text =[NSString stringWithFormat:@"%d%%",i*10];
        label2.textAlignment = NSTextAlignmentCenter;
        
        [taskView addSubview:label];
        [taskView addSubview: label2];
        
        [taskView addSubview:imageView];
        [taskView addSubview:button];
//        taskView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:taskView];
    }
    
    self.answerCellHeight = size.height + 80 + 30;
}

- (void)allBtnClicked:(UIButton *)btn {
    
    
}

@end
