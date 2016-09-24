//
//  MyChildrenTableViewCell.m
//  Yjyx
//
//  Created by zhujianyu on 16/2/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MyChildrenTableViewCell.h"
#import "ChildrenActivity.h"
@interface MyChildrenTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *spendTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@end
@implementation MyChildrenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setChildActivity:(ChildrenActivity *)childActivity
{
    _childActivity = childActivity;
     self.descLabel.text = childActivity.title;
    if ([childActivity.finished integerValue] == 1) {
        self.finishedImage.hidden = NO;
        self.descLabel.textColor = PARENTCOLOR;
        if ([childActivity.task__suggestspendtime isEqual:[NSNull null]] || [childActivity.task__suggestspendtime integerValue] == 0) {
            childActivity.task__suggestspendtime = @30;
        }
        NSInteger time = [childActivity.spendTime integerValue];
        NSString *spendtimeStr = @"";
        if(time < 60){
            spendtimeStr = [NSString stringWithFormat:@"%ld秒", time];
        }else if(time < 60 * 60){
            spendtimeStr = [NSString stringWithFormat:@"%ld分%ld秒", time / 60, time % 60];
        }else{
            spendtimeStr = [NSString stringWithFormat:@"%ld时%ld分%ld秒",time / 3600, (time % 3600)/ 60, (time % 3600) % 60];
        }
        if([childActivity.spendTime integerValue] == 0){
            self.spendTimeLabel.text = [NSString stringWithFormat:@"老师建议完成时间:%@分钟 ", childActivity.task__suggestspendtime];

        }else{
            self.spendTimeLabel.text = [NSString stringWithFormat:@"老师建议完成时间:%@分钟 | 孩子用时:%@", childActivity.task__suggestspendtime, spendtimeStr];
        }
        
        self.spendTimeLabel.hidden = NO;
        self.lineImageView.hidden = NO;
        
    }else{
        self.finishedImage.hidden = YES;
        self.descLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//        self.spendTimeLabel.text = @"";
//        self.spendTimeLabel.hidden = YES;
//        self.lineImageView.hidden = YES;
        if ([childActivity.task__suggestspendtime isEqual:[NSNull null]] || [childActivity.task__suggestspendtime integerValue] == 0) {
            childActivity.task__suggestspendtime = @30;
        }
        self.spendTimeLabel.text = [NSString stringWithFormat:@"老师建议完成时间:%@分钟 ", childActivity.task__suggestspendtime];
    }
    
}
- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= 10;
    frame = rect;
    [super setFrame:frame];
}

@end
