//
//  AddChildrenViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/16.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddChildrenViewController : BaseViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *codeTextField;
    IBOutlet UILabel *childrenLb;
    IBOutlet UILabel *relationshipLb;
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UITextField *textField4;
    NSString *childrenCid;
    ChildrenEntity *childrenEntity;
}
@property (weak,nonatomic) IBOutlet UIView *parentCodeView;
@property (weak,nonatomic) IBOutlet UIView *parentRegistView;
@end
