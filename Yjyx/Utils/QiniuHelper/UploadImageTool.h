//
//  UploadImageTool.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

#import <UIKit/UIKit.h>

@interface UploadImageTool : NSObject

/**
 
 *上传图片
 
 *
 
 *@param image需要上传的image
 *@param progress上传进度block
 *@param success成功block返回url地址
 *@param failure失败block
 
 */



+ (void)getQiniuUploadToken:(void(^)(NSString*token))success failure:(void(^)())failure;

+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress success:(void(^)(NSString*url))success failure:(void(^)())failure;

+ (void)uploadImages:(NSArray*)imageArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray*))success failure:(void(^)())failure;

+ (void)uploadImagesWithKeys:(NSDictionary *)imagesDictionary completed:(void(^ _Nonnull)(NSDictionary *_Nullable succeededUrls,NSDictionary *_Nullable failedImages))completion;

@end
