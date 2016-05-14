//
//  PasswordStipulateCheckin.h
//  IM
//
//  Created by 王越 on 15/9/16.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    PasswordOptionNumber = 1 << 0,
    PasswordOptionLower = 1 << 1,
    PasswordOptionUpper = 1 << 2,
    PasswordOptionAlphabets = 1 << 3,
    PasswordOptionSpecialChar = 1 << 4,
    PasswordOptionCanRegister = 1 << 5
}PasswordOption;

@interface PasswordStipulateCheckin : NSObject

@property(nonatomic, assign ,readonly) NSInteger length;
@property(nonatomic, strong ,readonly) NSArray* stipulateOptions;


+ (id)sharedInstance;
- (void)getOptionsWith:(NSString *)str;
- (BOOL)checkPasswordWithText:(NSString *)str;

@end
