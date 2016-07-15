//
//  YjyxMicroWorkModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/7.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxMicroWorkModel : NSObject

@property (strong, nonatomic) NSString *knowledgedesc;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *videoobjlist;

+ (instancetype)microWorkModelWithDict:(NSDictionary *)dict;
@end
