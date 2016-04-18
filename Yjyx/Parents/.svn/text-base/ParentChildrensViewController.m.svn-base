//
//  ParentChildrensViewController.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ParentChildrensViewController.h"
#import "ParentChildrenTableViewCell.h"
#import "AddChildrenViewController.h"

@interface ParentChildrensViewController ()
{
    ChildrenEntity *portraitEntity;//修改小孩头像时用到
}

@end

@implementation ParentChildrensViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的孩子";
    [self loadBackBtn];
    
    UIButton* rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBar setFrame:(CGRect){ 0, 0, 30, 30 }];
    [rightBar setImage:[UIImage imageNamed:@"nav_operate"] forState:UIControlStateNormal];
    [rightBar addTarget:self action:@selector(addchildren) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBar]];
    _childrenAry = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)preparechildrens
{
    [_childrenAry removeAllObjects];
    for (int i =0; i< [[YjyxOverallData sharedInstance].parentInfo.childrens count]; i++) {
        ChildrenEntity *childrenEntity = [[YjyxOverallData sharedInstance].parentInfo.childrens objectAtIndex:i];
        [_childrenAry addObject:childrenEntity];
    }
    [_childrenTab reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self preparechildrens];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_childrenAry count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    ParentChildrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ParentChildrenTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    ChildrenEntity *children = [_childrenAry objectAtIndex:indexPath.row];
    [cell.iconImage setImageWithURL:[NSURL URLWithString:children.childavatar] placeholderImage:[UIImage imageNamed:@"Personal_children.png"]];
    cell.iconImage.tag = indexPath.row;
    cell.nameLb.text = children.name;
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteChildren:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeChildrenPortrait:)];
    cell.iconImage.userInteractionEnabled = YES;
    [cell.iconImage addGestureRecognizer:tap];
    
    return cell;
}


#pragma mark -myEvent
-(void)deleteChildren:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ChildrenEntity *children = [_childrenAry objectAtIndex:btn.tag];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"removechild",@"action",children.cid,@"cid",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid", nil];
    [self.view makeToastActivity:SHOW_CENTER];
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                [_childrenAry removeObjectAtIndex:btn.tag];
                [[YjyxOverallData sharedInstance].parentInfo.childrens removeObjectAtIndex:btn.tag];
                [_childrenTab deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
}


-(void)addchildren
{
    AddChildrenViewController *addChildren = [[AddChildrenViewController alloc] init];
    [self.navigationController pushViewController:addChildren animated:YES];
}

#pragma mark -ChangePortrait
-(void)changeChildrenPortrait:(UITapGestureRecognizer *)tapGesture
{
    portraitEntity = [_childrenAry objectAtIndex:tapGesture.view.tag];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"更换小孩头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从相册中选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    if (buttonIndex == 0) {
        if (![AccessJudge carmerAccessJudge])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启相机:设置 > 隐私 > 相机" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [_picker setAllowsEditing:NO];
        [self.navigationController presentViewController:_picker animated:YES completion:nil];
        
    } else if(buttonIndex == 1){
        if (![AccessJudge libraryAccessJudge])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启相机:设置 > 隐私 > 照片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [_picker setAllowsEditing:NO];
        [self.navigationController presentViewController:_picker animated:YES completion:nil];
        
    }
}

#pragma mark -UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.view makeToastActivity:SHOW_CENTER];
    UIImage *image = [info[UIImagePickerControllerOriginalImage] fixOrientation];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
    [[YjxService sharedInstance] getAboutqinniu:dic withBlock:^(id result, NSError *error){
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                NSString *token = [result objectForKey:@"uptoken"];
                [self upfiletoQiniu:token image:image];
            }else{
                [self.view hideToastActivity];
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view hideToastActivity];
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)upfiletoQiniu:(NSString *)token image:(UIImage*)image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resq){
        if (info.error == nil) {
            NSString *portraitUrl = [NSString stringWithFormat:@"%@%@",QiniuYunURL,[resq objectForKey:@"key"]];
            [self uploadPortrait:portraitUrl image:image];
        }else{
            [self.view hideToastActivity];
            [self.view makeToast:[info.error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    } option:nil];
    
}


-(void)uploadPortrait:(NSString *)url image:(UIImage *)image
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"chchildavatar",@"action",url,@"number",[YjyxOverallData sharedInstance].parentInfo.pid,@"pid",portraitEntity.cid,@"cid", nil];
    [[YjxService sharedInstance] parentsAboutChildrenSetting:dic withBlock:^(id result,NSError *error){
        [self.view hideToastActivity];
        if (result != nil) {
            if ([[result objectForKey:@"retcode"] integerValue] == 0) {
                NSLog(@"%@",result);
                portraitEntity.childavatar = url;
                [_childrenTab reloadData];
            }else{
                [self.view makeToast:[result objectForKey:@"msg"] duration:1.0 position:SHOW_CENTER complete:nil];
            }
        }else{
            [self.view makeToast:[error description] duration:1.0 position:SHOW_CENTER complete:nil];
        }
    }];
    
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
