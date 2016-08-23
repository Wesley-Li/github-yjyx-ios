//
//  YjyxYiTeachController.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/1.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxYiTeachController.h"
#import "YiTeachCustomView.h"
#import "YiTeachContentModel.h"
#import "YiTeachChooseCell.h"
#import "YiTeachChapterViewController.h"


@interface YjyxYiTeachController ()

{
    NSArray *defaultImageArr; // 未选择图片
    NSArray *selectedImageArr; // 选定图片
    NSArray *defaultTitleArr; // 默认文字
    NSArray *defaultIndicatorArr;// 未选择箭头
    NSArray *selectedIndicatorArr;// 选择箭头

    NSMutableArray *dataSaveArr;// 保存数据
    BOOL isExpand;
    NSInteger num;
}

@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *tempArr;// 临时数组
@property (strong, nonatomic) NSMutableArray *versionDataSource;// 版本数据源
@property (strong, nonatomic) NSMutableArray *classesDataSource;// 年级数据源
@property (strong, nonatomic) NSMutableArray *subjectDataSource;// 科目数据源
@property (strong, nonatomic) NSMutableArray *bookDataSource;// 册号数据源
@property (strong, nonatomic) NSMutableDictionary *dataSaveDic;// 保存数据
@property (weak, nonatomic) IBOutlet UIButton *startLearnBtn;

@property (strong, nonatomic) NSNumber *version_id;
@property (strong, nonatomic) NSNumber *subject_id;
@property (strong, nonatomic) NSNumber *classes_id;
@property (strong, nonatomic) NSNumber *book_id;

@end

@implementation YjyxYiTeachController

- (NSMutableDictionary *)dataSaveDic {

    if (!_dataSaveDic) {
        self.dataSaveDic = [NSMutableDictionary dictionary];
    }
    return _dataSaveDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"亿教课堂";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.startLearnBtn.hidden = YES;
    
    defaultImageArr = @[@"YiTeach_version", @"YiTeach_subject", @"YiTeach_classes", @"YiTeach_book"];
    selectedImageArr = @[@"YiTeach_version_select", @"YiTeach_subject_select", @"YiTeach_classes_select", @"YiTeach_book_select"];
    defaultIndicatorArr = @[@"YiTeach_indicator_down", @"YiTeach_indicator_up"];
    selectedIndicatorArr = @[@"YiTeach_indicator_down_select", @"YiTeach_indicator_up_select"];
    defaultTitleArr = @[@"版本", @"科目", @"班级", @"册号"];
    
    isExpand = NO;
    self.versionDataSource = [NSMutableArray array];
    self.classesDataSource = [NSMutableArray array];
    self.subjectDataSource = [NSMutableArray array];
    self.bookDataSource = [NSMutableArray array];
    dataSaveArr = [NSMutableArray array];
    
    
    if ([SYS_CACHE objectForKey:@"YiTeachBookInformation"] != NULL) {
        _dataSaveDic = [NSMutableDictionary dictionaryWithDictionary:[SYS_CACHE objectForKey:@"YiTeachBookInformation"]];
        if (_dataSaveDic && [_dataSaveDic allKeys].count == 4) {
            
            for (NSNumber *key in [_dataSaveDic allKeys]) {
                
                if ([key integerValue] == 0) {
                    self.version_id = [_dataSaveDic objectForKey:key][0];
                    
                }else if ([key integerValue] == 1) {
                    
                    self.subject_id = [_dataSaveDic objectForKey:key][0];
                }else if ([key integerValue] == 2) {
                    
                    self.classes_id = [_dataSaveDic objectForKey:key][0];
                }else {
                    
                    self.book_id = [_dataSaveDic objectForKey:key][0];
                    
                }
                
            }
        }

    }
    
    
    
    [self configureTheBookCanBeSelect];
    [self readDataFromNetwork];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAllTheContent) name:@"YiTeachCheck" object:nil];
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YiTeachChooseCell class]) bundle:nil] forCellReuseIdentifier:@"ID"];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

}

#pragma mark - 配置课堂选择项

- (void)configureTheBookCanBeSelect {

    // 初始位置
    NSInteger count = 4;
    CGSize size = CGSizeMake(12, 0);
    CGFloat width = (SCREEN_WIDTH - 24) / count;
    CGFloat height = 78;
    
    // 判断本地是否已保存
    if (_dataSaveDic && [_dataSaveDic allKeys].count == 4) {
        self.startLearnBtn.hidden = NO;
        for (int i = 0; i < count; i++) {
            YiTeachCustomView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YiTeachCustomView class]) owner:self options:nil] objectAtIndex:0];
            customView.tag = 200 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeTheChoose:)];
            [customView addGestureRecognizer:tap];
            [self.BGView addSubview:customView];
            customView.frame = CGRectMake(size.width, size.height, width, height);
            size.width += width;
            
            customView.imageview.image = [UIImage imageNamed:selectedImageArr[i]];
            customView.titleLable.text = [_dataSaveDic objectForKey:[NSString stringWithFormat:@"%d", i]][1];
            customView.titleLable.textColor = STUDENTCOLOR;
            customView.indicatorImageview.image = [UIImage imageNamed:selectedIndicatorArr[0]];
            customView.isSelected = YES;
            
        }

        
    }else {
    
        for (int i = 0; i < count; i++) {
            YiTeachCustomView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YiTeachCustomView class]) owner:self options:nil] objectAtIndex:0];
            customView.tag = 200 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeTheChoose:)];
            [customView addGestureRecognizer:tap];
            [self.BGView addSubview:customView];
            customView.frame = CGRectMake(size.width, size.height, width, height);
            size.width += width;
            
            customView.imageview.image = [UIImage imageNamed:defaultImageArr[i]];
            customView.titleLable.text = defaultTitleArr[i];
            customView.indicatorImageview.image = [UIImage imageNamed:defaultIndicatorArr[0]];
            customView.isSelected = NO;
            
        }

        
    }

    
    
    
    
}

#pragma mark - 网络请求
- (void)readDataFromNetwork {

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"list", @"action", nil];
    [manager GET:[BaseURL stringByAppendingString:@"/api/student/vgsv/"] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if ([responseObject[@"retcode"] isEqual:@0]) {
        
            // 版本
            for (NSArray *versionArr in responseObject[@"version_list"]) {
                YiTeachContentModel *model = [[YiTeachContentModel alloc] init];
                [model initModelWithArray:versionArr];
                [self.versionDataSource addObject:model];
            }
            
            // 科目
            for (NSArray *subjectArr in responseObject[@"subject_list"]) {
                YiTeachContentModel *model = [[YiTeachContentModel alloc] init];
                [model initModelWithArray:subjectArr];
                [self.subjectDataSource addObject:model];
            }
            
            // 年级
            for (NSArray *classesArr in responseObject[@"grade_list"]) {
                YiTeachContentModel *model = [[YiTeachContentModel alloc] init];
                [model initModelWithArray:classesArr];
                [self.classesDataSource addObject:model];
            }
            // 册号
            for (NSArray *bookArr in responseObject[@"vol_list"]) {
                YiTeachContentModel *model = [[YiTeachContentModel alloc] init];
                [model initModelWithArray:bookArr];
                [self.bookDataSource addObject:model];
            }
            
            
        }else {
        
            [self.view makeToast:responseObject[@"msg"] duration:1 position:SHOW_CENTER complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.view makeToast:@"网络出错" duration:1 position:SHOW_CENTER complete:nil];
        
    }];
    
}

#pragma mark - 筛选
- (void)makeTheChoose:(UITapGestureRecognizer *)sender {

    isExpand = YES;
    self.startLearnBtn.hidden = YES;
    YiTeachCustomView *customView = (YiTeachCustomView *)sender.view;
    num = customView.tag - 200;
    self.tempArr = [NSMutableArray arrayWithObjects:_versionDataSource, _subjectDataSource, _classesDataSource, _bookDataSource, nil];
    
    customView.indicatorImageview.image = [UIImage imageNamed:defaultIndicatorArr[1]];
    customView.imageview.image = [UIImage imageNamed:defaultImageArr[num]];
    customView.titleLable.textColor = [UIColor blackColor];
    customView.isSelected = NO;
    
    [self.tempArr addObjectsFromArray:self.tempArr[num]];
    [self.tableview reloadData];
    
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return isExpand ? [self.tempArr[num] count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YiTeachChooseCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    YiTeachContentModel *model = self.tempArr[num][indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YiTeachCustomView *customView = (YiTeachCustomView *)[self.BGView viewWithTag:200 + num];
    YiTeachContentModel *model = self.tempArr[num][indexPath.row];
    switch (num) {
        case 0:
            self.version_id = model.ID;
            [dataSaveArr removeAllObjects];
            [dataSaveArr addObject:model.ID];
            [dataSaveArr addObject:model.content];
            [_dataSaveDic setObject:dataSaveArr forKey:[NSString stringWithFormat:@"%ld", num]];
            [SYS_CACHE setObject:_dataSaveDic forKey:@"YiTeachBookInformation"];
            break;
        case 1:
            self.subject_id = model.ID;
            [dataSaveArr removeAllObjects];
            [dataSaveArr addObject:model.ID];
            [dataSaveArr addObject:model.content];
            [_dataSaveDic setObject:dataSaveArr forKey:[NSString stringWithFormat:@"%ld", num]];
            [SYS_CACHE setObject:_dataSaveDic forKey:@"YiTeachBookInformation"];


            break;
        case 2:
            self.classes_id = model.ID;
            [dataSaveArr removeAllObjects];
            [dataSaveArr addObject:model.ID];
            [dataSaveArr addObject:model.content];
            [_dataSaveDic setObject:dataSaveArr forKey:[NSString stringWithFormat:@"%ld", num]];
            [SYS_CACHE setObject:_dataSaveDic forKey:@"YiTeachBookInformation"];


            break;
        case 3:
            self.book_id = model.ID;
            [dataSaveArr removeAllObjects];
            [dataSaveArr addObject:model.ID];
            [dataSaveArr addObject:model.content];
            [_dataSaveDic setObject:dataSaveArr forKey:[NSString stringWithFormat:@"%ld", num]];
            [SYS_CACHE setObject:_dataSaveDic forKey:@"YiTeachBookInformation"];


            break;
            
        default:
            break;
    }
    
    NSLog(@"######%@", _dataSaveDic);
    // 更新图标,文字,状态
    customView.titleLable.text = model.content;
    customView.titleLable.textColor = STUDENTCOLOR;
    customView.imageview.image = [UIImage imageNamed:selectedImageArr[num]];
    customView.indicatorImageview.image = [UIImage imageNamed:selectedIndicatorArr[0]];
    customView.isSelected = YES;
    
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YiTeachCheck" object:self];
    
    [self.tempArr removeAllObjects];
    isExpand = NO;
    [self.tableview reloadData];
    
}


#pragma mark - notification
- (void)checkAllTheContent {

    _dataSaveDic = [NSMutableDictionary dictionaryWithDictionary:[SYS_CACHE objectForKey:@"YiTeachBookInformation"]];
    if (_dataSaveDic && [_dataSaveDic allKeys].count == 4) {
        self.startLearnBtn.hidden = NO;
    }else {
    
        for (int i = 0; i < 4; i++) {
            YiTeachCustomView *customView = [self.BGView viewWithTag:200 + i];
            if (customView.isSelected) {
                
                if (i== 3) {
                    self.startLearnBtn.hidden = NO;
                    
                }
                
                continue;
            }else {
                
                break;
            }
        }

    
    }
}

#pragma mark - Action
- (IBAction)startLearn:(UIButton *)sender {
    [SYS_CACHE setObject:_dataSaveDic forKey:@"YiTeachBookInformation"];
    NSLog(@"-------%@", _dataSaveDic);
    NSLog(@"%@", [SYS_CACHE objectForKey:@"YiTeachBookInformation"]);
    YiTeachChapterViewController *chapterVC = [[YiTeachChapterViewController alloc] init];
    chapterVC.version_id = self.version_id;
    chapterVC.subject_id = self.subject_id;
    chapterVC.classes_id = self.classes_id;
    chapterVC.book_id = self.book_id;
    [self.navigationController pushViewController:chapterVC animated:YES];
    
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
