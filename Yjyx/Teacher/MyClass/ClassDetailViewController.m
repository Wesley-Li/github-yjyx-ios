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

@interface ClassDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *invitecodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stuCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *stuListTableView;

@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.model.name;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    self.invitecodeLabel.text = [NSString stringWithFormat:@"班级邀请码:%@" ,[numberFormatter stringFromNumber:self.model.invitecode]];
    self.stuCountLabel.text = [NSString stringWithFormat:@"%ld人", self.model.memberlist.count];
    
    // 注册
    [self.stuListTableView registerNib:[UINib nibWithNibName:@"ClassCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CC"];
    
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.memberlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClassCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CC" forIndexPath:indexPath];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *stuID = [numberFormatter stringFromNumber: self.model.memberlist[indexPath.row]];
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
