//
//  YjyxFeedBackViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/5/8.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FEPlaceHolderTextView.h"

@interface YjyxFeedBackViewController : BaseViewController
{
    
    NSMutableArray *imageUrlAry;
    IBOutlet UIButton *finishBtn;
    IBOutlet UIView *feedView;
//    IBOutlet UITextView *contentText;
    FEPlaceHolderTextView *contentText;
}

@end
