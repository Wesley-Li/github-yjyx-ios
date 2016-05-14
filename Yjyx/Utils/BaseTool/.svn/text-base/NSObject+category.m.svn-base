//
//  NSObject+category.m
//  BaseTool
//
//  Created by spinery on 14/10/30.
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import "NSObject+category.h"

@implementation NSObject(category)

- (id)transformValue
{
    if (!self || [self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)self stringValue];
    }
    if ([self isKindOfClass:[NSString class]] && ([(NSString*)self isEqualToString:@"<null>"] || [(NSString*)self isEqualToString:@"(null)"])) {
        return @"";
    }
    return self;
}

- (NSInteger)number
{
    if([self isKindOfClass:[NSDictionary class]]){
        return [(NSDictionary*)self count];
    }
    if([self isKindOfClass:[NSArray class]]){
        return [(NSArray*)self count];
    }
    return 0;
}

@end

@implementation NSString (category)

- (bool)isNumber
{
    NSString *numberRegex = @"[0-9]+";
    NSPredicate *regexNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [regexNumber evaluateWithObject:self];
}

- (bool)isPhone
{
    /**
     10         * 中国移动：China Mobile
     11         * 134,135,136,137,138,139,150,151,152,157,158,159,147,182,183,184,187,188,178,1705
     12         */
    NSString * CM = @"^1((3[4-9]|5[0127-9]|8[23478]|47|78)[0-9]|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,145,155,156,185,186,176,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[56]|8[56]|76)[0-9]|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,153,180,181,189,1700,177
     22         */
    NSString * CT = @"^1((33|53|8[019]|77)[0-9]|700)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (bool)isEmail
{
    NSString *emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (bool)isURL
{
    NSDataDetector *URLDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [URLDetector matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    return [urlTest evaluateWithObject:self] || ([matches count]>0);
}

- (bool)isZipcode
{
    NSString *zipCodeRegex = @"[1-9]d{5}(?!d)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegex];
    return [emailTest evaluateWithObject:self];
}

- (bool)isIdentity
{
    NSString *identityRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityRegex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (bool)isSingle
{
    NSString *singleRegex = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *singleCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",singleRegex];
    return [singleCardPredicate evaluateWithObject:self];
}

- (bool)isChinese
{
    for(int i=0; i< self.length;i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (bool)isSpace
{
    BOOL isSpace = YES;
    for ( int i = 0; i<self.length; i++) {
        char c = [self characterAtIndex:i];
        if (c  != ' ') {
            isSpace = NO;
            break;
        }
    }
    return isSpace;
}

- (bool)isEmpty
{
    if (self == nil) {
        return YES;
    }
    
    if (self.length == 0) {
        return YES;
    }
    
    if ([self isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([self isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([self isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

- (bool)isJson
{
    return [NSJSONSerialization isValidJSONObject:[self JSONValue]];
}


- (bool)strengthOfPassword
{
    NSString *passRegex = @"^(?=.*[0-9].*)(?=.*[a-zA-Z].*).{8,}$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [passTest evaluateWithObject:self];
}

- (NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSString*)base64Encrypt
{
    return [GTMBase64 encodeBase64String:self];
}

- (NSString*)base64Decrypt
{
    return [GTMBase64 decodeBase64String:self];
}

- (NSString*)des3:(CCOperation)descc withPass:(NSString*)pass
{
    if (pass.isEmpty) {
        return nil;
    }
    if (pass.length <= 8) {
        pass = [pass stringByAppendingString:@"$#365#$*[`@$(#$#36#"];
    }
    const void *bytes;
    size_t byteSize;
    if (descc == kCCDecrypt)//解密
    {
        NSData *data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        byteSize = data.length;
        bytes = data.bytes;
    }else{
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        byteSize = data.length;
        bytes = data.bytes;
    }
    
    size_t movedBytes = 0;
    size_t bufferSize = (byteSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    void *buffer = malloc(bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x0, bufferSize);
    
    const void *vkey = (const void *) [pass UTF8String];
    const void *vi = (const void *) [@"vrvxaIvS" UTF8String];
    CCCryptorStatus ccStatus = CCCrypt(descc,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vi,
                       bytes,
                       byteSize,
                       buffer,
                       bufferSize,
                       &movedBytes);
    
    NSString *result = nil;
    if (ccStatus == kCCSuccess) {
        if (descc == kCCDecrypt){
            result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes]
                                           encoding:NSUTF8StringEncoding];
        }else{
            result = [GTMBase64 stringByEncodingData:[NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes]];
        }
    }
    
    free(buffer);
    return result;
}

-(NSString *)URLEncoding
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*();+$,%#[] "),
                                                              kCFStringEncodingUTF8));
    return result;
}

- (NSString*)indexs
{
    if (!self || [self length] == 0) {
        return @"*";
    }

//    NSString *preString =[NSString stringWithFormat:@"%@",self];
//    
//    if ([[preString substringToIndex:1] compare:@"长"] ==NSOrderedSame)
//    {
//        return @"C";
//    }
//    if ([[preString substringToIndex:1] compare:@"沈"] ==NSOrderedSame)
//    {
//        return @"S";
//    }
//    
//    if ([[preString substringToIndex:1] compare:@"厦"] ==NSOrderedSame)
//    {
//        return @"X";
//    }
//    
//    if ([[preString substringToIndex:1] compare:@"地"] ==NSOrderedSame)
//    {
//        return @"D";
//    }
//    
//    if ([[preString substringToIndex:1] compare:@"重"] ==NSOrderedSame)
//    {
//        return @"C";
//    }
    
    NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        NSString *first = [[ms substringToIndex:1] uppercaseString];
        return first;
    }
    return nil;
}

-(BOOL)containsEmoji {
    __block BOOL returnValue =NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}

- (FILE_TYPE)fileType
{
    if ([self hasSuffix:@".jpg"] || [self hasSuffix:@".JPG"] || [self hasSuffix:@".png"] || [self hasSuffix:@".PNG"]|| [self hasSuffix:@".gif"]|| [self hasSuffix:@".GIF"]) {
        return FILE_TYPE_IMAGE;
    }
    if([self hasSuffix:@".amr"] || [self hasSuffix:@".AMR"]){
        return FILE_TYPE_AUDIO;
    }
    if([self hasSuffix:@".doc"] || [self hasSuffix:@".DOC"] || [self hasSuffix:@".docx"] || [self hasSuffix:@".DOCX"]){
        return FILE_TYPE_DOC;
    }
    if([self hasSuffix:@".xls"] || [self hasSuffix:@".XLS"] || [self hasSuffix:@".xlsx"] || [self hasSuffix:@".XLSX"]){
        return FILE_TYPE_XLS;
    }
    if([self hasSuffix:@".exe"] || [self hasSuffix:@".EXE"]){
        return FILE_TYPE_EXE;
    }
    if([self hasSuffix:@".apk"] || [self hasSuffix:@".APK"]){
        return FILE_TYPE_APK;
    }
    if([self hasSuffix:@".txt"] || [self hasSuffix:@".TXT"] || [self hasSuffix:@".log"]){
        return FILE_TYPE_TXT;
    }
    
    if([self hasSuffix:@".xml"] || [self hasSuffix:@".XML"] || [self hasSuffix:@".xhtml"] || [self hasSuffix:@".XHTML"] || [self hasSuffix:@".htmls"] || [self hasSuffix:@".HTMLS"] || [self hasSuffix:@".html"] || [self hasSuffix:@".HTML"] || [self hasSuffix:@".plist"] || [self hasSuffix:@".PLIST"]){
        return FILE_TYPE_XML;
    }
    if([self hasSuffix:@".pdf"] || [self hasSuffix:@".PDF"]){
        return FILE_TYPE_PDF;
    }
    if([self hasSuffix:@".bin"] || [self hasSuffix:@".BIN"]){
        return FILE_TYPE_BIN;
    }
    if([self hasSuffix:@".pptx"] || [self hasSuffix:@".ppt"] || [self hasSuffix:@".potx"] || [self hasSuffix:@".pot"]){
        return FILE_TYPE_PPT;
    }
    if([self hasSuffix:@".bat"] || [self hasSuffix:@".BAT"]){
        return FILE_TYPE_BAT;
    }
    if([self hasSuffix:@".dll"] || [self hasSuffix:@".DLL"]){
        return FILE_TYPE_DLL;
    }
    if ([self rangeOfString:@"."].location == NSNotFound) {
        return FILE_TYPE_FOLDER;
    }
    return FILE_TYPE_UNKONW;
}

- (NSAttributedString*)attributeStringForKey:(NSString*)key
{
    NSRange keyRange = [self rangeOfString:key options:NSCaseInsensitiveSearch];
    if (keyRange.location == NSNotFound) {
        return [[NSAttributedString alloc] initWithString:self];
    }else{
        NSString *tempString = self;
        if (keyRange.location > 12) {
            tempString = [[NSString stringWithFormat:@"...%@",[self substringFromIndex:keyRange.location - 3]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            keyRange = [tempString rangeOfString:key options:NSCaseInsensitiveSearch];
        }
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:tempString];
        [result addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(98, 159, 40, 1) range:keyRange];
        return result;
    }
}

- (NSDate*)dateValue:(NSString*)format forTimeZone:(NSTimeZone*)timeZone
{
    if (timeZone == nil) {
        timeZone = [NSTimeZone systemTimeZone];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:self];
    if (!date) {
        date = [[NSDate dateWithTimeIntervalSince1970:[self longLongValue] / 1000] dateByAddingTimeInterval:[timeZone secondsFromGMT]];
    }
    return date;
}

- (NSString*)dateString:(NSString*)format forTimeZone:(NSTimeZone*)timeZone
{
    if (timeZone == nil) {
        timeZone = [NSTimeZone systemTimeZone];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:self];
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[self longLongValue] / 1000];
    }
    return [formatter stringFromDate:date];
}

- (NSString*)dateString1:(NSString*)format forTimeZone:(NSTimeZone*)timeZone
{
    if (timeZone == nil) {
        timeZone = [NSTimeZone systemTimeZone];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:self];
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]];
    }
    return [formatter stringFromDate:date];
}

- (NSString *)dateStringTimeBefore
{
    NSString *timeString = @"";
    if ([self longLongValue]/60<1) {
        timeString = [NSString stringWithFormat:@"%lld", [self longLongValue]];
        timeString=[NSString stringWithFormat:@"%@秒", timeString];
    }
    else if ([self longLongValue]/3600<1) {
        timeString = [NSString stringWithFormat:@"%lld", [self longLongValue]/60];
        timeString=[NSString stringWithFormat:@"%@分钟", timeString];
    }
    else if ([self longLongValue]/3600>1&&[self longLongValue]/86400<1) {
        timeString = [NSString stringWithFormat:@"%lld", [self longLongValue]/3600];
        timeString=[NSString stringWithFormat:@"%@小时", timeString];
    }
    else if ([self longLongValue]/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%lld", [self longLongValue]/86400];
        timeString=[NSString stringWithFormat:@"%@天", timeString];
        
    }
    return timeString;
}


- (BOOL)isAm:(NSTimeZone*)timeZone
{
    if (timeZone == nil) {
        timeZone = [NSTimeZone systemTimeZone];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSSS"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:self];
    if (!date) {
        date = [[NSDate dateWithTimeIntervalSince1970:[self longLongValue] / 1000] dateByAddingTimeInterval:[timeZone secondsFromGMT]];
    }
    return date.hour < 18 && date.hour > 6;
}

- (UIImage*)sexImage
{
    switch ([self intValue]) {
        case 0:
            return [UIImage imageNamed:@"sex_secret_nomal_big"];
            break;
        case 1:
            return [UIImage imageNamed:@"sex_male_nomal_big"];
            break;
        case 2:
            return [UIImage imageNamed:@"sex_female_big"];
        default:
            return nil;
    }
}

/**
 * 十进制数转化成十六进制数
 */
- (NSString*)toHex
{
    NSString *hexChar;
    NSString *hex =@"";
    int64_t decimalChar;
    int64_t decimal = [self longLongValue];
    for (int i = 0; i<9; i++) {
        decimalChar = decimal%16;
        decimal = decimal/16;
        switch (decimalChar)
        {
            case 10:
                hexChar =@"A";break;
            case 11:
                hexChar =@"B";break;
            case 12:
                hexChar =@"C";break;
            case 13:
                hexChar =@"D";break;
            case 14:
                hexChar =@"E";break;
            case 15:
                hexChar =@"F";break;
            default:
                hexChar=[[NSString alloc] initWithFormat:@"%lli",decimalChar];
                
        }
        hex = [hexChar stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    return hex;
}

/**
 * 十进制数转化成二进制数
 */
- (NSString *)toBinary
{
    int num = [self intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

/**
 * 预登录智能域名
 */
- (NSString*)intelligentHost
{
    NSMutableString *host = [NSMutableString stringWithCapacity:0];
    //用户未输入http
    if (![self hasPrefix:@"http://"]) {
        [host appendString:@"http://"];
    }
    //用户输入的是企业标识
    if ([self rangeOfString:@"."].location == NSNotFound) {
        [host appendFormat:@"%@.linkdood.cn",self];
    }else{
        [host appendString:self];
    }
    //用户未输入端口号
    if (([[self componentsSeparatedByString:@":"] count] < 3 && [self hasPrefix:@"http://"]) || [[self componentsSeparatedByString:@":"] count] < 2) {
        [host appendString:@":80"];
    }
    //用户未输入后缀
    if (![self hasSuffix:@"/pre"]) {
        [host appendString:@"/pre"];
    }
    return host;
}

/**
 * 随机生成16位密钥
 * @returned    NSString值
 */
+ (NSString *)ret16bitString
{
    int length = 16;
    char data[16];
    for (int i = 0; i <length; i++) {
        switch (rand()%3) {
            case 0:
                data[i] = 'A'+rand()%26;
                break;
            case 1:
                data[i] = 'a'+rand()%26;
                break;
            case 2:
                data[i] = '0'+rand()%10;
                break;
            default:
                break;
        }
    }
    return [[NSString alloc] initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
    
}

+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr{
    NSScanner *scanner = [[NSScanner alloc] initWithString:dataStr];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    NSCharacterSet*newLineAndWhitespaceCharacters = [ NSCharacterSet newlineCharacterSet];
    // 扫描
    while (![scanner isAtEnd])
    {
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@""];
        }
    }
    return result;
}

@end

@implementation NSDate (category)

- (NSString*)toString:(NSString*)format withTimeZone:(NSTimeZone*)timeZone
{
    if (timeZone == nil) {
        timeZone = [NSTimeZone systemTimeZone];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:self];
}

- (NSInteger)year
{
    return [[[self description] substringWithRange:NSMakeRange(0, 4)] integerValue];
}

- (NSInteger)month
{
    return [[[self description] substringWithRange:NSMakeRange(4, 2)] integerValue];
}

- (NSInteger)day
{
    return [[[self description] substringWithRange:NSMakeRange(8, 2)] integerValue];
}

- (NSInteger)hour
{
    return [[[self description] substringWithRange:NSMakeRange(11, 2)] integerValue];
}

- (NSInteger)minute
{
    return [[[self description] substringWithRange:NSMakeRange(14, 2)] integerValue];
}

- (NSInteger)second
{
    return [[[self description] substringWithRange:NSMakeRange(17, 2)] integerValue];
}

- (NSString*)weekDay
{
    NSDateComponents *components = self.calender;
    NSMutableString *week = [NSMutableString stringWithCapacity:0];
    switch (components.weekday)//星期几（注意，周日是“1”，周一是“2”。。。。）
    {
        case 0:
            [week appendString:NSLocalizedString(@"Saturday",nil)];
            break;
        case 1:
            [week appendString:NSLocalizedString(@"Sunday",nil)];
            break;
        case 2:
            [week appendString:NSLocalizedString(@"Monday",nil)];
            break;
        case 3:
            [week appendString:NSLocalizedString(@"Tuesday",nil)];
            break;
        case 4:
            [week appendString:NSLocalizedString(@"Wednesday",nil)];
            break;
        case 5:
            [week appendString:NSLocalizedString(@"Thursday",nil)];
            break;
        case 6:
            [week appendString:NSLocalizedString(@"Friday",nil)];
            break;

    }
    return week;
}

- (NSDateComponents*)calender
{
    return [[NSCalendar currentCalendar] components:(NSEraCalendarUnit
                                                    |NSYearCalendarUnit
                                                    |NSMonthCalendarUnit
                                                    |NSDayCalendarUnit
                                                    |NSHourCalendarUnit
                                                    |NSMinuteCalendarUnit
                                                    |NSSecondCalendarUnit
                                                    |NSWeekCalendarUnit
                                                    |NSWeekdayCalendarUnit
                                                    |NSWeekdayOrdinalCalendarUnit
                                                    |NSQuarterCalendarUnit
                                                    |NSWeekOfMonthCalendarUnit
                                                    |NSWeekOfYearCalendarUnit
                                                    |NSYearForWeekOfYearCalendarUnit
                                                    |NSCalendarCalendarUnit
                                                    |NSTimeZoneCalendarUnit)
                                           fromDate:self];
}

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

//返回日期的00:00时间
- (NSDate*)dayForBegin
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [calendar dateFromComponents:components];
}

//返回日期的23:59时间
- (NSDate*)dayForEnd
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [calendar dateFromComponents:components];
}

@end

@implementation NSData (category)

- (NSData *)AES256Encrypt:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES256Decrypt:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end


@implementation Utils

+ (NSString *)deviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"ios-iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"ios-iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"ios-iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"ios-iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"ios-iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"ios-iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"ios-iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"ios-iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"ios-iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"ios-iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"ios-iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"ios-iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"ios-iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"ios-iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"ios-iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"ios-iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"ios-iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"ios-iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"ios-iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"ios-iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"ios-iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"ios-iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"ios-iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"ios-iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"ios-iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"ios-iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"ios-iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"ios-iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"ios-iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"ios-iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"ios-iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"ios-iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"ios-iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"ios-iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"ios-iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"ios-iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"ios-iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"ios-iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"ios-iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"ios-iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"ios-iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"ios-iPhone Simulator";
    return [@"ios-" stringByAppendingString:platform];
}



+ (CGSize)zoomSize:(CGSize)original suit:(CGSize)zoom
{
    CGFloat scaleW = zoom.width / original.width;
    CGFloat scaleH = zoom.height / original.height;
    if (scaleW >= scaleH) {
        return CGSizeMake(original.width * scaleH, original.height * scaleH);
    }
    return CGSizeMake(original.width * scaleW, original.height * scaleW);
}

@end

@implementation UILabel (Addtions)

+ (UILabel*)labelWithFrame:(CGRect)frame
                 textColor:(UIColor*)color
                      font:(UIFont*)font
                   context:(NSString*)context
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = font;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = context;
    
    return label;
}


@end
