//
//  subjectContentCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/12.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChaperContentItem;


@interface subjectContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (assign, nonatomic) NSInteger flag;
@property (strong, nonatomic) ChaperContentItem *item;




//- (void)setSubviewsWithModel:(ChaperContentItem *)model;



@end
