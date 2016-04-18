//
//  LoginViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/3.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField * uesrNameTF;
@property(weak, nonatomic) IBOutlet UITextField * passWordTF;

@end
