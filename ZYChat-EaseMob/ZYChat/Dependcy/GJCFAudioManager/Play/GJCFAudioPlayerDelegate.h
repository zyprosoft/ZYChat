//
//  GJCFAudioPlayerDelegate.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAudioModel.h"

@class GJCFAudioPlayer;

@protocol GJCFAudioPlayerDelegate <NSObject>

@optional

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didFinishPlayAudio:(GJCFAudioModel *)audioFile;

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay playingProgress:(CGFloat)progressValue;

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay playingProgress:(NSTimeInterval)playCurrentTime duration:(NSTimeInterval)duration;

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didOccusError:(NSError *)error;

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didUpdateSoundMouter:(CGFloat)soundMouter;

@end