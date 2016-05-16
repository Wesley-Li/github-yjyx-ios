//
//  AutoLoginViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/19.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoLoginViewController : BaseViewController

/**
 * 自动登录
 */
- (void)autoLoginWithRole:(NSString *)role username:(NSString *)username password:(NSString *)password;

@end
