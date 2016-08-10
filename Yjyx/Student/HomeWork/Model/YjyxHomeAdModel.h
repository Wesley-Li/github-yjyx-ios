//
//  YjyxHomeAdModel.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxHomeAdModel : NSObject

@property (strong, nonatomic) NSString *img; // 图片
@property (strong, nonatomic) NSString *detail_page; // 跳转到指定页面

+ (instancetype)homeAdModelWithDict:(NSDictionary *)dict;
@end
