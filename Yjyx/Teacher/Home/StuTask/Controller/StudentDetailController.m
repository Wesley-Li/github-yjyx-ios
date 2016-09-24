
//
//  StudentDetailController.m
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StudentDetailController.h"
#import "OneStuTaskDetailViewController.h"

#import "SpendTimeCell.h"
#import "SubTimeCell.h"
#import "CardCell.h"
#import "ChoiceCell.h"
#import "BlankfillCell.h"

#import "FinshedModel.h"
#import "TaskConditonModel.h"

#define kSpendTime @"SpendTimeCell"
#define kSubMit @"submitTimeCell"
#define kCard @"CardCell"
#define kChoice @"ChoiceCell"
#define kBlank @"BlankfillCell"

@interface StudentDetailController ()

@property (nonatomic, assign) CGFloat choiceCellHeight;
@property (nonatomic, assign) CGFloat blankfillCellHeight;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSMutableArray *choiceArray;
@property (nonatomic, strong) NSMutableArray *blankfillArray;


@end

@implementation StudentDetailController

- (NSMutableArray *)choiceArray {

    if (!_choiceArray) {
        self.choiceArray = [NSMutableArray array];
    }
    return _choiceArray;
}

- (NSMutableArray *)blankfillArray {

    if (!_blankfillArray) {
        self.blankfillArray = [NSMutableArray array];
    }
    return _blankfillArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:24/255.0 green:138/255.0 blue:224/255.0 alpha:1.0]];
    self.navigationItem.title = self.titleName;
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"SpendTimeCell" bundle:nil] forCellReuseIdentifier:kSpendTime];
    [self.tableView registerNib:[UINib nibWithNibName:@"SubTimeCell" bundle:nil] forCellReuseIdentifier:kSubMit];
    [self.tableView registerNib:[UINib nibWithNibName:@"CardCell" bundle:nil] forCellReuseIdentifier:kCard];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChoiceCell" bundle:nil] forCellReuseIdentifier:kChoice];
    [self.tableView registerNib:[UINib nibWithNibName:@"BlankfillCell" bundle:nil] forCellReuseIdentifier:kBlank];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self readDataFromNetWork];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)readDataFromNetWork {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettaskonestudentdetail", @"action",self.taskID,@"taskid",self.studentID, @"suid",  nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseURL stringByAppendingString:TEACHER_DETAIL_ACTION_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.dic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSLog(@"%@", responseObject);
        [self.choiceArray removeAllObjects];
        [self.blankfillArray removeAllObjects];
        if ([[responseObject[@"result"] allKeys] containsObject:@"choice"]) {
            
            NSString *jsonString = [responseObject[@"result"] objectForKey:@"choice"];
//            NSString *jsonS = [jsonString stringByReplacingOccurrencesOfString:@"False" withString:@"false"];
//            NSString *jsonA = [jsonS stringByReplacingOccurrencesOfString:@"True" withString:@"true"];
            
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", array);
            
            //        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
            
            for (NSMutableArray *arr in array) {
                
                TaskConditonModel *model = [[TaskConditonModel alloc] init];
                [model initModelWithArray:arr];
                [self.choiceArray addObject:model];
            }

            
        }
        
        if ([[responseObject[@"result"] allKeys] containsObject:@"blankfill"]) {
            

            NSString *jsonStringB = [responseObject[@"result"] objectForKey:@"blankfill"];

            
            NSData *dataB = [jsonStringB dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *arrayB = [NSJSONSerialization JSONObjectWithData:dataB options:NSJSONReadingMutableContainers error:nil];
            
            for (NSArray *arr in arrayB) {
                TaskConditonModel *model = [[TaskConditonModel alloc] init];
                [model initModelWithArray:arr];
                [self.blankfillArray addObject:model];
            }
            
            
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@, %@", error.localizedDescription, error.userInfo[NSLocalizedDescriptionKey]);
        
        [self.view makeToast:error.localizedDescription duration:1.0 position:SHOW_CENTER complete:nil];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.choiceArray.count + self.blankfillArray.count == 0 ? 0 : 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if(indexPath.row == 0){
        return 40;
    }else if (indexPath.row == 1) {
        return 40;
    }else if (indexPath.row == 2) {
        
        return 60;
    }else if (indexPath.row == 3){
        
        return 50;
    }else if (indexPath.row == 4) {
        
        return _choiceCellHeight;
    }else {
    
    
        return _blankfillCellHeight;
    }



}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SpendTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpendTime forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([self.dic[@"suggestspendtime"] isEqual:[NSNull null]] || [self.dic[@"suggestspendtime"] integerValue] == 0) {
            cell.finishTime = 30;
        }else{
            cell.finishTime = [self.dic[@"suggestspendtime"] integerValue];
        }
        return cell;
    }else if (indexPath.row == 1) {
        SpendTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpendTime forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setValueWithDic:_dic];
        return cell;
    }else if (indexPath.row == 2) {
        SubTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubMit forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setValueWithDic:_dic];
        return cell;
    }else if (indexPath.row == 3) {
        
        CardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCard forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else if (indexPath.row == 4) {
    
        ChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kChoice forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (_choiceArray.count == 0) {
            cell.titleLabel.hidden = YES;
        }else {
        
            cell.titleLabel.hidden = NO;
        }
        NSLog(@"_choiceArray---%ld", _choiceArray.count);
        [self cell:cell addSubviewsWithChoiceArray:_choiceArray];
        
        return cell;
        
    }else {
    
        BlankfillCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlank forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (_blankfillArray.count == 0) {
            cell.titleLabel.hidden = YES;
        }else {
        
            cell.titleLabel.hidden = NO;
        }
        [self cell:cell addSubviewsWithBlankfillArray:_blankfillArray];
        
        return cell;
        
    }
    
    
}


// 选择题答题情况
- (void)cell:(ChoiceCell *)cell addSubviewsWithChoiceArray:(NSMutableArray *)array {

    for (UIView *view in [cell.bg_view subviews]) {
        [view removeFromSuperview];
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"选择题答题情况(%ld)", (unsigned long)array.count];
    
    CGSize size = CGSizeMake(10, 0);
    CGFloat padding = 10;
    
    NSInteger num = 7;
    
    CGFloat tWidth = (cell.contentView.frame.size.width - padding *(num + 1)) / num;
    CGFloat tHeigh = tWidth + 20 + tWidth/2;
    
    //      NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < array.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];        
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        NSLog(@"%f", size.width);
        
        if (cell.contentView.width - size.width <= 0) {
            
            // 换行
            size.width = 10;
            if (array.count - i > 1) {
                size.height += tHeigh + 10;
            }

        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        TaskConditonModel *model = array[i];
        // 题号
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tWidth, 20)];
        // 对错按钮
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(0, 20, tWidth, tWidth);
        
        if ([model.rightOrWrong isEqual:@0]) {
            [imageBtn setImage:[UIImage imageNamed:@"list_btn_wrong"] forState:UIControlStateNormal];
        }else {
            
            [imageBtn setImage:[UIImage imageNamed:@"list_btn_right"] forState:UIControlStateNormal];
            
        }
        
        imageBtn.tag = 200 + i;
        [imageBtn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i + 1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        
        // 批注标识
        if (model.voiceShow) {
            UIImageView *voiceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_icon"]];
            voiceImage.frame = CGRectMake(0, 20 + tWidth, tWidth/2, tWidth/2);
            [taskView addSubview:voiceImage];
        }
        
        if (model.imgShow) {
            UIImageView *imgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_icon"]];
            imgImage.frame = CGRectMake(tWidth/2, 20 + tWidth, tWidth/2, tWidth/2);
            [taskView addSubview:imgImage];

        }
        
        
        
        [taskView addSubview:label];
        [taskView addSubview:imageBtn];
        
        [cell.bg_view addSubview:taskView];
    }
    self.choiceCellHeight = array.count == 0 ? 0 : size.height + tHeigh + 30;
    


}

// 点击选择题
- (void)choiceBtnClick:(UIButton *)sender {

    OneStuTaskDetailViewController *oneTaskVC = [[OneStuTaskDetailViewController alloc] init];
    oneTaskVC.taskid = self.taskID;
    oneTaskVC.qtype = @1;
    oneTaskVC.suid = self.studentID;
    TaskConditonModel *model = _choiceArray[sender.tag - 200];
    oneTaskVC.qid = model.t_id;
    oneTaskVC.stuName = self.titleName;
    oneTaskVC.title = [NSString stringWithFormat:@"%@(%ld/%ld)", self.titleName, sender.tag - 199, _choiceArray.count];
    if ([model.rightOrWrong isEqual:@1]) {
        oneTaskVC.right = @"YES";
    }
    [self.navigationController pushViewController:oneTaskVC animated:YES];
    
}

// 填空题答题情况
- (void)cell:(BlankfillCell *)cell addSubviewsWithBlankfillArray:(NSMutableArray *)array {

    for (UIView *view in [cell.bg_view subviews]) {
        [view removeFromSuperview];
    }

    cell.titleLabel.text = [NSString stringWithFormat:@"填空题答题情况(%ld)", (unsigned long)array.count];
    
    CGSize size = CGSizeMake(10, 0);
    CGFloat padding = 10;
    NSInteger num = 7;
    
    CGFloat tWidth = (cell.contentView.width - padding *(num + 1)) / num;
    CGFloat tHeigh = tWidth + 20 + tWidth/2;
    
    //      NSLog(@"%@", self.choiceArr);
    
    for (int i = 0; i < array.count; i++) {
        
        UIView *taskView = [[UIView alloc] init];
        taskView.frame = CGRectMake(size.width, size.height, tWidth, tHeigh);
        
        size.width += tWidth + padding;
        
        if (cell.contentView.width - size.width <= 0) {
            // 换行
            size.width = 10;
            size.height += tHeigh;
        }
        
        //        taskView.backgroundColor = [UIColor redColor];
        TaskConditonModel *model = array[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tWidth, 20)];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        imageBtn.frame = CGRectMake(0, 20, tWidth, tWidth);
        
        
        
        if ([model.rightOrWrong isEqual:@0]) {
            [imageBtn setImage:[UIImage imageNamed:@"list_btn_wrong"] forState:UIControlStateNormal];
        }else {
            
            [imageBtn setImage:[UIImage imageNamed:@"list_btn_right"] forState:UIControlStateNormal];
            
        }
        
        imageBtn.tag = 200 + i;
        [imageBtn addTarget:self action:@selector(blankfillBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        label.text = [NSString stringWithFormat:@"%d", i + 1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        
        // 批注标识
        if (model.voiceShow) {
            UIImageView *voiceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_icon"]];
            voiceImage.frame = CGRectMake(0, 20 + tWidth, tWidth/2, tWidth/2);
            [taskView addSubview:voiceImage];
        }
        
        if (model.imgShow) {
            UIImageView *imgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_icon"]];
            imgImage.frame = CGRectMake(tWidth/2, 20 + tWidth, tWidth/2, tWidth/2);
            [taskView addSubview:imgImage];
            
        }

        
        [taskView addSubview:label];
        [taskView addSubview:imageBtn];
        
        [cell.bg_view addSubview:taskView];
    }
    self.blankfillCellHeight = array.count == 0 ? 0 : size.height + tHeigh + 30;
    

    
}

- (void)blankfillBtnClick:(UIButton *)sender {

    OneStuTaskDetailViewController *oneTaskVC = [[OneStuTaskDetailViewController alloc] init];
    oneTaskVC.taskid = self.taskID;
    oneTaskVC.qtype = @2;
    oneTaskVC.suid = self.studentID;
    TaskConditonModel *model = _blankfillArray[sender.tag - 200];
    oneTaskVC.qid = model.t_id;
    oneTaskVC.stuName = self.titleName;
    oneTaskVC.title = [NSString stringWithFormat:@"%@(%ld/%ld)", self.titleName, sender.tag - 199, _blankfillArray.count];
    if ([model.rightOrWrong isEqual:@1]) {
        oneTaskVC.right = @"YES";
    }
    [self.navigationController pushViewController:oneTaskVC animated:YES];

}



@end
