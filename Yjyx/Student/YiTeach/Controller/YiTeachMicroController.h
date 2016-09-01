//
//  YiTeachMicroController.h
//  Yjyx
//
//  Created by liushaochang on 16/8/22.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductEntity;
@interface YiTeachMicroController : UIViewController


@property (strong, nonatomic) NSNumber *version_id;// 版本
@property (strong, nonatomic) NSNumber *subject_id;// 科目
@property (strong, nonatomic) NSNumber *classes_id;// 班级
@property (strong, nonatomic) NSNumber *book_id;// 册号
@property (copy, nonatomic) NSString *textbookunitid;// 节点id

@property (assign, nonatomic) NSInteger openMember;// 1代表开通了会员

@property (weak, nonatomic) IBOutlet UIButton *baseButton;
@property (weak, nonatomic) IBOutlet UIButton *consolidateButton;
@property (weak, nonatomic) IBOutlet UIButton *improveButton;

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSMutableArray *videoURLArr;
@property (nonatomic, copy) NSString *microName;
@property (weak, nonatomic) IBOutlet UIView *videoBgView;
@property (weak, nonatomic) IBOutlet UILabel *microNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *numBtnBgView;
@property (strong, nonatomic) UIButton *preBtn;
@property (nonatomic, strong) NSMutableArray *microArr;// 视频列表，

@property (nonatomic, strong) NSMutableArray *baseQuestionIDList;// 基础题列表
@property (nonatomic, strong) NSMutableArray *consolidateIDList;// 巩固题列表
@property (nonatomic, strong) NSMutableArray *improveIDList;// 提高题列表
@property (nonatomic, strong) NSNumber *showview;// 有无亿教课视频,1有,0没有
@property (nonatomic, strong) NSDictionary *responseObject;// 判断是否需要开通会员,注意，如果学生不是该科目会员，那么这个videoobjlist key不存在，前端判断如果这个key不存在，表示需要会员身份
@property (strong, nonatomic) ProductEntity *entity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, copy) NSString *knowledgedesc;// 知识卡信息
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scroHeightConstraint;


@end
