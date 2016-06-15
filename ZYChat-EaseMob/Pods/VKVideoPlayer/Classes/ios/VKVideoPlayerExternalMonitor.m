//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerExternalMonitor.h"
#import "NSObject+VKFoundation.h"

@implementation VKVideoPlayerExternalMonitor
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)isConnected {return NO;}
- (void)setup {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:UIScreenDidConnectNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:UIScreenDidDisconnectNotification object:nil];
  
  [self updateState];
}
- (void)activate:(VKVideoPlayer *)player {
  _player = player;
  _player.externalMonitor = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:kVKVideoPlayerStateChanged object:nil queue:nil usingBlock:^(NSNotification *note) {
    VKVideoPlayerState oldState = (VKVideoPlayerState)[[note.userInfo valueForKeyPath:@"oldState"] intValue];
    VKVideoPlayerState newState = (VKVideoPlayerState)[[note.userInfo valueForKeyPath:@"newState"] intValue];
    [self changePlayerSteteFrom:oldState to:newState];
  }];
}
- (void)deactivate {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSString*)deviceName {return nil;}
- (void)changePlayerSteteFrom:(VKVideoPlayerState)oldState to:(VKVideoPlayerState)newState {
}

- (void)updateState {
  if ([UIScreen screens].count > 1) {
    self.state = VKVideoPlayerExternalMonitorStateConnected;
  } else {
    self.state = VKVideoPlayerExternalMonitorStateDisconnected;
  }
}

@end
