//
//  WrongSubjectCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongSubjectCell.h"
#import "YjyxWrongSubModel.h"
//#import "WrongDataBase.h"
#import "QuestionDataBase.h"
#import "MicroSubjectModel.h"
@interface WrongSubjectCell()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *wrongTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstant;

@property (weak, nonatomic) IBOutlet UILabel *moreAnswerLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *webBgview;

@end

@implementation WrongSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1;
    
    
    self.collectBtn.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    [self.bottomView addGestureRecognizer:tap];
}
- (void)viewClick
{
    
}
- (void)setWrongSubModel:(YjyxWrongSubModel *)wrongSubModel
{
    _wrongSubModel = wrongSubModel;
    self.wrongTimesLabel.text = wrongSubModel.total_wrong_num;
    self.rightAnswerLabel.text = wrongSubModel.answer;
    
    for (UIView *view in [self.webBgview subviews]) {
        [view removeFromSuperview];
    }
    
    // web赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;
    web.scrollView.scrollEnabled = NO;
    web.delegate = self;
    web.userInteractionEnabled = NO;
    [self.webBgview addSubview:web];

    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", wrongSubModel.content];
    [web loadHTMLString:jsString baseURL:nil];
    
  
    // 判断是否已经被选中
    NSMutableArray *tempArr = [NSMutableArray array];
    if(_flag == 1){
         tempArr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", wrongSubModel.questionid] andQuestionType:[NSString stringWithFormat:@"%ld", wrongSubModel.questiontype] andJumpType:@"2"];
    }else{
        tempArr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", wrongSubModel.questionid] andQuestionType:[NSString stringWithFormat:@"%ld", wrongSubModel.questiontype] andJumpType:@"1"];
    }
    
    if(tempArr.count){
        wrongSubModel.isSelected = YES;
    }else{
        wrongSubModel.isSelected = NO;
    }
    // 判断添加按钮是否处于选中
    if(wrongSubModel.isSelected){
        self.addBtn.selected = YES;
    }else{
        self.addBtn.selected = NO;
    }
    // 判断是否是填空题
    if([wrongSubModel.answer containsString:@"①"]){
        self.loadMoreBtn.hidden = NO;
        NSArray *arr = [wrongSubModel.answer componentsSeparatedByString:@"\n"];
        self.rightAnswerLabel.text = arr[0];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
        [tempArr removeObjectAtIndex:0];
        NSString *tempStr = [tempArr componentsJoinedByString:@"\n"];
        self.moreAnswerLabel.text = tempStr;
        
    }else{
        self.loadMoreBtn.hidden = YES;
    }
    if (_wrongSubModel.isLoadMore) {
        self.bottomHeightConstant.constant = 49 + wrongSubModel.pullHeight;
        self.moreAnswerLabel.hidden = NO;
    }else{
        self.bottomHeightConstant.constant = 49;
        self.moreAnswerLabel.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if (img.width > %f) {\
    img.style.maxWidth = %f; \
    }\
    } \
    }";
    js = [NSString stringWithFormat:js, SCREEN_WIDTH - 40, SCREEN_WIDTH - 40];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    self.height = frame.size.height + 80 + self.bottomHeightConstant.constant;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WrongSubjectCellHeight" object:self userInfo:nil];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (IBAction)collectBtnClick:(id)sender {
}
- (IBAction)addBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.wrongSubModel.isSelected = sender.selected;
    MicroSubjectModel *model = [[MicroSubjectModel alloc] init];
    model.s_id = [NSNumber numberWithInteger:_wrongSubModel.t_id];
    model.type = _wrongSubModel.questiontype;
    model.content = _wrongSubModel.content;
    NSString *str = @"简单";
    if(_wrongSubModel.level == 2){
        str = @"中等";
    }else{
        str = @"较难";
    }
    model.level = str;
    if(sender.selected){
       
        if (_flag == 1) {
            [[QuestionDataBase shareDataBase] insertMirco:model];
        }else{
        [[QuestionDataBase shareDataBase] insertWrong:_wrongSubModel];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUTTON_IS_SELEND" object:nil];
    }else{
        if(_flag == 1){
            [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", _wrongSubModel.questionid] andQuestionType: [NSString stringWithFormat:@"%ld", _wrongSubModel.questiontype] andJumpType:@"2"];
        }else{
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", _wrongSubModel.questionid] andQuestionType: [NSString stringWithFormat:@"%ld", _wrongSubModel.questiontype] andJumpType:@"1"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUTTON_NO_SELEND" object:nil];
    }
    
}
- (IBAction)loadMoreBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _wrongSubModel.isLoadMore = sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadMoreIsClicked" object:nil];
}

@end
