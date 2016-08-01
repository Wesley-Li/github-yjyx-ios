//
//  PostStudentCell.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/6/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostHomeWorkModel;
@class StudentEntity;
@class StuClassEntity, StuGroupEntity;
@interface PostStudentCell : UITableViewCell


@property (strong, nonatomic) StudentEntity *studentModel;
@property (strong, nonatomic) StuClassEntity *stuClassModel;
@property (strong, nonatomic) StuGroupEntity *stuGroupModel;

@end
