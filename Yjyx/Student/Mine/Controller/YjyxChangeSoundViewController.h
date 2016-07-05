//
//  YjyxChangeSoundViewController.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/2.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface YjyxChangeSoundViewController : UITableViewController

{
    NSMutableArray *sounds;
    AVAudioPlayer *player;
    NSIndexPath *defaultIndex;
}

@property (strong,nonatomic) NSString *audio;
@end
