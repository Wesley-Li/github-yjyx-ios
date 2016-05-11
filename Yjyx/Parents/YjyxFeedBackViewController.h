//
//  YjyxFeedBackViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicScrollView.h"

@interface YjyxFeedBackViewController : BaseViewController<UIActionSheetDelegate,pickerImageSelect,UIImagePickerControllerDelegate,UINavigationBarDelegate>
{
    DynamicScrollView *dynamicScrollView;
    NSMutableArray *imageUrlAry;
    IBOutlet UIButton *finishBtn;
    IBOutlet UITextView *contentText;
}
@property (strong,nonatomic) UIImagePickerController *picker;

@end