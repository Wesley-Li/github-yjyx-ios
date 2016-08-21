//
//  YiTeachChooseCell.m
//  Yjyx
//
//  Created by liushaochang on 16/8/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YiTeachChooseCell.h"
#import "YiTeachContentModel.h"

@interface YiTeachChooseCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end
@implementation YiTeachChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithModel:(YiTeachContentModel *)model {

    self.contentLabel.text = model.content;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
