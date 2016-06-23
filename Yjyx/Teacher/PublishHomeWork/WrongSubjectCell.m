//
//  WrongSubjectCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "WrongSubjectCell.h"
#import "YjyxWrongSubModel.h"
#import "RCLabel.h"
//#import "WrongDataBase.h"
#import "QuestionDataBase.h"
@interface WrongSubjectCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *wrongTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstant;

@property (weak, nonatomic) IBOutlet UILabel *moreAnswerLabel;
@property (weak, nonatomic) RCLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation WrongSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1;
    
    NSString *content = _wrongSubModel.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RCLabel *templabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 999)];
    self.contentLabel = templabel;
    templabel.userInteractionEnabled = NO;
    templabel.font = [UIFont systemFontOfSize:14];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    
    templabel.componentsAndPlainText = componentsDS;
    
    self.collectBtn.hidden = YES;
    [self.bgView addSubview:templabel];
    
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
    // RCLabel赋值
    NSString *content = wrongSubModel.content;
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:content];
    self.contentLabel.componentsAndPlainText = componentsDS;
  
    // 判断是否已经被选中
    NSMutableArray *tempArr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", wrongSubModel.questionid] andQuestionType:[NSString stringWithFormat:@"%ld", wrongSubModel.questiontype]];
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
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.frame = _wrongSubModel.cellFrame;
    
}
- (IBAction)collectBtnClick:(id)sender {
}
- (IBAction)addBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.wrongSubModel.isSelected = sender.selected;
    if(sender.selected){
        [[QuestionDataBase shareDataBase] insertWrong:_wrongSubModel];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUTTON_IS_SELEND" object:nil];
    }else{
        [[QuestionDataBase shareDataBase] deleteQuestionByid:[NSString stringWithFormat:@"%ld", _wrongSubModel.questionid] andQuestionType: [NSString stringWithFormat:@"%ld", _wrongSubModel.questiontype]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUTTON_NO_SELEND" object:nil];
    }
    
}
- (IBAction)loadMoreBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _wrongSubModel.isLoadMore = sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadMoreIsClicked" object:nil];
}

@end
