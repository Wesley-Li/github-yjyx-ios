//
//  PasswordStipulateCheckin.m
//  IM
//
//  Created by 王越 on 15/9/16.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "PasswordStipulateCheckin.h"

@interface PasswordStipulateCheckin()

@property(nonatomic, assign ,readwrite) NSInteger length;
@property(nonatomic, strong ,readwrite) NSArray* stipulateOptions;


@end

@implementation PasswordStipulateCheckin{
    NSMutableArray *options;
}



+ (id)sharedInstance{
    static PasswordStipulateCheckin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PasswordStipulateCheckin alloc] init];
    });
    return instance;
}

- (void)getOptionsWith:(NSString *)str{
    str = @"2089"; //暂时屏蔽服务器设置
    self.length = str.integerValue >> 8;
    options = [[NSMutableArray alloc]init];

    for(int i=0;i<6;i++){
        NSNumber *value = [[NSNumber alloc]initWithInteger:str.integerValue & (1 << i)];
        if (value.integerValue != 0){
            [options addObject:value];
        }
    }
    self.stipulateOptions = [[NSArray alloc]initWithArray:options];
}


- (BOOL)checkPasswordWithText:(NSString *)str{
    
    if (self.length > str.length) {
        return NO;
    }
    

    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    BOOL result1 = [self judgeRange:termArray1 Password:str];
    BOOL result2 = [self judgeRange:termArray2 Password:str];
    BOOL result3 = [self judgeRange:termArray3 Password:str];
    BOOL result4 = [self judgeRange:[termArray2 arrayByAddingObjectsFromArray:termArray3] Password:str];
    BOOL result5 = [self outRange:[[termArray2 arrayByAddingObjectsFromArray:termArray3]arrayByAddingObjectsFromArray:termArray1] Password:str];
    BOOL result6 = NO;
    
    for (NSNumber *num in options) {
        NSInteger option = [num integerValue];
        switch (option) {
            case PasswordOptionNumber:
                if (!result1) return NO;
                break;
            case PasswordOptionLower:
                if (!result2) return NO;
                break;
            case PasswordOptionUpper:
                if (!result3) return NO;
                break;
            case PasswordOptionAlphabets:
                if (!result4) return NO;
                break;
            case PasswordOptionSpecialChar:
                if (!result5) return NO;
                break;
            case PasswordOptionCanRegister:
                result6 = YES;
                break;
        }
    }
    if (!result6) return result6;
    return YES;
}

-(BOOL) judgeRange:(NSArray*) termArray Password:(NSString*) password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[termArray count]; i++)
    {
        range = [password rangeOfString:[termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

-(BOOL) outRange:(NSArray*) termArray Password:(NSString*) password
{
    NSRange range;
    BOOL result =NO;
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSString *str in termArray) {
        [string appendString:str];
    }
    for(int i=0; i<password.length; i++)
    {
        NSString *temp = [NSString stringWithFormat:@"%c",[password characterAtIndex:i]];
        range = [string rangeOfString:temp];
        if(range.location == NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

@end
