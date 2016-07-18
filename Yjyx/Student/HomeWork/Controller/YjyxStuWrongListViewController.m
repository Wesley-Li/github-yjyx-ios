//
//  YjyxStuWrongListViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxStuWrongListViewController.h"
#import "YjyxStuWrongListModel.h"
#import "YjyxStuWrongListCell.h"

#define ID @"YjyxStuWrongListCell"
@interface YjyxStuWrongListViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *heightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillExpandDic;

@end

@implementation YjyxStuWrongListViewController

- (NSMutableArray *)dataSource {
 
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.heightDic = [NSMutableDictionary dictionary];
    self.blankfillExpandDic = [NSMutableDictionary dictionary];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getDataFromNet];
    
    // 注册加载完成高度的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableviewCellHeight:) name:@"WEBVIEW_HEIGHT" object:nil];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YjyxStuWrongListCell class]) bundle:nil] forCellReuseIdentifier:ID ];
}


- (void)refreshTableviewCellHeight:(NSNotification *)sender {

    YjyxStuWrongListCell *cell = [sender object];
    
    if (![self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
    {
        [self.heightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
    }

 
    
}


- (void)getDataFromNet {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getonesubjectfailedquestion", @"action", self.subjectid, @"subjectid", self.targetlist, @"targetlist", nil];
    NSLog(@"%@", param);
    [manager GET:[BaseURL stringByAppendingString:STUDENT_GET_WRONG_LIST_GET] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                YjyxStuWrongListModel *model = [[YjyxStuWrongListModel alloc] init];
                [model initModelWithDic:dic];
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
            
        }else {
        
            [self.view makeToast:responseObject[@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error.localizedDescription);
        [self.view makeToast:@"数据请求失败,请检查您的网络" duration:1.0 position:SHOW_CENTER complete:nil];
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    
    if (height == 0) {
        
        return 300;
        
    }else {
        
        return height;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YjyxStuWrongListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    
    if (!cell.solutionBtn.hidden) {
        [cell.solutionBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell.expandBtn addTarget:self action:@selector(changeCellHeight:) forControlEvents:UIControlEventTouchUpInside];
    cell.expandBtn.selected = [[self.blankfillExpandDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue];
    
    NSString *expand = [self.blankfillExpandDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    
    if (expand == nil) {
        cell.expandBtn.selected = NO;
    }else {
        cell.expandBtn.selected = [expand boolValue];
    }
    
    YjyxStuWrongListModel *model = self.dataSource[indexPath.row];
    
    [cell setSubviewsWithModel:model];
    
    return cell;
}

- (void)changeCellHeight:(UIButton *)sender {
    
    YjyxStuWrongListCell *cell = (YjyxStuWrongListCell *)sender.superview.superview.superview;
    cell.expandBtn.selected = !cell.expandBtn.selected;
    
    if (cell.expandBtn.selected == YES) {
        [self.blankfillExpandDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
    }else {
        [self.blankfillExpandDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld", cell.tag]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)playVideo:(UIButton *)sender {

    YjyxStuWrongListCell *cell = (YjyxStuWrongListCell *)sender.superview.superview.superview;
    YjyxStuWrongListModel *model = self.dataSource[cell.tag];
    
    if (model.videoUrl == nil && model.explanation == nil) {
        // 非会员
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"查看解题方法需要会员权限，是否前往试用或成为会员" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 跳转至会员页面
            
            
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }else {
    
        
    }
}



- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
