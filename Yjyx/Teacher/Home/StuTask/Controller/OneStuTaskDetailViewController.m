//
//  OneStuTaskDetailViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "OneStuTaskDetailViewController.h"

#import "TaskCell.h"
#import "CorectCell.h"
#import "SolutionCell.h"
#import "VideoCell.h"
#import "YourAnswerCell.h"

#define kidentifier1 @"kCell1"
#define kidentifier2 @"kCell2"
#define Kidentifier3 @"kCell3"
#define Kidentifier4 @"kCell4"
#define Kidentifier5 @"kCell5"


@interface OneStuTaskDetailViewController ()

@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation OneStuTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 申请网络
    [self readDataFromNetWork];
    
    // 注册cell
    
    
    
    

}

#pragma mark - 网络请求
- (void)readDataFromNetWork {

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getonequestiondetailforonestudent", @"action", self.taskid, @"taskid", self.suid, @"suid", self.qtype, @"qtype", self.qid, @"qid", nil];
    NSLog(@"%@", dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager.requestSerializer setValue:T_SESSIONID forHTTPHeaderField:@"sessionid"];
    
    [manager GET:[BaseURL stringByAppendingString:TEACHER_DETAIL_ONESTU_ONETASK_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
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
