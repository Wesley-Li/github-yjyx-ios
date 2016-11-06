//
//  NotifySoundTool.h
//  Yjyx
//
//  Created by yjyx on 16/9/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

//消息提示工具类
@interface NotifySoundTool : NSObject



/**消息提示音转换*/
+ (NSString *)converNotifySound:(NSString *)soundString;


/**
 消息提示音名称数组
 */
+ (NSArray *)soundNames;

//声音名称转换成文件名称
+ (NSString *)converToFileName:(NSString *)soundName;

/**
  获取对应的音频路径(本地)

 @param soundName 音频的名称

 @return 对应的音频路径
 */
+(NSString *)soundFilePath:(NSString *)soundName;


/**
 * play the remoteAudio(网络)
 * @param url 音频地址
 *
 */
+(void)asyncPlayingWithUrl:(NSString *)url
                 completion:(void(^)(NSError *error))completon;





//播放音频
+(SystemSoundID)playNewMessageSound:(NSString *)filePath;

//振动
+ (void)playVibration;



@end
