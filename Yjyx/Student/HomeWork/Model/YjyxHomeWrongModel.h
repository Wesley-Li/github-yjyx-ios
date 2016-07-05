//
//  YjyxHomeWrongModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/5.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxHomeWrongModel : NSObject

@property (strong, nonatomic) NSString *yj_member;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSArray *failedquestions;
@property (strong, nonatomic) NSNumber *subjectid;
@property (strong, nonatomic) NSString *subjectname;

+ (instancetype)homeWrongModelWithDict:(NSDictionary *)dict;
@end
