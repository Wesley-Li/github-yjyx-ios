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

// 年级数组
@property (strong, nonatomic) NSArray *gradeArr;
// 版本数组
@property (strong, nonatomic) NSArray *versionArr;
// 册号数组
@property (strong, nonatomic) NSArray *volArr;
@end

@implementation BookViewController
static NSString *ID = @"ChooseMater";
static BookViewController *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
#pragma mark - view的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择教材课本";
    [self loadBackBtn];
   
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseMaterialCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.types = [[NSArray alloc] initWithObjects:@"选择教材版本", @"选择课本", nil];
    self.tableView.rowHeight = 65;
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)loadData
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *pamar = [NSMutableDictionary dictionary];
    pamar[@"action"] = @"list";
    [mgr GET:[BaseURL stringByAppendingString:@"/api/teacher/vgsv/"] parameters:pamar success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        self.gradeArr = responseObject[@"grade_list"];
        self.versionArr = responseObject[@"version_list"];
        self.volArr = responseObject[@"vol_list"];
        
        NSLog(@"%@, %@, %@", self.gradeArr, self.versionArr, self.volArr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:error.localizedDescription duration:0.5 position:SHOW_CENTER complete:nil];
    }];
}
// 确定按钮的点击
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
    NSLog(@"%@---%@",cell1.detail_label.text, cell2.detail_label.text );
    NSString *grade = [cell2.detail_label.text substringToIndex:cell2.detail_label.text.length - 2];
    NSInteger volid = 1;
    NSInteger gradeid = 0;
    NSInteger verid = 0;
    for (NSArray *tempArr in self.volArr) {
        if([cell2.detail_label.text containsString:tempArr[1]]){
            volid = [tempArr[0] integerValue];
            break;
        }
    }
    
    for (NSArray *tempArr in _gradeArr) {
        if([tempArr[1] isEqualToString:grade]){
            gradeid = [tempArr[0] integerValue];
            break;
        }
    }
    for (NSArray *tempArr in _versionArr) {
        if ([tempArr[1] isEqualToString:cell1.detail_label.text]) {
            verid = [tempArr[0] integerValue];
            break;
        }
    }
    NSLog(@"%ld----%ld-----%ld", verid, volid, gradeid);
    [self.chapterArr removeAllObjects];
    NSString *title = [NSString stringWithFormat:@"%@-%@",cell1.detail_label.text, cell2.detail_label.text];
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"TeacherPostTitle"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@(volid), @(gradeid), @(verid)] forKey:@"ChaperContentPamar"];

    ChapterViewController *chapterVc = [[ChapterViewController alloc] init];

    chapterVc.title1 = title;
    chapterVc.gradeid = gradeid;
    chapterVc.volid = volid;
    chapterVc.verid = verid;
  
    [self.navigationController pushViewController:chapterVc animated:YES];
 
   
    
    
    
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
        selectMatieral.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
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
 
    cell.selMaterial = self.verVolArr[indexPath.row];
    if (self.selWord != nil) {
        cell.selMaterial = self.selWord;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [_materialArr removeAllObjects];
    [_bookArr removeAllObjects];
 
            if (indexPath.row == 0) {
                NSArray *arr = self.versionArr;
                NSLog(@"%@", arr);
                for (NSInteger i = 0; i < arr.count; i++){
                    [self.materialArr addObject:  arr[i][1]];
                }
                self.selectMatieral.materialArr = _materialArr;
            }else{
                NSArray *arr = self.gradeArr;
                NSArray *curArr = self.volArr;
                for (NSInteger i = 0; i < arr.count; i++) {
                    for (NSArray *tempArr in curArr) {
                        [self.bookArr addObject:[arr[i][1] stringByAppendingString:tempArr[1]]];
                    }
//                    [self.bookArr addObject:[arr[i][1] stringByAppendingString:@"上册"]];
//                    [self.bookArr addObject:[arr[i][1] stringByAppendingString:@"下册"]];
                    
                }
                self.selectMatieral.materialArr = _bookArr;
            }
            
    
    
       [self  selectMatieral];
    
    
}

@end
