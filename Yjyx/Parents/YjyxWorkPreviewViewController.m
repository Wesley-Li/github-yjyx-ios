//
//  YjyxWorkPreviewViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/3/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxWorkPreviewViewController.h"
#import "RCLabel.h"

@interface YjyxWorkPreviewViewController ()

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
    [self getchildResult:_previewRid];
    _choices = [[NSArray alloc] init];
    _blankfills = [[NSArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"RCLabelReload" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_previewTable reloadData];
    });
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RCLabelReload" object:nil];
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
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}


#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_choices count]>0&&[_blankfills  count]>0) {
        return 2;
    }else if ([_choices count] == 0&&[_blankfills count] == 0)
    {
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_choices count]>0) {
            return [_choices count];
        }
        return [_blankfills count];
    }else{
        return [_blankfills count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_choices count]) {
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    选择题"];
            return titlelb;
        }else{
            UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
            return titlelb;
        }
    }else{
        UILabel *titlelb = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 25) textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] context:@"    填空题"];
        return titlelb;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_choices count]>0) {
            NSString *content = [[_choices objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            return optimalSize.height + 10;
        }else{
            NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            return optimalSize.height + 10;
        }
    }else{
        NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 999)];
        templabel.userInteractionEnabled = NO;
        templabel.font = [UIFont systemFontOfSize:14];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        return optimalSize.height + 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH-10, 120-4)];
    bg.backgroundColor = [UIColor clearColor];
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = RGBACOLOR(225, 225, 225, 1).CGColor;
    
    if (indexPath.section == 0) {
        if ([_choices count]>0) {
            NSString *content = [[_choices objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 5);
            [cell.contentView addSubview:bg];
            
            [bg addSubview:templabel];
        }else{
            NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
            templabel.userInteractionEnabled = NO;
            templabel.font = [UIFont systemFontOfSize:14];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
            templabel.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [templabel optimumSize];
            
            bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 5);
            [cell.contentView addSubview:bg];
            [bg addSubview:templabel];
        }
    }else{
        NSString *content = [[_blankfills objectAtIndex:indexPath.row] objectForKey:@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
        templabel.userInteractionEnabled = NO;
        templabel.font = [UIFont systemFontOfSize:14];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
        templabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [templabel optimumSize];
        bg.frame = CGRectMake(5, 2, SCREEN_WIDTH -10 , optimalSize.height + 5);
        [cell.contentView addSubview:bg];
        [bg addSubview:templabel];
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
