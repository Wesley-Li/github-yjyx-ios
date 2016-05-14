//
//  ClassCustomTableViewCell.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentEntity;
@interface ClassCustomTableViewCell : UITableViewCell

//@property (nonatomic, strong) StudentEntity *model;

- (void)setValueWithStudentEntity:(StudentEntity *)model;

@end
