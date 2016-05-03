//
//  ParentModifyPhoneViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/14.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentModifyPhoneViewController : BaseViewController<UITextFieldDelegate>
{
    IBOutlet UILabel *timeLb;
    IBOutlet UITextField *codeText;
    IBOutlet UIButton *verifyBtn;
}
@property(nonatomic, weak) IBOutlet UITextField *phoneTextfield;
@property (assign,nonatomic) int second;
@property (nonatomic, strong) NSTimer *timer;
@end
