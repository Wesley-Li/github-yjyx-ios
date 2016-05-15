//
//  RegistFinalViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/4/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegistFinalViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UILabel *titleLb;
    IBOutlet UITextField *parentNameText;
    IBOutlet UITextField *parentPasswordText;
    IBOutlet UITextField *relationText;
    IBOutlet UITextField *phoneText;
    IBOutlet UITextField *codeText;
    IBOutlet UIButton *verifyBtn;
    IBOutlet UILabel *timeLb;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ChildrenEntity *childrenEntity;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *verifyCode;
@property (assign,nonatomic) int second;
@end
