//
//  RegistOneViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/4/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistOneViewController : UIViewController<UITextFieldDelegate>
{
    ChildrenEntity *childrenEntity;
    IBOutlet UITextField *codeTextField;
}
@end
