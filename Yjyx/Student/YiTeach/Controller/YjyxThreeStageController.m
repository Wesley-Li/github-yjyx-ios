//
//  YjyxThreeStageController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxThreeStageController.h"
#import "YjyxThreeStageSubjectCell.h"
#import "YjyxThreeStageModel.h"
@interface YjyxThreeStageController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *threeStageArr;
@end

@implementation YjyxThreeStageController
static NSString *ID = @"CELL";
#pragma mark - 懒加载
- (NSMutableArray *)threeStageArr
{
    if (_threeStageArr == nil) {
        _threeStageArr = [NSMutableArray array];
    }
    return _threeStageArr;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    self.navigationItem.title = @"亿教课堂";
    [self setupRightNavItem];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict1 = @{@"choicecount": @4};
     NSDictionary *dict2 = @{ @"choicecount": @6};
     NSDictionary *dict3 = @{ @"choicecount": @8 };
     NSDictionary *dict4 = @{@"choicecount": @12};
    NSArray *arr = @[dict1, dict2, dict3, dict4];
    for (NSDictionary *dict in arr) {
        YjyxThreeStageModel *model = [YjyxThreeStageModel threeStageModelWithDict:dict];
        [self.threeStageArr addObject:model];
    }
    

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxThreeStageSubjectCell class]) bundle:nil] forCellReuseIdentifier:ID];
}
#pragma mark -私有方法
- (void)setupRightNavItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"知识卡" style:UIBarButtonItemStylePlain target:self action:@selector(knowLedgeBtnClick)];
}
- (void)knowLedgeBtnClick
{
    NSLog(@"dianjile");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.threeStageArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YjyxThreeStageSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.threeStageArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
@end
