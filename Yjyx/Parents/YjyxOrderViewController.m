//
//  YjyxOrderViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/5/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxOrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderNewEntity.h"

@interface YjyxOrderViewController ()

@end

@implementation YjyxOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    orderAry = [[NSMutableArray alloc] init];
    [self loadBackBtn];
    [self getOrder];
    // Do any additional setup after loading the view from its nib.
}

-(void)getOrder
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"list",@"action",@"0",@"lastid",nil];
    [[YjxService sharedInstance] getOrder:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                    for (int i = 0; i< [[result objectForKey:@"orders"] count]; i++) {
                        OrderNewEntity *entity = [OrderNewEntity wrapOrderEntityWithDic:[[result objectForKey:@"orders"] objectAtIndex:i]];
                        [orderAry addObject:entity];
                    }
                    [orderTable reloadData];
                }else{
                    [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
                }
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [orderAry count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    OrderNewEntity *entity = [orderAry objectAtIndex:indexPath.row];
    cell.orderTime.text = [NSString stringWithFormat:@"订单时间:%@",entity.paiddatetime];
    cell.orderOutrade.text = [NSString stringWithFormat:@"订单编号:%@",entity.tradeno_yijiao];
    cell.orderPrice.text = [NSString stringWithFormat:@"%@元",entity.total_fee];
    cell.orderSubject.text = entity.product__name;
    return cell;
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
