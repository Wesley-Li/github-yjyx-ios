//
//  YjxService.h
//  yijiaoyixue
//
//  Created by zhujianyu on 16/2/1.
//  Copyright © 2016年 zhujianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

//开发环境
#define BaseURL @"http://139.196.14.118"
#define QiniuYunURL @"http://7xkxyy.com1.z0.glb.clouddn.com/"
//#define BaseURL @"https://ssl.zgyjyx.com"


//生产环境
//#define BaseURL @"https://www.zgyjyx.com"
//#define QiniuYunURL @"http://cdn-web-img.zgyjyx.com/"
//#define QiniuYunURL @"http://cdn-web-video.zgyjyx.com/"

/**
 * QA环境地址
 * **/
//#define BaseURL @"https://qa.zgyjyx.net"
//#define QiniuYunURL @"http://7xkxyy.com1.z0.glb.clouddn.com/"


// QA2环境地址
//#define BaseURL @"https://njqa.zgyjyx.net"
//#define QiniuYunURL @"http://7xkxyy.com1.z0.glb.clouddn.com/"


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

-(void)parentsLogin:(NSDictionary *)params autoLogin:(BOOL)autoLogin withBlock:(void(^)(id result, NSError *error))block;

-(void)parentsAboutChildrenSetting:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))blocK;

-(void)parentsLoginout:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

-(void)getChildrenachievement:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

//每次登陆异步获取题目统计
-(void)asyncGetChildrenachievement:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

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

/**
 * 发送短信验证码
 */
-(void)getSMSsendcode:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;
/**
 * 验证验证码
 */
-(void)checkOutVerfirycode:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

/**
 * 发送手机验证码至用户
 */
-(void)getRestpasswordSms:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

/**
 * 重置密码信息提交
 */
-(void)restPassWord:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

/**
 * 根据用户名获取手机号
 */
-(void)getUserPhone:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

/**
 * 用户反馈
 */
-(void)feedBack:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;

//获取用户订单
-(void)getOrder:(NSDictionary *)params withBlock:(void(^)(id result,NSError *error))block;



/*
 ******************************学生相关接口************************
 */

/*
 *学生登录接口
 */
- (void)studentLogin:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;

- (void)studentLogin:(NSDictionary *)params autoLogin:(BOOL)autoLogin withBlock:(void(^)(id result, NSError *error))block;

// 学生上传青牛云
-(void)studentUploadFile:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
 ******************************老师相关接口*************************
 */
/*
 *老师登录接口
 */
- (void)teacherLogin:(NSDictionary *)params autoLogin:(BOOL)autoLogin withBlock:(void(^)(id result, NSError *error))block;
/*
 *老师登出接口
 */
- (void)teacherLogout:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
 *老师青牛云,获取Token
 */
- (void)teacherGetAboutqinniu:(NSDictionary*)params withBlock:(void(^)(id result, NSError *error))block;

/*
 *老师青牛云,上传
 */
-(void)teacherUploadFile:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
 *老师获取所有学生列表
 */
//- (void)teacherGetAllStuList:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
 * 获取学生商品列表
 */
-(void)getStudentProductList:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
 * 获取学生学科的状态
 */
-(void)getStudentSubjectStatus:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
 *学生试用某个会员产品
 */
-(void)studentTrialProduct:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
/*
*学生购买某个会员产品
*/
-(void)purchaseStudentProduct:(NSDictionary *)params withBlock:(void(^)(id result, NSError *error))block;
@end
