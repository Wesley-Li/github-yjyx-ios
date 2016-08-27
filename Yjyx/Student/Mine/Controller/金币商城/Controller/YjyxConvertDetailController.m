//
//  YjyxConvertDetailController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxConvertDetailController.h"
#import "YjyxConvertDetailCell.h"
#import "YjyxExchangeRecordModel.h"
@interface YjyxConvertDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation YjyxConvertDetailController
static NSString *ID = @"CELL";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"兑换成功";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxConvertDetailCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.convertShopArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxConvertDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.convertShopArr[indexPath.row];
    return cell;
}
@end
