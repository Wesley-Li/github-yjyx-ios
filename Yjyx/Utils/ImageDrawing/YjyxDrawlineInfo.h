//
//  YjyxDrawlineInfo.h
//  Yjyx
//
//  Created by liushaochang on 16/7/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YjyxDrawlineInfo : NSObject

@property (nonatomic,strong)NSMutableArray <__kindof NSValue *>*linePoints;//线条所包含的所有点
@property (nonatomic,strong)UIColor *lineColor;//线条的颜色
@property (nonatomic)float lineWidth;//线条的粗细

@end
