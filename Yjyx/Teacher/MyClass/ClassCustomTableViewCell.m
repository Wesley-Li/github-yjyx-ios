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


@end

@implementation ClassCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setValueWithStudentEntity:(StudentEntity *)model {

    [self.picImage setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"hpic_placeholder"]];
    
    self.nameLabel.text = model.realname;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
