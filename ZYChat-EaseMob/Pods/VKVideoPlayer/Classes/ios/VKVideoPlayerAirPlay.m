//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerAirPlay.h"
#import "VKVideoPlayerView.h"
#import "VKVideoPlayerLayerView.h"
#import "VKVideoPlayerConfig.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation VKVideoPlayerAirPlay

+ (instancetype)sharedInstance {
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

- (void)dealloc {
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

- (void)setup {
  [super setup];

}

- (UIScreen*)screen {
  NSMutableArray *screens = [UIScreen screens].mutableCopy;
  if (1 < screens.count) {
    [screens removeObject:[UIScreen mainScreen]];
  }
  
  return [screens lastObject];
}

- (BOOL)isConnected {
  return self.state == VKVideoPlayerExternalMonitorStateConnected;
}

- (void)activate:(VKVideoPlayer *)player {
  [super activate:player];
  self.window = [[UIWindow alloc] initWithFrame:[[self screen] bounds]];
  self.window.screen = [self screen];
  self.externalView = [self airPlayerViewWithFrame:self.window.frame];
  [self.window addSubview:self.externalView];
  self.window.hidden = NO;
}

- (void)deactivate {
  [super deactivate];
  [self.externalView removeFromSuperview];
  self.externalView = nil;
  self.window.hidden = YES;
  self.window = nil;
}

- (NSString*)deviceName {
  CFDictionaryRef description;
  UInt32 dataSize = sizeof(description);
  if (AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &description) == kAudioSessionNoError)  {
    CFArrayRef outputs = CFDictionaryGetValue(description, kAudioSession_AudioRouteKey_Outputs);
    if (outputs) {
      if(CFArrayGetCount(outputs) > 0) {
        CFDictionaryRef currentOutput = CFArrayGetValueAtIndex(outputs, 0);
        CFStringRef outputType = CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
        if (CFStringCompare(outputType, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo) {
          NSDictionary *desc = (__bridge NSDictionary *)(currentOutput);
          return [desc objectForKey:@"RouteDetailedDescription_Name"];
        }
      }
    }
  }
  
  return @"Unknown Device";
}

- (void)changePlayerSteteFrom:(VKVideoPlayerState)oldState to:(VKVideoPlayerState)newState {
  switch (newState) {
    case VKVideoPlayerStateContentLoading:
      self.externalView.messageLabel.hidden = YES;
      self.externalView.playerLayerView.hidden = YES;
      [self.externalView.activityIndicator startAnimating];
      break;
    case VKVideoPlayerStateSuspend:
      self.externalView.messageLabel.hidden = NO;
      self.externalView.playerLayerView.hidden = YES;
      [self.externalView.activityIndicator stopAnimating];
      break;
    case VKVideoPlayerStateContentPlaying:
      self.externalView.messageLabel.hidden = YES;
      self.externalView.playerLayerView.hidden = NO;
      [self.externalView.activityIndicator stopAnimating];
      break;
    default:
      break;
  }
}

# pragma mark - Event Machine

- (NSString*)stateDescription:(VKVideoPlayerExternalMonitorState)state {
  switch (state) {
    case VKVideoPlayerExternalMonitorStateActive:
      return @"Active";
      break;
    case VKVideoPlayerExternalMonitorStateConnected:
      return @"Connected";
      break;
    case VKVideoPlayerExternalMonitorStateDisconnected:
      return @"Disconnected";
      break;
  }
}

- (void)setState:(VKVideoPlayerExternalMonitorState)newState {
  
  VKVideoPlayerExternalMonitorState oldState = self.state;
  
  if (oldState == newState) return;
  
  switch (oldState) {
    default:
      break;
  }
  
  DDLogVerbose(@"AIRPLAY: State: %@ -> %@", [self stateDescription:oldState], [self stateDescription:newState]);
  
  [super setState:newState];
//  _state = newState;
  
  switch (newState) {      
    case VKVideoPlayerExternalMonitorStateConnected:
      break;
    case VKVideoPlayerExternalMonitorStateDisconnected:
      [self deactivate];
      break;
    default:
      break;
  }
  
}

- (VKVideoPlayerView*)airPlayerViewWithFrame:(CGRect)frame {
  VKVideoPlayerView* playerView = [[VKVideoPlayerView alloc] initWithFrame:frame];
  playerView.controls.hidden = YES;
  playerView.externalDeviceView.hidden = YES;
  playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  return playerView;
}



@end
