//
//  SoundChangeViewController.h
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/20.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundChangeViewController : UITableViewController

{
    NSMutableArray *sounds;
    AVAudioPlayer *player;
    NSIndexPath *defaultIndex;
}

@property (strong,nonatomic) NSString *audio;



@end
