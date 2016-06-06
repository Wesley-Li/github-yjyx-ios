//
//  BookViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "BookViewController.h"
#import "ChooseMaterialCell.h"

#import "PickerSelectController.h"
#import "PickerView.h"
#import <AFNetworking.h>
@interface BookViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSMutableArray *materialArr;
@property (strong, nonatomic) PickerView *selectMatieral;
@property (strong, nonatomic) NSMutableArray *bookArr;
@property (copy, nonatomic) NSString *selWord;
@end

@implementation BookViewController
static NSString *ID = @"ChooseMater";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择教材课本";
    [self loadBackBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseMaterialCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.types = [[NSArray alloc] initWithObjects:@"选择教材版本", @"选择课本", nil];
    self.tableView.rowHeight = 80;
    self.tableView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerCancel) name:@"PickViewCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerDone:) name:@"PickViewDone" object:nil];
}

- (void)pickerCancel
{
    [_selectMatieral removeFromSuperview];
////    [_materialArr removeAllObjects];
//    [_bookArr removeAllObjects];
}
- (void)pickerDone:(NSNotification *)noti
{
    [_selectMatieral removeFromSuperview];
//    [_materialArr removeAllObjects];
//    [_bookArr removeAllObjects];
    self.selWord = noti.userInfo[@"selectedWord"];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%zd", indexPath.row);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)materialArr
{
    if (_materialArr == nil) {
        _materialArr = [NSMutableArray array];
    }
    return _materialArr;
}
- (NSMutableArray *)bookArr
{
    if (_bookArr == nil) {
        _bookArr = [NSMutableArray array];
    }
    return _bookArr;
}
- (PickerView *)selectMatieral
{
    if (_selectMatieral == nil) {
        _selectMatieral = [PickerView pickerView];
        
    }
    return _selectMatieral;
}
#pragma mark  - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.type = _types[indexPath.row];
    
    cell.selMaterial = self.selWord;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [_materialArr removeAllObjects];
    [_bookArr removeAllObjects];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
        pamar[@"action"] = @"list";
        [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/vgsv/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [responseObject writeToFile:@"/Users/wangdapeng/Desktop/文件/2.plist" atomically:YES];
            
            if (indexPath.row == 0) {
                NSArray *arr = responseObject[@"version_list"];
                for (NSInteger i = 0; i < arr.count; i++){
                    [self.materialArr addObject:  arr[i][1]];
                }
                _selectMatieral.materialArr = _materialArr;
            }else{
                NSArray *arr = responseObject[@"grade_list"];
                for (NSInteger i = 0; i < arr.count; i++) {
                    [self.bookArr addObject:[arr[i][1] stringByAppendingString:@"上册"]];
                    [self.bookArr addObject:[arr[i][1] stringByAppendingString:@"下册"]];
                }
                _selectMatieral.materialArr = _bookArr;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"$$$$$$$$$$$");
        }];
    
    [self.view addSubview:self.selectMatieral];
    
    
}

@end
