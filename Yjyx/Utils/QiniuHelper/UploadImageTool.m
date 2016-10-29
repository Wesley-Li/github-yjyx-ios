//
//  UploadImageTool.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "UploadImageTool.h"
#import "QiniuUploadHelper.h"


@implementation UploadImageTool

+ (void)getQiniuUploadToken:(void(^)(NSString*token))success failure:(void(^)())failure {
    
    if ([((AppDelegate*)SYS_DELEGATE).role isEqualToString:@"teacher"]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:[BaseURL stringByAppendingString:TEACHER_PIC_SETTING_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (responseObject) {
                NSLog(@"____%@", responseObject);
                success(responseObject[@"uptoken"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            failure();
        }];
        
    }else if ([((AppDelegate*)SYS_DELEGATE).role isEqualToString:@"parents"]) {
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
        [manager GET:[BaseURL stringByAppendingString:PARENTS_GETQINIUTOKEN] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (responseObject) {
//                NSLog(@"++++%@", responseObject);
                success(responseObject[@"uptoken"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            failure();
        }];

    
    }else {
    
        // 留学生端
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"getuploadtoken",@"action",@"img",@"resource_type",nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:[BaseURL stringByAppendingString:STUDENT_PIC_SETTING_CONNECT_GET] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (responseObject) {
//                NSLog(@"++++%@", responseObject);
//                NSLog(@"%@", responseObject[@"reason"]);
                success(responseObject[@"uptoken"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            failure();
        }];
    
    }

    

}

// 单张图片
+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress success:(void(^)(NSString*url))success failure:(void(^)())failure {
    
    [UploadImageTool getQiniuUploadToken:^(NSString *token) {
        
        NSData*data =UIImageJPEGRepresentation(image,0.01);
        
        if(!data) {
            
            if(failure) {
                
                failure();
                
            }
            
            return;
            
        }
        
        
        QNUploadOption*opt = [[QNUploadOption alloc]initWithMime:nil
                              
                                                progressHandler:progress
                              
                                                         params:nil
                              
                                                       checkCrc:NO
                              
                                             cancellationSignal:nil];
        
        QNUploadManager*uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        
        [uploadManager putData:data
         
                           key:nil
         
                         token:token
         
                      complete:^(QNResponseInfo*info,NSString*key,NSDictionary*resp) {
                          
                          if(info.statusCode==200&& resp) {
                              
                              NSString*url= [NSString stringWithFormat:@"%@%@",QiniuYunURL, resp[@"key"]];
                              
                              if(success) {
                                  
                                  success(url);
                                  
                              }
                              
                          }
                          
                          else{
                              
                              if(failure) {
                                  
                                  failure();
                                  
                              }
                              
                          }
                          
                      }option:opt];
        
    }failure:^{
        
    }];
    
}



//上传多张图片
+ (void)uploadImages:(NSArray*)imageArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray*))success failure:(void(^)())failure

{
    
    NSMutableArray*array = [[NSMutableArray alloc]init];
    
//    __block CGFloat totalProgress =0.0f;
//    
//    __block CGFloat partProgress =1.0f / [imageArray count];
    
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper*uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    
    uploadHelper.singleFailureBlock= ^() {
        
        failure();
        
        return;
        
    };
    
    uploadHelper.singleSuccessBlock= ^(NSString*url) {
        
        [array addObject:url];
        NSLog(@"%@", array);
        
//        totalProgress += partProgress;
//        
//        progress(totalProgress);
        
        currentIndex++;
        
        if([array count] == [imageArray count]) {
            
            success([array copy]);
            currentIndex = 0;
            
            return;
            
        }else{
            
            NSLog(@"---%ld",currentIndex);
            
            [UploadImageTool uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            
        }
        
    };
    
    if (imageArray.count != 0) {
        
        [UploadImageTool uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
    }else {
    
        success(nil);
    }
}

//上传多张带Key图片
//imageDictionary格式：{key:image}
//成功上传的图，回传succeededUrls，格式：{key:url}
//失败的图，回传failedImages，格式：{key:image}
//成功和失败的图有可能都存在
+ (void)uploadImagesWithIDs:(NSDictionary *)imageDictionary success:(void(^)(NSDictionary *succeededUrls))success failure:(void(^)(NSDictionary *failedImages))failure {
    
    NSMutableDictionary *succeededUrls = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *failedImages = [[NSMutableDictionary alloc] init];
    
    [UploadImageTool getQiniuUploadToken:^(NSString *token) {
        QNUploadOption *opt = [[QNUploadOption alloc]initWithMime:nil
                                                 progressHandler:^(NSString *key, float percent) {}
                                                          params:nil
                                                        checkCrc:NO
                                              cancellationSignal:nil];
        
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        
        dispatch_queue_t queue = dispatch_queue_create("yjyx.com.uploadImage", DISPATCH_QUEUE_SERIAL);
        dispatch_group_t group = dispatch_group_create();

        [imageDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImage class]]) {
                NSData *data = UIImageJPEGRepresentation((UIImage *)obj,0.01);
                if (data) {
                    dispatch_group_async(group, queue, ^{
                        [uploadManager putData:data
                                           key:nil
                                         token:token
                                      complete:^(QNResponseInfo *info,NSString *key,NSDictionary *resp) {
                                          if (info.statusCode == 200 && resp) {
                                              NSString *url= [NSString stringWithFormat:@"%@%@",QiniuYunURL, resp[@"key"]];
                                              [succeededUrls setObject:url forKey:key];
                                          }
                                          else {
                                              [failedImages setObject:obj forKey:key];
                                          }
                                      }
                                        option:opt
                         ];
                    });
                }
                else{
                    [failedImages setObject:obj forKey:key];
                }
            }
            else{
                [failedImages setObject:obj forKey:key];
            }
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (success) {
                success(succeededUrls);
            }
            if (failure) {
                failure(failedImages);
            }
        });
    }failure:^{
        if (failure) {
            failure(imageDictionary); //无Token, 全部失败
        }
    }];
}


@end
