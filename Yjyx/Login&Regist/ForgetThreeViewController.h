//
//  ForgetThreeViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetThreeViewController : UIViewController
{
    IBOutlet UILabel *titleLb;
    IBOutlet UITextField *codeText;
    IBOutlet UITextField *newPassWord;
    IBOutlet UITextField *confrimPassWord;
    IBOutlet UILabel *codeLb;
}
@property(nonatomic , strong) NSString *phoneStr;
@end
