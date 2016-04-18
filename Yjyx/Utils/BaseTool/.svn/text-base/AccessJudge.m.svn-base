//
//  AccessJudge.m
//  IM
//
//  Created by 朱建宇 on 15/5/14.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "AccessJudge.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>

@implementation AccessJudge
+(BOOL)mapAceesJudge
{
    if ([CLLocationManager locationServicesEnabled]!= YES &&[CLLocationManager authorizationStatus] !=kCLAuthorizationStatusAuthorized) {
        return NO;
    }
    return YES;
}


+(BOOL)carmerAccessJudge
{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;

}

+(BOOL)libraryAccessJudge
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted)
    {
        return NO;
    }
    
    return YES;
}

+(BOOL)addressBookAccessJudge
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        
        return NO;
    }
    return YES;
}
@end
