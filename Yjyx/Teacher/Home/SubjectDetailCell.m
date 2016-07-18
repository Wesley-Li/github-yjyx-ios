//
//  SubjectDetailCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "SubjectDetailCell.h"
#import "MicroSubjectModel.h"

@interface SubjectDetailCell()<UIWebViewDelegate>
// 上移按钮
@property (weak, nonatomic) IBOutlet UIButton *moveUpBtn;
// 下移按钮
@property (weak, nonatomic) IBOutlet UIButton *moveDownBtn;
// 删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deletedBtn;
// 科目类型label
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeLabel;
// 科目的难易程度
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
// 背景view
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *webBgview;



// 包装上下移及删除按钮的view
@property (weak, nonatomic) IBOutlet UIView *btnSetView;
// 上部分view
@property (weak, nonatomic) IBOutlet UIView *topView;
@end
@implementation SubjectDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moveUpBtn.layer.cornerRadius = 5;
    self.moveUpBtn.layer.borderColor = RGBACOLOR(0, 128.0, 255.0, 1).CGColor;
    self.moveUpBtn.layer.borderWidth = 1;
    
    self.moveDownBtn.layer.cornerRadius = 5;
    self.moveDownBtn.layer.borderColor = RGBACOLOR(0, 128.0, 255.0, 1).CGColor;
    self.moveDownBtn.layer.borderWidth = 1;
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.topView addGestureRecognizer:tap];
}
- (void)tap{}

- (void)setModel:(MicroSubjectModel *)model
{
    _model = model;
    self.subjectTypeLabel.text = model.type == 1 ? @"选择题" : @"填空题";
    self.levelLabel.text = model.level;
    
    for (UIView *view in [self.webBgview subviews]) {
        [view removeFromSuperview];
    }
    
    // web赋值
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;
    web.scrollView.scrollEnabled = NO;
    web.delegate = self;
    [self.webBgview addSubview:web];
    
    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", model.content];
    [web loadHTMLString:jsString baseURL:nil];

    if (model.btnIsShow) {
        self.btnSetView.hidden = NO ;
    }else{
        self.btnSetView.hidden = YES;
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
    self.height = frame.size.height + 80;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewHeight" object:self userInfo:nil];
    
}


- (IBAction)moveDownBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(subjectDetailCell:moveDownBtnClick:)]) {
        [self.delegate subjectDetailCell:self moveDownBtnClick:sender];
    }
}
- (IBAction)moveUpBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(subjectDetailCell:moveUpBtnClick:)]) {
        [self.delegate subjectDetailCell:self moveUpBtnClick:sender];
    }
}
- (IBAction)deletedBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(subjectDetailCell:deletedBtnClick:)]) {
        [self.delegate subjectDetailCell:self deletedBtnClick:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
