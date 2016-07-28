//
//  GetTaskCell.m
//  Yjyx
//
//  Created by liushaochang on 16/7/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "GetTaskCell.h"
#import "GetTaskModel.h"


@interface GetTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *deliverLabel;
@property (weak, nonatomic) IBOutlet UILabel *endlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImage;

@end

@implementation GetTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setValueWithModel:(GetTaskModel *)model andtip:(NSInteger)tip{

    self.deliverLabel.text = model.delivertime;
    self.endlineLabel.text = [NSString stringWithFormat:@"截止时间:%@", model.finishtime];
    self.descriptionLabel.text = model.descriptionText;
    if (tip == 1) {
        self.endlineLabel.hidden = YES;
        self.indicatorImage.hidden = YES;
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
