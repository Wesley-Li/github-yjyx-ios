//
//  NSObject+category.h
//  BaseTool
//
//  Created by spinery on 14/10/30.
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

typedef enum FILE_TYPE {
    FILE_TYPE_TXT,
    FILE_TYPE_DOC,
    FILE_TYPE_XLS,
    FILE_TYPE_PPT,
    FILE_TYPE_PDF,
    FILE_TYPE_LOG,
    FILE_TYPE_XML,
    FILE_TYPE_AUDIO,
    FILE_TYPE_IMAGE,
    FILE_TYPE_APK,
    FILE_TYPE_EXE,
    FILE_TYPE_BIN,
    FILE_TYPE_BAT,
    FILE_TYPE_DLL,
    FILE_TYPE_FOLDER,
    FILE_TYPE_UNKONW,
} FILE_TYPE;

typedef enum JSON_TYPE {
    JSON_TYPE_NONJSON,
    JSON_TYPE_ARRAY,
    JSON_TYPE_DICTIONARY,
} JSON_TYPE;

@interface NSObject (category)

/**
 * 对象转换,主要用于链表中value的转换
 * @returned    转换后的值
 */
- (id)transformValue;

/**
 * 返回数组或者链表的count
 * @returned    count值
 */
- (NSInteger)number;

@end

@interface NSString (category)

/**
 * 字符串数字校验
 * @returned    bool值
 */
- (bool)isNumber;

/**
 * 字符串手机号校验
 * @returned    bool值
 */
- (bool)isPhone;

/**
 * 字符串邮箱校验
 * @returned    bool值
 */
- (bool)isEmail;

//URL校验
- (bool)isURL;
/**
 * 字符串邮政编码校验
 * @returned    bool值
 */
- (bool)isZipcode;

/**
 * 字符串身份证校验
 * @returned    bool值
 */
- (bool)isIdentity;

/**
 * 字符串名字校验
 * @returned    bool值
 */
- (bool)isSingle;

/**
 * 字符串中文校验
 * @returned    bool值
 */
- (bool)isChinese;

/**
 *  是否全为空格
 * @returned    bool值
 */
- (bool)isSpace;


/**
 * 字符串空判断
 * @returned    字符串是否为空
 */
- (bool)isEmpty;

/**
 * 字符串json判断
 * @returned    字符串是否为json
 */
- (bool)isJson;


/**
 * 密码是否符合要求强度
 * @returned    密码是否符合要求强度
 */
- (bool)strengthOfPassword;

/**
 * 字符串md5加密
 * @returned    md5加密后的字串
 */
- (NSString*)md5;

/**
 * 字符串base64加密
 * @returned    base64加密后的字串
 */
- (NSString*)base64Encrypt;

/**
 * 字符串base64解密
 * @returned    base64解密后的字串
 */
- (NSString*)base64Decrypt;

/**
 * 字符串des3加解密
 * @returned    des3加解密后的字串
 */
- (NSString*)des3:(CCOperation)descc withPass:(NSString*)pass;

/**
 * url编码
 * @returned    编码后的url字串
 */
-(NSString *)URLEncoding;

/**
 * 字符串首字符
 * @returned    字串串首字母
 */
- (NSString*)indexs;

/**
 * 字符串中是否包含表情
 * @returned    字符串中是否包含表情
 */
- (BOOL)containsEmoji;

/**
 * 文件路径判断文件类型
 * @returned    文件类型枚举
 */
- (FILE_TYPE)fileType;

/**
 * 对关键字进行命中变绿色显示
 * @param       key 关键字
 * @returned    转换后的关键字
 */
- (NSAttributedString*)attributeStringForKey:(NSString*)key;

/**
 * 时间字串转换为时间
 * @param       format 时间格式
 * @param       timeZone 时间转化时区
 * @returned    转换后的时间
 */
- (NSDate*)dateValue:(NSString*)format forTimeZone:(NSTimeZone*)timeZone;

/**
 * 毫秒时间字符串
 * @param       format 时间格式
 * @param       timeZone 时间转化时区
 * @returned    转换后的时间格式字符串
 */
- (NSString*)dateString:(NSString*)format forTimeZone:(NSTimeZone*)timeZone;

/**
 * 秒时间字符串
 * @param       format 时间格式
 * @param       timeZone 时间转化时区
 * @returned    转换后的时间格式字符串
 */
- (NSString*)dateString1:(NSString*)format forTimeZone:(NSTimeZone*)timeZone;

/**
 * 多长时间之前
 * @param       format 时间格式
 * @param       timeZone 时间转化时区
 * @returned    多长时间之前
 */
- (NSString *)dateStringTimeBefore;

/**
 * 判断时间是上午还是下午
 * @param       timeZone 指定时区/为空的话是本地时区
 * @returned    是否上午
 */
- (BOOL)isAm:(NSTimeZone*)timeZone;

/**
 * 返回性别头像
 * @returned 性别头像Image (0 保密，1 男，2女)
 */
- (UIImage*)sexImage;

/**
 * 十进制转化成十六进制字符串
 * @returned    十六进制字符串
 */
- (NSString*)toHex;

/**
 * 十进制数转化成二进制数
 * @returned    二进制字符串
 */
- (NSString*)toBinary;

/**
 * 预登录智能域名
 * @returned    智能域名
 */
- (NSString*)intelligentHost;

/**
 * 随机生成16位密钥
 * @returned    NSString值
 */
+ (NSString *)ret16bitString;

/**
 * 去掉字符串中\n
 * @returned    NSString值
 */
+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr;

@end

@interface NSDate (category)

/**
 * 时间格式化为字串
 * @param       format 时间格式
 * @returned    转换后的字串
 */
- (NSString*)toString:(NSString*)format withTimeZone:(NSTimeZone*)timeZone;

/**
 * 时间的年
 * @returned    日期年的整数
 */
- (NSInteger)year;

/**
 * 时间的月
 * @returned    日期月的整数
 */
- (NSInteger)month;

/**
 * 时间的日
 * @returned    日期日的整数
 */
- (NSInteger)day;

/**
 * 时间的时
 * @returned    日期时的整数
 */
- (NSInteger)hour;

/**
 * 时间的分
 * @returned    日期分的整数
 */
- (NSInteger)minute;

/**
 * 时间的秒
 * @returned    日期秒的整数
 */
- (NSInteger)second;

/**
 * 获取日期是星期几
 * @returned    星期几
 */
- (NSString*)weekDay;

/**
 * 日期日历对象
 * @returned    日期日历对象
 */
- (NSDateComponents*)calender;

/**
 * 比较两个日期大小
 * @returned    比较两个日期大小
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

//返回日期的00:00时间
- (NSDate*)dayForBegin;
//返回日期的23:59时间
- (NSDate*)dayForEnd;
@end

@interface NSData (category)

/** 函数名错误  其实是 AES128
 * 数据AES256加密
 * @param       key 加密key
 * @returned    加密后的数据
 */
- (NSData *)AES256Encrypt:(NSString *)key;

/** 函数名错误  其实是 AES128
 * 数据AES256解密
 * @param       key 解密key
 * @returned    解密后的数据
 */
- (NSData *)AES256Decrypt:(NSString *)key;

@end

@interface Utils : NSObject

//获得设备型号
+ (NSString *)deviceModel;

//设备mac地址
+ (NSString*)deviceMac;

//缩放图片大小适应缩放大小
+ (CGSize)zoomSize:(CGSize)original suit:(CGSize)zoom;

@end

@interface UILabel (Addtions)

//创建Label
+ (UILabel*)labelWithFrame:(CGRect)frame
                 textColor:(UIColor*)color
                      font:(UIFont*)font
                   context:(NSString*)context;

@end


