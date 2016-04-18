//
//  YjyxSoundViewController.h
//  Yjyx
//
//  Created by zhujianyu on 16/2/25.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol soundSelectDelegate <NSObject>

-(void)selectSoundWith:(NSString *)soundName;

@end

@interface YjyxSoundViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sounds;
    AVAudioPlayer *player;
    NSIndexPath *defaultIndex;
}

@property (strong,nonatomic) NSString *audio;
@property (weak,nonatomic) id<soundSelectDelegate>delegate;

@end

