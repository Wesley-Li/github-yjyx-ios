//
//  ChapterChoiceController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ChapterChoiceController.h"
#import "subjectContentCell.h"
#import "ChaperContentItem.h"
#import "siftContentView.h"
#import "MJRefresh.h"
@interface ChapterChoiceController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) siftContentView *siftV;
@end

@implementation ChapterChoiceController
static  NSString *ID = @"CELL";
// 懒加载筛选view
- (siftContentView *)siftV
{
    if (_siftV == nil) {
        siftContentView *siftV = [siftContentView siftContentViewFromXib];
        siftV.frame = CGRectMake(0,  -(SCREEN_HEIGHT - 64) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        [self.view  insertSubview:siftV aboveSubview:self.tableView];
        _siftV = siftV;
    }
    return _siftV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    // 导航栏右按钮的使用
    UIButton *siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    siftBtn.frame = CGRectMake(0, 0, 50, 50);
    [siftBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [siftBtn addTarget:self action:@selector(sift:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:siftBtn];
    // tableview的属性设置
    self.tableView.backgroundColor = COMMONCOLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 加载cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([subjectContentCell class]) bundle:nil] forCellReuseIdentifier:ID];
    // 加载刷新按钮
    [self loadRefresh];
}
// 加载刷新按钮
- (void)loadRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView  addFooterWithTarget:self action:@selector(loadMoreData)];
}
// 头部刷新 加载新数据
- (void)loadNewData
{
    [self.tableView headerEndRefreshing];
}
// 尾部刷新 加载更多数据
- (void)loadMoreData
{
    [self.tableView footerEndRefreshing];
}
// 筛选按钮的点击
- (void)sift:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"%zd", btn.selected);

    if(btn.selected){
    self.siftV.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT - 64);
}else{
    self.siftV.transform = CGAffineTransformMakeTranslation(0, -(SCREEN_HEIGHT - 64));
}

    
}

#pragma mark - UITableView的数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chapterItemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    subjectContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = self.chapterItemArray[indexPath.row];
    
    cell.subjectNumLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChaperContentItem *item = self.chapterItemArray[indexPath.row];
    return item.cellHeight;
}
@end
