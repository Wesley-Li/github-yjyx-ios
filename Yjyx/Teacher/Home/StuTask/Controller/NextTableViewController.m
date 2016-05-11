//
//  NextTableViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "NextTableViewController.h"

// 五种cell
#import "TaskCell.h"
#import "AnswerSituationCell.h"
#import "CorectCell.h"
#import "SolutionCell.h"
#import "VideoCell.h"

#define KTaskCell @"TaskCell"
#define KAnswerSituationCell @"AnswerSituationCell"
#define KCorectCell @"CorectCell"
#define KSolutionCell @"SolutionCell"
#define KVideoCell @"VideoCell"
@interface NextTableViewController ()

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) TaskCell *taskCell;
@property (nonatomic, strong) AnswerSituationCell *AnswerSituationCell;
@property (nonatomic, strong) CorectCell *correctCell;
@property (nonatomic, strong) SolutionCell *solutionCell;
@property (nonatomic, strong) VideoCell *videoCell;


@end

@implementation NextTableViewController

- (void)viewWillAppear:(BOOL)animated {

    [self readDataFromNetWork];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self readDataFromNetWork];
    
    if ([_qtype isEqualToNumber:@1]) {
        self.title = [NSString stringWithFormat:@"选择题(%d/%d)", [_C_count intValue], [_C_count intValue] + [_W_count intValue]];
    }else {
    
        self.title = [NSString stringWithFormat:@"填空题(%d/%d)", [_C_count intValue], [_C_count intValue] + [_W_count intValue]];
    }
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskCell" bundle:nil]forCellReuseIdentifier:KTaskCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerSituationCell" bundle:nil] forCellReuseIdentifier:KAnswerSituationCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"CorectCell" bundle:nil] forCellReuseIdentifier:KCorectCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"SolutionCell" bundle:nil] forCellReuseIdentifier:KSolutionCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:KVideoCell];
    
    
    
    

}

- (void)readDataFromNetWork {

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"gettaskonequestiondetail", @"action", self.taskid, @"taskid", self.qtype, @"qtype", self.qid, @"qid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:T_SESSIONID forHTTPHeaderField:@"sessionid"];
    
//    NSLog(@"%@", dic);
    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_SCAN_THE_TASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"retcode"] isEqual: @0]) {
            
            self.dic = [NSDictionary dictionaryWithDictionary:responseObject];
            
        }else {
            
            [self.tableView makeToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row == 0) {
        self.taskCell = [tableView dequeueReusableCellWithIdentifier:KTaskCell];
        NSLog(@"%@", _dic);
        [_taskCell setValueWithDictionary:_dic];

        return _taskCell;
    }else if (indexPath.row == 1) {
    
        self.AnswerSituationCell = [tableView dequeueReusableCellWithIdentifier:KAnswerSituationCell];
        
        return _AnswerSituationCell;
    }else if (indexPath.row == 2) {
    
        self.correctCell = [tableView dequeueReusableCellWithIdentifier:KCorectCell];
        if ([self.qtype isEqual:@1]) {
            [_correctCell setChoiceValueWithDictionary:_dic];
            
        }else {
        
            [_correctCell setBlankfillValueWithDictionary:_dic];
           
        }
        return _correctCell;
    }else if (indexPath.row == 3) {
    
        self.solutionCell = [tableView dequeueReusableCellWithIdentifier:KSolutionCell];
        [_solutionCell setSolutionValueWithDiction:_dic];
       
        return _solutionCell;
    }else {
    
        self.videoCell = [tableView dequeueReusableCellWithIdentifier:KVideoCell];
        [_videoCell setVideoValueWithDic:_dic];
        
        return _videoCell;
    }
   
    
}

/*

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        return 300;
    }else if (indexPath.row == 1) {
        
        return 500;
    }else if (indexPath.row == 2) {
        
        return 500;
    }else if (indexPath.row == 3) {
        
        return 400;
    }else {
        
        return 300;
    }

}

 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        return self.taskCell.height;
    }else if (indexPath.row == 1) {
        
        return 250;
    }else if (indexPath.row == 2) {
        
        return self.correctCell.height;
    }else if (indexPath.row == 3) {
        
        return self.solutionCell.height;
    }else {
        
        return self.videoCell.height;
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
