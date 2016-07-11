//
//  YjyxWorkPreviewViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkPreviewViewController.h"
#import "PPreviewCell.h"

#define ID @"Cell"
@interface YjyxWorkPreviewViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *choiceCellHeightDic;
@property (nonatomic, strong) NSMutableDictionary *blankfillHeightDic;

@end

@implementation YjyxWorkPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [YjyxOverallData sharedInstance].pushType = PUSHTYPE_NONE;
    self.navigationController.navigationBarHidden = NO;
    [self loadBackBtn];
    
    _choices = [[NSArray alloc] init];
    _blankfills = [[NSArray alloc] init];
    self.choiceCellHeightDic = [[NSMutableDictionary alloc] init];
    self.blankfillHeightDic = [[NSMutableDictionary alloc] init];
    
    // 请求网络数据
    [self getchildResult:_previewRid];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellHeight:) name:@"cellHeighChange" object:nil];
    
    [self.previewTable registerNib:[UINib nibWithNibName:NSStringFromClass([PPreviewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)refreshCellHeight:(NSNotification *)sender {
    
    PPreviewCell *cell = [sender object];
    
    // 保存高度
    if (cell.indexPath.section == 0) {
        
        if (![self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.choiceCellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
        {
            [self.choiceCellHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.previewTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else {
        if (![self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]]||[[self.blankfillHeightDic objectForKey:[NSString stringWithFormat:@"%ld",cell.tag]] floatValue] != cell.height)
        {
            [self.blankfillHeightDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld",cell.tag]];
            [self.previewTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:1 ]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }

    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(23, 155, 121, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellHeighChange" object:nil];
    [super viewWillDisappear:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
