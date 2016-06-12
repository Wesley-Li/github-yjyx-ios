//
//  BookViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "BookViewController.h"
#import "ChooseMaterialCell.h"

#import "ChapterViewController.h"
#import "PickerView.h"
#import <AFNetworking.h>
#import "GradeContentItem.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "GradeVerVolItem.h"
@interface BookViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSMutableArray *materialArr;
@property (weak, nonatomic) PickerView *selectMatieral;
@property (strong, nonatomic) NSMutableArray *bookArr;
@property (copy, nonatomic) NSString *selWord;

@property (strong, nonatomic) NSMutableArray *chapterArr;
@end

@implementation BookViewController
static NSString *ID = @"ChooseMater";
#pragma mark - view的生命周期方法
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
- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = YES;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 私有方法
- (void)pickerCancel
{
    [_selectMatieral removeFromSuperview];

}
- (void)pickerDone:(NSNotification *)noti
{
    [_selectMatieral removeFromSuperview];

    self.selWord = noti.userInfo[@"selectedWord"];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%zd", indexPath.row);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (IBAction)goSure:(id)sender {
    
    
    ChooseMaterialCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ChooseMaterialCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if(cell1.detail_label.text == nil){
        [self.view makeToast:@"请选择教材" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }else if(cell2.detail_label.text == nil){
        [self.view makeToast:@"请选择课本" duration:1.0 position:SHOW_CENTER complete:nil];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    NSString *vol= [cell2.detail_label.text substringFromIndex:3];
    NSString *grade = [cell2.detail_label.text substringToIndex:3];
    NSInteger volid = 1;
    NSInteger gradeid = 1;
    NSInteger verid = 1;
    if([vol isEqualToString:@"下册"]){
        volid = 2;
    }
    if([grade isEqualToString:@"八年级"]){
        gradeid = 2;
    }else if([grade isEqualToString:@"九年级"]){
        gradeid = 3;
    }
    if([cell1.detail_label.text isEqualToString:@"人教版"]){
        verid = 2;
    }
    [self.chapterArr removeAllObjects];
   GradeVerVolItem *item = [GradeVerVolItem gradeVerVolItemWithGrade:gradeid andVolid:volid anfVerid:verid];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"getbookunit";
    pamar[@"gradeid"] = @(gradeid);
    pamar[@"verid"] = @(verid);
    pamar[@"volid"] = @(volid);
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/vgsv/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"retcode"] isEqual:@0]) {
            for (NSDictionary *dict in responseObject[@"content"]) {
                GradeContentItem *item = [GradeContentItem gradeContentItem:dict];
                [self.chapterArr addObject:item];
            }
            ChapterViewController *chapterVc = [[ChapterViewController alloc] init];
            chapterVc.chaperArr = self.chapterArr;
            chapterVc.GradeNumItem = item;
            NSString *title = [NSString stringWithFormat:@"%@-%@",cell1.detail_label.text, cell2.detail_label.text];
            chapterVc.title1 = title;
            [self.navigationController pushViewController:chapterVc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismiss];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"$$$$$$$$$$$");
        [SVProgressHUD dismiss];
    }];
    
}
#pragma mark - 懒加载
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
        PickerView *selectMatieral = [PickerView pickerView];
        [self.view addSubview:selectMatieral];
        _selectMatieral = selectMatieral;
        
    }
    return _selectMatieral;
}
- (NSMutableArray *)chapterArr
{
    if (_chapterArr == nil) {
        _chapterArr = [NSMutableArray array];
    }
    return _chapterArr;
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
    
       [self  selectMatieral];
    
    
}

@end
