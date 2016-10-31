//
//  YjyxDoingWorkModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxDoingWorkModel : NSObject

@property (strong, nonatomic) NSNumber *requireprocess; // 0 代表不需要上传解题步骤 1 代表需要上传解题步骤
@property (assign, nonatomic) NSInteger questiontype;  // 1代表选择  2代表填空
@property (strong, nonatomic) NSNumber *blankcount;
@property (strong, nonatomic) NSNumber *choicecount;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *t_id;

@property (strong, nonatomic) NSMutableArray *processImgArr;
@property (strong, nonatomic) NSMutableArray *processAssetArr;
@property (strong, nonatomic) NSMutableArray *processImgUrlArr;
@property (strong, nonatomic) NSMutableArray *isSuccessUrlArr;
@property (strong, nonatomic) NSMutableArray *answerArr;
@property (strong, nonatomic) NSMutableArray *blankfillArr;


@property (assign, nonatomic) NSInteger drainTime; // 消耗的时间
+ (instancetype)doingWorkModelWithDict:(NSDictionary *)dict;
@end
