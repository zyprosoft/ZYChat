//
//  GJGCMusicSharePlayer.m
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicSharePlayer.h"
#import "GJCFAudioPlayer.h"

@interface GJGCMusicSharePlayer ()


@end

@implementation GJGCMusicSharePlayer

+ (GJGCMusicSharePlayer *)sharePlayer
{
    static GJGCMusicSharePlayer *_sharePlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharePlayer = [[self alloc]init];
    });
    return _sharePlayer;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        /* 语音播放工具 */
        self.audioPlayer = [[GJCFAudioPlayer alloc]init];
        self.audioPlayer.delegate = self;
        
        self.observers = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)shouldStopPlay
{
    if (self.musicMsgId.length == 0) {
        [self.audioPlayer stop];
    }
}

- (void)addPlayObserver:(id<GJCFAudioPlayerDelegate>)observer
{
    if(![observer conformsToProtocol:@protocol(GJCFAudioPlayerDelegate)]){
        return;
    }
    [self.observers addObject:observer];
}

- (void)removePlayObserver:(id<GJCFAudioPlayerDelegate>)observer
{
    [self.observers removeObject:observer];
}

#pragma mark - GJCFAudioPlayer Delegate
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didFinishPlayAudio:(GJCFAudioModel *)audioFile
{
    self.musicChatId = nil;
    self.musicMsgId = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (id<GJCFAudioPlayerDelegate> observer in self.observers) {
            if ([observer respondsToSelector:@selector(audioPlayer:didFinishPlayAudio:)]) {
                [observer audioPlayer:audioPlay didFinishPlayAudio:audioFile];
            }
        }
        
    });
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didOccusError:(NSError *)error
{
    NSLog(@"play error:%@",error);
    self.musicChatId = nil;
    self.musicMsgId = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.audioPlayer stop];
        
        for (id<GJCFAudioPlayerDelegate> observer in self.observers) {
            
            if ([observer respondsToSelector:@selector(audioPlayer:didOccusError:)]) {
                [observer audioPlayer:audioPlay didOccusError:error];
            }
        }
        
    });
    
}
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didUpdateSoundMouter:(CGFloat)soundMouter
{
    for (id<GJCFAudioPlayerDelegate> observer in self.observers) {
        
        if ([observer respondsToSelector:@selector(audioPlayer:didOccusError:)]) {
            [observer audioPlayer:audioPlay didUpdateSoundMouter:soundMouter];
        }
    }
}

- (void)signOut
{
    [self.audioPlayer stop];
    [self.observers removeAllObjects];
}

@end
