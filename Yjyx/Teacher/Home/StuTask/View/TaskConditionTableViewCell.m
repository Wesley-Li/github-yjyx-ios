//
//  TaskConditionTableViewCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskConditionTableViewCell.h"
#import "ChoiceModel.h"
#import "BlankFillModel.h"
#import "TCustomView.h"

@interface TaskConditionTableViewCell ()



@end

@implementation TaskConditionTableViewCell

- (NSMutableArray *)choiceArr {

    if (!_choiceArr) {
        self.choiceArr = [NSMutableArray array];
    }
    return _choiceArr;
}

- (NSMutableArray *)blankArr {

    if (!_blankArr) {
        self.blankArr = [NSMutableArray array];
        
    }
    return _blankArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}



- (void)setValuesWithChoiceModelArr:(NSMutableArray *)choiceDataSource {
    
    
    
    

}
- (void)setValuesWithBlankFillModelArr:(NSMutableArray *)blankDataSource {
    /*
    for (BlankFillModel *model in blankDataSource) {
        <#statements#>
    }
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
