//
//  PublishHomeworkViewController.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/4/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "PublishHomeworkViewController.h"

#import "SmartViewController.h"
#import "BookViewController.h"
#import "TestViewController.h"
#import "KnowledgeViewController.h"
#import "WrongSubjectController.h"
#import "PrivateViewController.h"
#import "GradeVerVolItem.h"
#import "ChapterViewController.h"
#import "QuestionPreviewController.h"
#import "QuestionDataBase.h"

@interface PublishHomeworkViewController ()

@property (weak, nonatomic) IBOutlet UILabel *question_countLabel;

@property (weak, nonatomic) IBOutlet UIButton *previewBtn;

@property (nonatomic, strong) NSMutableArray *selectArr;

@end

@implementation PublishHomeworkViewController

- (NSMutableArray *)selectArr {

    if (!_selectArr) {
        self.selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:136/255.0 blue:227/255.0 alpha:1.0];
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navPop)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.title = @"发布作业";
}
- (void)viewWillAppear:(BOOL)animated
{
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tabBar.hidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.tab_bgImage.hidden = NO;
    ((AppDelegate*)SYS_DELEGATE).cusTBViewController.customButton.hidden = NO;
    
    self.selectArr = [[[QuestionDataBase shareDataBase] selectAllQuestion] mutableCopy];
    if (_selectArr.count == 0) {
        
        self.question_countLabel.hidden = YES;
        self.previewBtn.hidden = YES;
        
    }else {
    
        self.question_countLabel.hidden = NO;
        self.previewBtn.hidden = NO;
        self.question_countLabel.layer.cornerRadius = 10;
        self.question_countLabel.layer.masksToBounds = YES;
        self.question_countLabel.text = [NSString stringWithFormat:@"%ld", _selectArr.count];
        
    }
    
    
}
- (void) navPop {

    [self.navigationController popViewControllerAnimated:YES];
}
// 点击智能出题
- (IBAction)handleSmartBtn:(UIButton *)sender {
    
    SmartViewController *smartVC = [[SmartViewController alloc] initWithNibName:@"SmartViewController" bundle:nil];
    smartVC.title = @"智能出题";
    [self.navigationController pushViewController:smartVC animated:YES];
    
}

// 点击教材同步
- (IBAction)handleBookBtn:(UIButton *)sender {
    
    NSString *chapterTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"TeacherPostTitle"];
    NSArray  *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChaperContentPamar"];
    if(chapterTitle != nil){
        
        ChapterViewController *chapterVc = [[ChapterViewController alloc] init];
       
        chapterVc.title1 = chapterTitle;
        chapterVc.gradeid = [arr[1] integerValue];
        chapterVc.verid = [arr[2] integerValue];
        chapterVc.volid = [arr[0] integerValue];
        [self.navigationController pushViewController:chapterVc animated:YES];
    }else{
    BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    bookVC.title = @"教材同步";
    [self.navigationController pushViewController:bookVC animated:YES];
    }
}

// 点击套卷出题
- (IBAction)handleTestBtn:(UIButton *)sender {
    
    TestViewController *testVC = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    testVC.title = @"套卷出题";
    [self.navigationController pushViewController:testVC animated:YES];

}

// 知识点出题
- (IBAction)knowledgeBtn:(UIButton *)sender {
    
    KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc] initWithNibName:@"KnowledgeViewController" bundle:nil];
    knowledgeVC.title = @"知识点出题";
    [self.navigationController pushViewController:knowledgeVC animated:YES];
    
}

// 错题库
- (IBAction)wrongBtn:(UIButton *)sender {
    
    WrongSubjectController *wrongVC = [[WrongSubjectController alloc] initWithNibName:@"WrongSubjectController" bundle:nil];
    wrongVC.title = @"错题榜";
    [self.navigationController pushViewController:wrongVC animated:YES];
    
}


// 点击私有题库
- (IBAction)handlePrivateBtn:(UIButton *)sender {
    
    PrivateViewController *privateVC = [[PrivateViewController alloc] initWithNibName:@"PrivateViewController" bundle:nil];
    privateVC.title = @"私有题库";
    [self.navigationController pushViewController:privateVC animated:YES];
}

// 预览选题
- (IBAction)previewBtnClick:(UIButton *)sender {
    
    QuestionPreviewController *previewVC = [[QuestionPreviewController alloc] init];
    previewVC.selectArr = _selectArr;
    [self.navigationController pushViewController:previewVC animated:YES];
    
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
