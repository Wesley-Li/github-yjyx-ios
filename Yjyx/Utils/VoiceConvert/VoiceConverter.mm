//
//  VoiceConverter.m
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
//#import "interf_dec.h"
//#import "dec_if.h"
//#import "interf_enc.h"
#import "amrFileCodec.h"


@implementation VoiceConverter

//转换amr到wav
+ (int)ConvertAmrToWav:(NSString *)aAmrPath wavSavePath:(NSString *)aSavePath{
    
    if (! DecodeAMRFileToWAVEFile([aAmrPath cStringUsingEncoding:NSASCIIStringEncoding], [aSavePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0;
    
    return 1;
}

//转换wav到amr
+ (int)ConvertWavToAmr:(NSString *)aWavPath amrSavePath:(NSString *)aSavePath{
    
    if (! EncodeWAVEFileToAMRFile([aWavPath cStringUsingEncoding:NSASCIIStringEncoding], [aSavePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return 0;
    
    return 1;
}

//获取录音设置
+ (NSDictionary*)GetAudioRecorderSettingDict{
    /**
     *
     AVFormatIDKey  音乐格式，这里采用PCM格式
     AVSampleRateKey 采样率
     AVNumberOfChannelsKey 音乐通道数
     AVLinearPCMBitDepthKey,采样位数 默认 16
     AVLinearPCMIsFloatKey,采样信号是整数还是浮点数
     AVLinearPCMIsBigEndianKey,大端还是小端 是内存的组织方式
     AVEncoderAudioQualityKey,音频编码质量
     
     */
    NSDictionary *recordSetting = @{
                                    AVFormatIDKey               : @(kAudioFormatLinearPCM),
                                    AVSampleRateKey             : @(8000.f),
                                    AVNumberOfChannelsKey       : @(1),
                                    AVLinearPCMBitDepthKey      : @(16),
                                    AVLinearPCMIsNonInterleaved : @NO,
                                    AVLinearPCMIsFloatKey       : @NO,
                                    AVLinearPCMIsBigEndianKey   : @NO
                                    };
    return recordSetting;
}
    
@end
