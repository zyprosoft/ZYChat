//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKVideoPlayer.h"

@class VKVideoPlayerExternalMonitorProtocol;
@class VKVideoPlayerView;

typedef enum {
  VKVideoPlayerExternalMonitorStateDisconnected,
  VKVideoPlayerExternalMonitorStateConnected,
  VKVideoPlayerExternalMonitorStateActive
} VKVideoPlayerExternalMonitorState;

@protocol VKVideoPlayerExternalMonitorProtocol <NSObject>
@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, weak, readonly) VKVideoPlayer* player;
@property (nonatomic, strong) VKVideoPlayerView* externalView;
@property (nonatomic, assign) VKVideoPlayerExternalMonitorState state;
- (void)setup;
- (void)activate:(VKVideoPlayer*)player;
- (void)deactivate;
- (NSString*)deviceName;
- (void)changePlayerSteteFrom:(VKVideoPlayerState)oldState to:(VKVideoPlayerState)newState;
@end

@interface VKVideoPlayerExternalMonitor : NSObject<VKVideoPlayerExternalMonitorProtocol>
@property (nonatomic, weak, readonly) VKVideoPlayer* player;
@property (nonatomic, assign) VKVideoPlayerExternalMonitorState state;
@property (nonatomic, strong) VKVideoPlayerView* externalView;
@property (nonatomic, strong) UIWindow* window;
@end
