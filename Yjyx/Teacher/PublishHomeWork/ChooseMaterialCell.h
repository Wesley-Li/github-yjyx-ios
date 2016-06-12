//
//  ChooseMaterialCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMaterialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail_label;

@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *selMaterial;

@end
