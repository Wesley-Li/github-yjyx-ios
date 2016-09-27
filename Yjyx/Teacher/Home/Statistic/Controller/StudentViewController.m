//
//  StudentViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/6/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StudentViewController.h"

#import "StuDataBase.h"
#import "StudentEntity.h"
#import "StuClassEntity.h"
#import "ClassCustomTableViewCell.h"
#import "CustomSectionView.h"
#import "OneStuViewController.h"


#define iD @"StatisticClassCell"
#define identi @"ClassCustomTableViewCell"

@interface StudentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 获取班级信息
@property (strong, nonatomic) NSMutableArray *classArr;
// 保存所有学生信息
@property (strong, nonatomic) NSMutableArray *stuArr;
// 保存班级里的学生信息
@property (strong, nonatomic) NSMutableArray *classStuArr;

@property (strong, nonatomic) NSMutableDictionary *dic;

@property (nonatomic, strong) NSMutableArray *gradeArr;
@end

@implementation StudentViewController


- (NSMutableArray *)classArr
{
    if (_classArr == nil) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

- (NSMutableArray *)stuArr
{
    if (_stuArr == nil) {
        _stuArr = [NSMutableArray array];
    }
    return _stuArr;
}

- (NSMutableArray *)classStuArr
{
    if (_classStuArr == nil) {
        _classStuArr = [NSMutableArray array];
    }
    return _classStuArr;
}


- (void)viewWillAppear:(BOOL)animated {

    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置导航栏
    self.navigationItem.title = @"学生统计";
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.dic = [[NSMutableDictionary alloc] init];
    
    // 获取数据源
    self.classArr = [[StuDataBase shareStuDataBase] selectAllClass];
    NSLog(@"%@", self.classArr);
    for (StuClassEntity *stuClassModel in self.classArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSNumber *num in stuClassModel.memberlist) {
            StudentEntity *stuModel = [[StuDataBase shareStuDataBase] selectStuById:num];
            [tempArr addObject:stuModel];
        }
        [self.classStuArr addObject:tempArr];
    }
    
    self.gradeArr = [[[YjyxOverallData sharedInstance].teacherInfo.school_classes JSONValue] mutableCopy];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassCustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:iD];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = COMMONCOLOR;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.classArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 80;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    CustomSectionView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomSectionView class]) owner:nil options:nil] firstObject];
    
    StuClassEntity *model = self.classArr[section];
    NSLog(@"%@, %@", model.gradeid, model.cid);
    if ([model.name containsString:@"年级"]) {
        view.titleLabel.text = model.name;
        
    }else {
        NSString *titleString = [NSString stringWithFormat:@"%@%@", model.gradename, model.name];
        view.titleLabel.text = titleString; 
    }

//    view.titleLabel.text = model.name;
    view.section = section;
    view.expandBtn.selected = [[self.dic objectForKey:[NSString stringWithFormat:@"%ld", view.section]] boolValue];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(showMoreStudent:)];
    
    [view addGestureRecognizer: tap];
    return view;

}

- (void)showMoreStudent:(UITapGestureRecognizer *)sender {

    CustomSectionView *view = (CustomSectionView *)sender.view;
    
    view.expandBtn.selected = !view.expandBtn.selected;
    if ([[self.dic objectForKey:[NSString stringWithFormat:@"%ld", view.section]] isEqualToString:@"YES"]) {
        
        [self.dic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld", view.section]];
        
    }else {
        
        [self.dic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld", view.section]];
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:view.section];
    [self.tableView reloadSections:indexSet  withRowAnimation:UITableViewRowAnimationFade];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.dic objectForKey:[NSString stringWithFormat:@"%ld", section]] isEqualToString:@"YES"]) {
        return [self.classStuArr[section] count];
    }else {
    
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClassCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iD forIndexPath:indexPath];
    
    StudentEntity *model = self.classStuArr[indexPath.section][indexPath.row];
    
    [cell setValueWithStudentEntity:model];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    OneStuViewController *oneStuVC = [[OneStuViewController alloc] init];
    
    StudentEntity *model = self.classStuArr[indexPath.section][indexPath.row];
    oneStuVC.stuID = model.user_id;
    oneStuVC.navigationItem.title = [NSString stringWithFormat:@"%@统计", model.realname];
    
    [self.navigationController pushViewController:oneStuVC animated:YES];

}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 80;
    //固定section 随着cell滚动而滚动
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
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
