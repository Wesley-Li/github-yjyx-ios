//
//  UIDevice+Space.m
//  IM
//
//  Created by ballsnow on 16/1/27.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "UIDevice+Space.h"

@implementation UIDevice (Space)

#pragma mark file system -- Thanks Joachim Bean!
- (long long)appSize{
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSArray *bundleArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:bundlePath error:nil];
    long long fileSize = 0;
    
    for (NSString *fileName in bundleArray) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager]attributesOfItemAtPath:[bundlePath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    NSArray *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = documentDirectory[0];
    NSArray *documentDirectoryArray = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:documentDirectoryPath error:nil];
    
    for (NSString *file in documentDirectoryArray) {
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:[documentDirectoryPath stringByAppendingPathComponent:file] error:nil];
        fileSize += [attributes fileSize];
    }
    
    NSArray *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectoryPath = libraryDirectory[0];
    NSArray *libraryDirectoryArray = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:libraryDirectoryPath error:nil];
    
    for (NSString *file in libraryDirectoryArray) {
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:[libraryDirectoryPath stringByAppendingPathComponent:file] error:nil];
        fileSize += [attributes fileSize];
    }
    
    NSString *tmpDirectoryPath = NSTemporaryDirectory();
    NSArray *tmpDirectoryArray = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:tmpDirectoryPath error:nil];
    
    for (NSString *file in tmpDirectoryArray) {
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:[tmpDirectoryPath stringByAppendingPathComponent:file] error:nil];
        fileSize += [attributes fileSize];
    }
    return fileSize;
}
@end
