//
//  ForgetTwoViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/4/26.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RoleType) {
    RoleTypeParent = 0,
    RoleTypeStudent = 1,
    RoleTypeTeacher = 2,
    
};

@interface ForgetTwoViewController : UIViewController
{
    IBOutlet UILabel *titleLb;

}
@property(nonatomic , strong) UITextField *accountText;
@property(nonatomic , strong) NSString *phoneStr;
@property(nonatomic , strong) NSString *userName;
@property(nonatomic , assign) RoleType roleType;

@end
