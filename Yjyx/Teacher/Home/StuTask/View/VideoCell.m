//
//  VideoCell.m
//  Yjyx
//
//  Created by  yjyx-ios1 on 16/5/9.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "VideoCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVideoValueWithDic:(NSDictionary *)dic {

    NSString *urlString = [dic[@"question"] objectForKey:@"videourl"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.contentView.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    self.height = playerLayer.frame.size.height;
    
    [self.contentView.layer addSublayer:playerLayer];
//    [player play];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
