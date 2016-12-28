//
//  GJCFAudioPlayer.h
//  GJCommonFoundation
//
//  Created by ZYVincent QQ:1003081775 on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GJCFAudioPlayerDelegate.h"
#import "GJCFAudioModel.h"

@interface GJCFAudioPlayer : NSObject

@property (nonatomic,readonly)BOOL isPlaying;

@property (nonatomic,weak)id<GJCFAudioPlayerDelegate> delegate;

@property (nonatomic,assign)CGFloat progress;

- (GJCFAudioModel *)getCurrentPlayingAudioFile;

- (void)playAudioFile:(GJCFAudioModel *)audioFile;

- (void)playAudioFile:(GJCFAudioModel *)audioFile startTime:(NSTimeInterval)sTime;

- (void)playAtDuration:(NSTimeInterval)duration;

- (void)play;

- (void)stop;

- (void)pause;

- (NSTimeInterval)playProgressTime;

- (NSTimeInterval)getLocalWavFileDuration:(NSString *)audioPath;

- (NSInteger)currentPlayAudioFileDuration;

- (NSString *)currentPlayAudioFileLocalPath;


@end
