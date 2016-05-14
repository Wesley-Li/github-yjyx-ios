//
//  YjxService.h
//  yijiaoyixue
//
//  Created by zhujianyu on 16/2/1.
//  Copyright © 2016年 zhujianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BaseURL @"http://139.196.14.118"
//#define BaseURL @"http://ys.zgyjyx.com"
@interface YjxService : NSObject

//获取实例
+ (instancetype)sharedInstance;


//文件传输接口  青牛云
-(void)getAboutqinniu:(NSDictionary*)params withBlock:(void(^)(id result, NSError *error))block;

-(void)uploadFile:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
家长相关接口
*/
-(void)registcheckcode:(NSDictionary*)params withBlock:(void(^)(id result, NSError *error))block;

-(void)parentsRegist:(NSDictionary*)params withBlock:(void(^)(id result,NSError *error))block;

-(void)parentsLogin:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)parentsAboutChildrenSetting:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))blocK;

-(void)parentsLoginout:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)getChildrenachievement:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)getchildrenActivity:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)getChildrenTaskResult:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)getChildrenPreviewResult:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

//会员中心
-(void)getProductList:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)getsubjectStatus:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)trialProduct:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)purchaseProduct:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

/*
学生相关接口
*/

/*
老师相关接口
*/

@end
