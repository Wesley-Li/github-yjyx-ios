//
//  StuConditionTableViewCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "StuConditionTableViewCell.h"

@interface StuConditionTableViewCell ()

@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation StuConditionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"history1";
    StuConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[StuConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
        
        UILabel *descriLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, viewW - 40, 15)];
        descriLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:descriLabel];
        self.descriptionLabel = descriLabel;
        
        UIView *showView1 = [[UIView alloc] initWithFrame:CGRectMake(20, -10, viewW - 40, 165)];
        [self.contentView addSubview:showView1];
        self.showView1 = showView1;
        
      
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, -6, viewW - 50, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        self.line1 = line1;
        [self.showView1 addSubview:line1];
        
        UIImageView *imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brooch"]];
        self.imageV.frame = CGRectMake(-20, -20, 60, 60);
        [self addSubview:imagev];
        self.imageV = imagev;
        
        UILabel *submitL = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, viewW - 50, 20)];
        self.submitLabel = submitL;
        [self.showView1 addSubview:submitL];
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [moreButton setImage:[UIImage imageNamed:@"list_btn_More"] forState:UIControlStateNormal];
        self.showmoreBtn = moreButton;
        [self.showView1 addSubview:moreButton];
        
        UIView *showWiew2 = [[UIView alloc] init];
        [self.contentView addSubview:showWiew2];
        self.showView2 = showWiew2;
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, viewW - 50, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [self.showView2 addSubview:line2];
        self.line2 = line2;
        
        UILabel *unSubmitL = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, viewW - 50, 20)];
        [self.showView2 addSubview:unSubmitL];
        self.unsubmitLabel = unSubmitL;
        
        
        UIButton *showUnSubmitButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        //        showUnSubmitButton.frame = CGRectMake((viewW - 40 - 50) * 0.5, 130, 50, 30);
        [showUnSubmitButton setImage:[UIImage imageNamed:@"list_btn_More"] forState:UIControlStateNormal];
        //        showUnSubmitButton.backgroundColor=[UIColor redColor];
        [self.showView2 addSubview:showUnSubmitButton];
        self.showUnsubmitBtn = showUnSubmitButton;
        
    }
    
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
