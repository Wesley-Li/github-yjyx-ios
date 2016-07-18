//
//  YjyxWorkDetailModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/6.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxWorkDetailModel : NSObject

@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) NSNumber *showview;
@property (strong, nonatomic) NSString *videourl;
@property (strong, nonatomic) NSString *explanation;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *answer;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) NSInteger choicecount;

+ (instancetype)workDetailModelWithDict:(NSDictionary *)dict;
@end
