//
//  ClassDetailViewController.m
//  Yjyx
//
//  Created by 刘少昌 on 16/4/28.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "StuClassEntity.h"
#import "ClassCustomTableViewCell.h"
#import "StudentEntity.h"
#import "StuDataBase.h"
#import "MJRefresh.h"
#import "StuGroupEntity.h"
@interface ClassDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *invitecodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stuCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *stuListTableView;
@property (weak, nonatomic) IBOutlet UILabel *memblistLabel;

@end

@implementation ClassDetailViewController

- (void)viewWillAppear:(BOOL)animated {

    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadBackBtn];
    // 右边刷新按钮
    UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;

    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    if(self.groupModel != nil){
        self.invitecodeLabel.hidden = YES;
        self.memblistLabel.text = @"群组成员";
        self.navigationItem.title = self.groupModel.name;
    }
    self.invitecodeLabel.text = [NSString stringWithFormat:@"班级邀请码:%@" ,[numberFormatter stringFromNumber:self.model.invitecode]];
    NSInteger totalNum = self.groupModel == nil ? self.model.memberlist.count : self.groupModel.memberlist.count;
    self.stuCountLabel.text = [NSString stringWithFormat:@"%ld人", totalNum];
    
    // 注册
    [self.stuListTableView registerNib:[UINib nibWithNibName:@"ClassCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CC"];
    
    self.stuListTableView.tableFooterView = [[UIView alloc] init];
    
}

// 刷新
- (void)refresh {
    
    
    // 刷新数据库
//    [(AppDelegate *)SYS_DELEGATE getStuList];
    
    [(AppDelegate *)SYS_DELEGATE getStuListComplete:^{
        NSMutableArray *classArray = [[StuDataBase shareStuDataBase] selectAllClass];
        
        
        NSMutableArray *groupArray = [[StuDataBase shareStuDataBase] selectAllGroup];
        for (StuGroupEntity *currGroupModel in groupArray) {
            NSLog(@"%@",currGroupModel.memberlist);
        }
        
        //    self.model = classArray[self.currentIndex];
        if(self.groupModel != nil){
            for (StuGroupEntity *currGroupModel in groupArray) {
                if([currGroupModel.gid isEqual:self.groupModel.gid]){
                    self.groupModel = currGroupModel;
                }
            }
        }else{
            for (StuClassEntity *currClassModel in classArray) {
                if([currClassModel.gradeid isEqual:self.model.gradeid] && [currClassModel.cid isEqual:self.model.cid]){
                    NSLog(@"%@", currClassModel.name);
                    self.model = currClassModel;
                }
            }
        }
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        self.invitecodeLabel.text = [NSString stringWithFormat:@"班级邀请码:%@" ,[numberFormatter stringFromNumber:self.model.invitecode]];
        self.stuCountLabel.text = [NSString stringWithFormat:@"%ld人", (unsigned long)self.model.memberlist.count];
        [self viewDidLoad];
        
        
        [self.stuListTableView reloadData];
        
        [SVProgressHUD showWithStatus:@"正在刷新"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
    }];
//    NSMutableArray *classArray = [[StuDataBase shareStuDataBase] selectAllClass];
//    
//
//    NSMutableArray *groupArray = [[StuDataBase shareStuDataBase] selectAllGroup];
//    
////    self.model = classArray[self.currentIndex];
//    if(self.groupModel != nil){
//    for (StuGroupEntity *currGroupModel in groupArray) {
//        if([currGroupModel.gid isEqual:self.groupModel.gid]){
//            self.groupModel = currGroupModel;
//        }
//    }
//    }else{
//        for (StuClassEntity *currClassModel in classArray) {
//            if([currClassModel.gradeid isEqual:self.model.gradeid] && [currClassModel.cid isEqual:self.model.cid]){
//                NSLog(@"%@", currClassModel.name);
//                self.model = currClassModel;
//            }
//        }
//    }
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    self.invitecodeLabel.text = [NSString stringWithFormat:@"班级邀请码:%@" ,[numberFormatter stringFromNumber:self.model.invitecode]];
//    self.stuCountLabel.text = [NSString stringWithFormat:@"%ld人", (unsigned long)self.model.memberlist.count];
//    [self viewDidLoad];
//
//    
//    [self.stuListTableView reloadData];
//    
//    [SVProgressHUD showWithStatus:@"正在刷新"];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
//    

    
}

- (void)dismiss {
    
    [SVProgressHUD dismiss];

}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", self.groupModel == nil ? self.model.memberlist.count : self.groupModel.memberlist.count);

    return self.groupModel == nil ? self.model.memberlist.count : self.groupModel.memberlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClassCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CC" forIndexPath:indexPath];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *num = self.groupModel == nil ? self.model.memberlist[indexPath.row] : self.groupModel.memberlist[indexPath.row];
    NSString *stuID = [numberFormatter stringFromNumber: num];
//    NSLog(@"____%@", stuID);
    
    StudentEntity *model = [[StuDataBase shareStuDataBase] selectStuById:stuID];
//    NSLog(@"%@", model.realname);
    [cell setValueWithStudentEntity:model];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
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
