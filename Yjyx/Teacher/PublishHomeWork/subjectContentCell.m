//
//  subjectContentCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "subjectContentCell.h"
#import "ChaperContentItem.h"
#import "QuestionDataBase.h"
@interface subjectContentCell()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *webBgView;

@property (weak, nonatomic) IBOutlet UILabel *subjectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLevelLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation subjectContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectBtn.hidden = YES;
    
    self.subjectNumLabel.layer.cornerRadius = 5;
    self.subjectNumLabel.layer.masksToBounds = YES;
    self.subjectNumLabel.backgroundColor = RGBACOLOR(3, 138, 228, 1);
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = RGBACOLOR(140.0, 140.0, 140.0, 1).CGColor;
    
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
    self.height = frame.size.height + 120;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectContentCellHeight" object:self userInfo:nil];

    
    
}




- (void)setItem:(ChaperContentItem *)item
{
    
    for (UIView *view in [self.webBgView subviews]) {
        [view removeFromSuperview];
    }
    _item = item;
    NSString *subjectType = nil;
    subjectType = [item.subject_type isEqualToString:@"1"]?@"选择题":@"填空题";
    self.subjectTypeLabel.text = subjectType;
    NSString *subjectLevel = nil;
    if (item.level == -1) {
        subjectLevel = @"未知";
    }else if (item.level == 1){
        subjectLevel = @"简单";
    }else if(item.level == 2){
        subjectLevel = @"中等";
    }else if(item.level == 3){
        subjectLevel = @"较难";
    }
    self.subjectLevelLabel.text = subjectLevel;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
    web.userInteractionEnabled = NO;
    web.delegate = self;
    web.scrollView.scrollEnabled = NO;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.bounces = NO;

    NSString *jsString = [NSString stringWithFormat:@"<p style=\"word-wrap:break-word; width:SCREEN_WIDTH;\">%@</p>", _item.content_text];
    [web loadHTMLString:jsString baseURL:nil];
    [self.webBgView addSubview:web];

    // 判断是否已经被选中
    NSMutableArray *tempArr = [NSMutableArray array];
    
    if (_flag == 1) {
        NSMutableArray *arr = [[QuestionDataBase shareDataBase] selectAllQuestionWithJumpType:@"2"];
        NSLog(@"%ld------%@---%@", item.t_id, item.subject_type , arr);
         tempArr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", (long)item.t_id] andQuestionType:item.subject_type andJumpType:@"2"];
    }else{
        tempArr = [[QuestionDataBase shareDataBase] selectQuestionByid:[NSString stringWithFormat:@"%ld", (long)item.t_id] andQuestionType:item.subject_type andJumpType:@"1"];
    }
   
    if(tempArr.count){
        item.add = YES;
    }else{
        item.add = NO;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

}

@end
