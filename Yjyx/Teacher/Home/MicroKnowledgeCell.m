//
//  MicroKnowledgeCell.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "MicroKnowledgeCell.h"
#import "MicroDetailModel.h"
#import "YjyxMicroWorkModel.h"
@interface MicroKnowledgeCell()
@property (weak, nonatomic) IBOutlet UILabel *knowLedgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *knowLabel;
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

- (void)setWorkModel:(YjyxMicroWorkModel *)workModel
{
    _workModel = workModel;
    self.knowLedgeLabel.text = workModel.knowledgedesc;
    if (workModel.knowledgedesc == nil) {
        self.knowLabel.hidden = YES;
    }else{
        self.knowLabel.hidden = NO;
    }
}
@end
