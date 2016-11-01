//
//  YjyxWorkPreviewViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkPreviewViewController.h"
#import "PPreviewCell.h"
#import "YjyxCommonNavController.h"
#import "YjyxDoingWorkModel.h"
#import "YjyxDoingWorkController.h"
#define ID @"Cell"
@interface YjyxWorkPreviewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;

@property (nonatomic, strong) NSMutableDictionary *choiceCellHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillHeightDic;

@property (weak, nonatomic) IBOutlet UIButton *beginWorkBtn;

@property (assign, nonatomic) NSInteger jumpType;

@property (strong, nonatomic) NSMutableArray *doWorkArr;

@property (strong, nonatomic) NSNumber *subject_id; // 科目id
@end

@implementation YjyxWorkPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    
    self.navigationController.navigationBarHidden = NO;
    _doWorkArr = [NSMutableArray array];
    _choices = [[NSArray alloc] init];
    _blankfills = [[NSArray alloc] init];
    self.choiceCellHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillHeightDic = [[NSMutableDictionary alloc] init];
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight:) name:@"cellHeighChange" object:nil];
    
    [self.previewTable registerNib:[UINib nibWithNibName:NSStringFromClass([PPreviewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    if ([self.navigationController isKindOfClass:[YjyxCommonNavController class]]) {
        self.jumpType = 1;
        // 请求学生端数据
        [self loadData];
    }else{
        // 请求网络数据
        [self getchildResult:_previewRid];
    }
    
}

- (void)refreshCellHeight:(NSNotification *)sender {
    
    PPreviewCell *cell = [sender object];
    
    // 保存高度
    if (cell.indexPath.section == 0) {
        
        if (![self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||fabs([[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2)
        {
            [self.choiceCellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.previewTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else {
        if (![self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||fabs([[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] - cell.height) > 2)
        {
            [self.blankfillHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.previewTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:1 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }

    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.navigationController.navigationBarHidden = NO;
    if(self.jumpType == 1){
         self.beginWorkBtn.hidden = NO;
//        self.previewTable.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.bottomConstrait.constant = 49;
        self.navigationController.navigationBar.barTintColor = STUDENTCOLOR;
    }else{
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    [self loadBackBtn];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellHeighChange" object:nil];
    [super viewWillDisappear:YES];
}
- (void)dealloc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Request
-(void)getchildResult:(NSString *)previewrid
{
    [self.view makeToastActivity:SHOW_CENTER];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:previewrid,@"rid", @"1",@"tasktype",@"preview",@"action",nil];
    
    [[YjxService sharedInstance] getChildrenPreviewResult:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            NSLog(@"%@",result);
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                _choices = [[[result objectForKey:@"questions"] objectForKey:@"choice"] objectForKey:@"questionlist"];
                _blankfills = [[[result objectForKey:@"questions"] objectForKey:@"blankfill"] objectForKey:@"questionlist"];
                [_previewTable reloadData];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}
- (void)loadData
{
    [self.view makeToastActivity:SHOW_CENTER];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"m_get_task_exam_preview_data";
    param[@"taskid"] = self.taskid;
    param[@"examid"] = self.examid;
    [mgr GET:[BaseURL stringByAppendingString:@"/api/student/tasks/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.view hideToastActivity];
        NSLog(@"%@", responseObject);
        if ([responseObject[@"retcode"] isEqual:@0]) {
            self.subject_id = responseObject[@"retobj"][@"examobj"][@"subjectid"];
            _choices = responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"];
            _blankfills = responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"];
            if(_choices.count + _blankfills.count == 0){
                [self.view makeToast:@"题目已经被老师删除了" duration:3.0 position:SHOW_CENTER complete:nil];
                return ;
            }
            [_previewTable reloadData];
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"choice"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 1;
                [self.doWorkArr addObject:model];
            }
            for (NSDictionary *dict in responseObject[@"retobj"][@"questions"][@"blankfill"][@"questionlist"]) {
                YjyxDoingWorkModel *model = [YjyxDoingWorkModel doingWorkModelWithDict:dict];
                model.questiontype = 2;
                [self.doWorkArr addObject:model];
            }
            
            
            NSInteger i = 0;
            for (NSArray *arr in [responseObject[@"retobj"][@"examobj"][@"questionlist"] JSONValue]) {
                if(arr.count == 0){
                    continue;
                }
                if ([arr[0] isEqualToString:@"choice"]) {
                    for (NSDictionary *dict in arr[1]) {
                        if(i >= self.doWorkArr.count){
                            continue;
                        }
                        YjyxDoingWorkModel *model = self.doWorkArr[i];
                        if([dict[@"id"] isEqual:model.t_id]){
                            model.requireprocess = dict[@"requireprocess"];
                             i++;
                        }
                        
                       
                    }
                }
                if ([arr[0] isEqualToString:@"blankfill"]) {
                    for (NSDictionary *dict in arr[1]) {
                        if(i >= self.doWorkArr.count){
                            continue;
                        }
                        YjyxDoingWorkModel *model = self.doWorkArr[i];
                        if([dict[@"id"] isEqual:model.t_id]){
                        model.requireprocess = dict[@"requireprocess"];
                        i++;
                        }
                    }
                }
            }

        }else{
           [self.view makeToast:@"获取作业失败" duration:1.0 position:SHOW_CENTER complete:nil];
            self.beginWorkBtn.userInteractionEnabled = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        [self.view makeToast:@"获取作业失败" duration:1.0 position:SHOW_CENTER complete:nil];
        self.beginWorkBtn.userInteractionEnabled = NO;
    }];
}
// 开始作业 按钮的点击
- (IBAction)doWorkBtnClick:(UIButton *)sender {
    YjyxDoingWorkController *vc = [[YjyxDoingWorkController alloc] init];
    vc.desc= self.navigationItem.title;
    vc.type = @1;
    vc.jumpDoworkArr = self.doWorkArr;
    vc.examid = self.examid;
    vc.taskid = self.taskid;
    vc.subject_id = self.subject_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_choices count];
    }else{
        return [_blankfills count];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
    
        if (_choices.count > 0) {
            return 25;
        }else {
        
            return 0;
        }
    }else {
        
        if (_blankfills.count > 0) {
            return 25;
        }else {
        
            return 0;
        }
    
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_choices count] > 0) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
            return titlelb;
        }else{
            return nil;
        }
    }else{
        
        if ([_blankfills count] > 0) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }else {
        
            return nil;
        
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        CGFloat height = [[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        
        if (height == 0) {
            
            return 300;
            
        }else {
            
            return height;
        }
        
        
    }else {
        
        CGFloat height = [[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        
        if (height == 0) {
            
            return 300;
            
        }else {
            
            return height;
        }
        
    }


    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
        
    if (indexPath.section == 0) {
        // 选择题
        NSString *content = [[_choices objectAtIndex:indexPath.row] objectForKey:@"content"];
        [cell setSubviewWithContent:content];
        cell.tag = indexPath.row;
        
        
    }else {
        // 填空题
        NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
        [cell setSubviewWithContent:content];
        cell.tag = indexPath.row;
    }
    
    
    return cell;
    
}





#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 40;
    //固定section 随着cell滚动而滚动
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

- (IBAction)beginWorkClicked:(UIButton *)sender {
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
