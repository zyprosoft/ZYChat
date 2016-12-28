//
//  GJGCMusicSharePlayer.h
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAudioPlayer.h"

@interface GJGCMusicSharePlayer : NSObject<GJCFAudioPlayerDelegate>

@property (nonatomic,strong)GJCFAudioPlayer *audioPlayer;

@property (nonatomic,strong)NSMutableArray *observers;

#pragma mark - 扩展音乐分享消息

@property (nonatomic,copy)NSString *musicSongName;

@property (nonatomic,copy)NSString *musicSongAuthor;

@property (nonatomic,copy)NSString *musicSongUrl;

@property (nonatomic,copy)NSString *musicSongId;

@property (nonatomic,copy)NSString *musicSongImgUrl;

@property (nonatomic,copy)NSString *musicMsgId;

@property (nonatomic,copy)NSString *musicChatId;

@property (nonatomic,assign)BOOL isPlayingMusic;

+ (GJGCMusicSharePlayer *)sharePlayer;

- (void)shouldStopPlay;

- (void)addPlayObserver:(id<GJCFAudioPlayerDelegate>)observer;

- (void)removePlayObserver:(id<GJCFAudioPlayerDelegate>)observer;

- (void)signOut;

@end
