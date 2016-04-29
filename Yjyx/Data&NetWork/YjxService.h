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

//获取单个会员商品详情
-(void)getOneMemberProduct:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;


//判断是否可以观看解析视频
-(void)isCanLookProduct:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

//发送短信验证码
-(void)getSMSsendcode:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

-(void)checkOutVerfirycode:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

//发送手机验证码至用户
-(void)getRestpasswordSms:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

//重置密码信息提交
-(void)restPassWord:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

//根据用户名获取手机号
-(void)getUserPhone:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;


/*
学生相关接口
*/

/*
老师相关接口
*/

@end
