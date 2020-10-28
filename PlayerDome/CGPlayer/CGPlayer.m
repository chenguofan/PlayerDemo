//
//  CGPlayer.m
//  EverpidaTranslationStick
//
//  Created by chenguomin on 2020/10/15.
//  Copyright © 2020 chenguomin. All rights reserved.
//

#import "CGPlayer.h"

@implementation CGPlayer

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0;
        _player.automaticallyWaitsToMinimizeStalling = NO;
    }
    return _player;
}

-(void)playWithLocalUrl:(NSString *)path{
    
    NSLog(@"url == %@",path);
    
    NSURL *url = [NSURL fileURLWithPath:path];
    AVAsset *avset = [AVAsset assetWithURL:url];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:avset];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
    
    [self addWatcher];
}

-(void)playWithNetUrl:(NSString *)urlStr{
        
   //2.加载播放资源,替换之前的播放资源
    NSLog(@"url == %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];

    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
    
    //3.添加观察者
     [self addWatcher];
}

-(void)deleteWatcher
{
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)addWatcher{
    [self.player addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playbackFinished:(NSNotification *)noti{
    
    NSLog(@"播放完成");
    [self deleteWatcher];
    
    if (noti && [noti.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playFinished)]) {
            [self.delegate playFinished];
        }
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                break;

            case AVPlayerStatusReadyToPlay:
                [self.player play];
                break;

            case AVPlayerStatusFailed:
                break;
            default:
                break;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerCurrentStatus:)]) {
            [self.delegate playerCurrentStatus:self.player.status];
        }
    }
}

-(void)pause{
    [self.player pause];
}

-(void)play{
    [self.player play];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
