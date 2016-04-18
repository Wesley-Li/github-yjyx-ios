//
//  AccessJudge.h
//  IM
//
//  Created by 朱建宇 on 15/5/14.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessJudge : NSObject
+(BOOL)mapAceesJudge;

+(BOOL)carmerAccessJudge;

+(BOOL)libraryAccessJudge;

+(BOOL)addressBookAccessJudge;
@end
