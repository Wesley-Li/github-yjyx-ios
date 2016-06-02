//
//  ClassCustomTableViewCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ClassCustomTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StudentEntity.h"

@interface ClassCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@end

@implementation ClassCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setValueWithStudentEntity:(StudentEntity *)model {
    
    NSLog(@"######%@", model.isyjmember);

    [self.picImage setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"hpic_placeholder"]];
    
    if ([model.isyjmember isEqual:[NSNull null]]) {
        self.vipImageView.hidden = YES;
    }else {
    
        if ([model.isyjmember isEqual:@0]) {
            
            self.vipImageView.hidden = YES;
        }else {
            
            self.vipImageView.hidden = NO;
            
        }

    
    }
    
    
    self.nameLabel.text = model.realname;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
