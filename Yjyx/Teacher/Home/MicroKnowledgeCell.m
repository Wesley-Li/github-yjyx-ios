//
//  MicroKnowledgeCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroKnowledgeCell.h"
#import "MicroDetailModel.h"
@interface MicroKnowledgeCell()
@property (weak, nonatomic) IBOutlet UILabel *knowLedgeLabel;

@end
@implementation MicroKnowledgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MicroDetailModel *)model
{
    _model = model;
    self.knowLedgeLabel.text = model.knowledgedesc;
}

@end
