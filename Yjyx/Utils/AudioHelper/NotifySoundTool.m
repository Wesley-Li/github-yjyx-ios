//
//  NotifySoundTool.m
//  Yjyx
//
//  Created by yjyx on 16/9/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "NotifySoundTool.h"

#import "EMCDDeviceManager.h"





@interface NotifySoundTool()

@end


@implementation NotifySoundTool

+ (NSArray *)soundNames{
    
     NSArray  *sounds = @[@"默认",@"三全音",@"管钟琴",@"玻璃",@"圆号",@"铃音",@"电子乐"];

    return sounds;
}


+ (NSString *)converNotifySound:(NSString *)soundString{
    
    NSArray *soundNames = [self soundNames];
    
    if ([soundString isEqualToString:@"default"]) {
        return soundNames[0];
    }else if ([soundString isEqualToString:@"push1.caf"]) {
        return  soundNames[1];
    }else if ([soundString isEqualToString:@"push2.caf"]){
        
       return  soundNames[2];
    
    }else if ([soundString isEqualToString:@"push3.caf"]){
        
        return  soundNames[3];
        
    }else if ([soundString isEqualToString:@"push4.caf"]){
        return  soundNames[4];
        
    }else if ([soundString isEqualToString:@"push5.caf"]){
        
        return soundNames[5];
    }else if([soundString isEqualToString:@"push6.caf"]){
        
        return soundNames[6];
    }
    return nil;
    
}

 //声音名称转换成文件名称
+ (NSString *)converToFileName:(NSString *)soundName{

    if ([soundName isEqualToString:@"默认"]) {
        return @"default";
    }else if ([soundName isEqualToString:@"三全音"]) {
        return @"push1.caf";
    }else if ([soundName isEqualToString:@"管钟琴"]){
        
        return  @"push2.caf";
        
    }else if ([soundName isEqualToString:@"玻璃"]){
        
        return  @"push3.caf";
        
    }else if ([soundName isEqualToString:@"圆号"]){
        return  @"push4.caf";
        
    }else if ([soundName isEqualToString:@"铃音"]){
        
        return @"push5.caf";
    }else if([soundName isEqualToString:@"电子乐"]){
        
        return @"push6.caf";
    }
    return nil;




}


+(NSString *)soundFilePath:(NSString *)soundName{
    
    NSString * name = [self converToFileName:soundName];
    
    if (name) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        NSLog(@"对应的播放的音频路径为====%@",path);
        return path;
    }
   
       return nil;

}
void NotifySystemSoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}

+(SystemSoundID)playNewMessageSound:(NSString *)filePath
{
    // Path for the audio file
//    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"];
//    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    NSURL *audioPath = [NSURL URLWithString:filePath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(soundID,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          NotifySystemSoundFinishedPlayingCallback, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(soundID);
    
    return soundID;
}


+(void)playVibration

{
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          NotifySystemSoundFinishedPlayingCallback, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}



+(void)asyncPlayingWithUrl:(NSString *)url
                completion:(void(^)(NSError *error))completon {

    NSString *name = [url componentsSeparatedByString:@".com/"][1];
    NSString *mainName = [name componentsSeparatedByString:@".amr"][0];
    NSString *amrPath = [self getPathByFilename:mainName ofType:@"amr"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:amrPath]) {
        // 不存在,下载
        NSURL *URL = [NSURL URLWithString:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:(NSProgress *__autoreleasing  _Nullable * _Nullable)nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            // 返回指定文件路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOADISFINISH" object:nil];
            // 下载完毕.播放
            NSString *voicePath = [filePath path];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
                if (completon) {
                    completon(error);
                }
            }];

        }];
        [downloadTask resume];
        
    }else {
        // 存在,直接播放
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:amrPath completion:^(NSError *error) {
            if (completon) {
                completon(error);
            }
        }];
    }

}

+(NSString *)remoteVoiceFilePath:(NSString *)voiceUrl {

    NSString *name = [voiceUrl componentsSeparatedByString:@".com/"][1];
    NSString *mainName = [name componentsSeparatedByString:@".amr"][0];
    NSString *filePath = [self getPathByFilename:mainName ofType:@"amr"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        

    }
    return filePath;

}

#pragma mark - 生成文件路径
+ (NSString *)getPathByFilename:(NSString *)fileName ofType:(NSString *)type {
    
    // 创建audio文件夹
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *audioPath = [NSString stringWithFormat:@"%@/audio", directory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [[[audioPath stringByAppendingPathComponent: fileName] stringByAppendingPathExtension:type] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return filePath;
}


@end
