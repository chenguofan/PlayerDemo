//
//  CGPlayer.h
//  EverpidaTranslationStick
//
//  Created by suhengxian on 2020/10/15.
//  Copyright © 2020 吕金状. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PlayerProtocol <NSObject>

-(instancetype)init;

-(void)playFinished;

-(void)playerCurrentStatus:(AVPlayerStatus)status;

@end

@interface CGPlayer : NSObject
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *item;
@property(nonatomic,weak) id<PlayerProtocol>delegate;

-(void)playWithLocalUrl:(NSString *)path;
-(void)playWithNetUrl:(NSString *)urlStr;

-(void)pause;

-(void)play;



@end

NS_ASSUME_NONNULL_END
