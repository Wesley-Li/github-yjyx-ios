//
//  QiniuUploadHelper.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiniuUploadHelper : NSObject

@property(copy,nonatomic)void(^singleSuccessBlock)(NSString*);

@property(copy,nonatomic)void(^singleFailureBlock)();

+ (instancetype)sharedUploadHelper;



@end
