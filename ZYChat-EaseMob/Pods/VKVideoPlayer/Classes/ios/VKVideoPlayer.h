//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKVideoPlayerView.h"
#import "VKVideoPlayerCaption.h"
#import "VKVideoPlayerTrack.h"

typedef enum {
  // The video was flagged as blocked due to licensing restrictions (geo or device).
  kVideoPlayerErrorVideoBlocked = 900,
  
  // There was an error fetching the stream.
  kVideoPlayerErrorFetchStreamError,
  
  // Could not find the stream type for video.
  kVideoPlayerErrorStreamNotFound,
  
  // There was an error loading the video as an asset.
  kVideoPlayerErrorAssetLoadError,
  
  // There was an error loading the video's duration.
  kVideoPlayerErrorDurationLoadError,
  
  // AVPlayer failed to load the asset.
  kVideoPlayerErrorAVPlayerFail,
  
  // AVPlayerItem failed to load the asset.
  kVideoPlayerErrorAVPlayerItemFail,
  
  // Chromecast failed to load the stream.
  kVideoPlayerErrorChromecastLoadFail,
  
  // There was an unknown error.
  kVideoPlayerErrorUnknown,
  
} VKVideoPlayerErrorCode;


typedef enum {
  VKVideoPlayerStateUnknown,
  VKVideoPlayerStateContentLoading,
  VKVideoPlayerStateContentPlaying,
  VKVideoPlayerStateContentPaused,
  VKVideoPlayerStateSuspend,
  VKVideoPlayerStateDismissed,
  VKVideoPlayerStateError
} VKVideoPlayerState;

typedef enum {
  VKVideoPlayerControlEventTapPlayerView,
  VKVideoPlayerControlEventTapNext,
  VKVideoPlayerControlEventTapPrevious,
  VKVideoPlayerControlEventTapDone,
  VKVideoPlayerControlEventTapFullScreen,
  VKVideoPlayerControlEventTapCaption,
  VKVideoPlayerControlEventTapVideoQuality,
  VKVideoPlayerControlEventSwipeNext,
  VKVideoPlayerControlEventSwipePrevious,
} VKVideoPlayerControlEvent;


@class VKVideoPlayer;
@protocol VKVideoPlayerDelegate <NSObject>
@optional
- (BOOL)shouldVideoPlayer:(VKVideoPlayer*)videoPlayer changeStateTo:(VKVideoPlayerState)toState;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState;
- (BOOL)shouldVideoPlayer:(VKVideoPlayer*)videoPlayer startVideo:(id<VKVideoPlayerTrackProtocol>)track;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willStartVideo:(id<VKVideoPlayerTrackProtocol>)track;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didStartVideo:(id<VKVideoPlayerTrackProtocol>)track;

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayFrame:(id<VKVideoPlayerTrackProtocol>)track time:(NSTimeInterval)time lastTime:(NSTimeInterval)lastTime;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeSubtitleFrom:(NSString*)fronLang to:(NSString*)toLang;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeOrientationTo:(UIInterfaceOrientation)orientation;
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeOrientationFrom:(UIInterfaceOrientation)orientation;

- (void)handleErrorCode:(VKVideoPlayerErrorCode)errorCode track:(id<VKVideoPlayerTrackProtocol>)track customMessage:(NSString*)customMessage;
@end


@protocol VKVideoPlayerExternalMonitorProtocol;


@protocol VKPlayer <NSObject>
- (void)play;
- (void)pause;
- (CMTime)currentCMTime;
- (NSTimeInterval)currentItemDuration;
- (void)seekToTimeInSeconds:(float)time completionHandler:(void (^)(BOOL finished))completionHandler;
@end


@interface AVPlayer (VKPlayer)
- (void)seekToTimeInSeconds:(float)time completionHandler:(void (^)(BOOL finished))completionHandler;
- (NSTimeInterval)currentItemDuration;
- (CMTime)currentCMTime;
@end


@interface VKVideoPlayer : NSObject<
VKVideoPlayerViewDelegate
>
@property (nonatomic, strong) VKVideoPlayerView *view;
@property (nonatomic, strong) id<VKVideoPlayerTrackProtocol> track;
@property (nonatomic, weak) id<VKVideoPlayerDelegate> delegate;
@property (nonatomic, assign) VKVideoPlayerState state;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, assign) BOOL playerControlsEnabled;
@property (nonatomic, strong) id<VKPlayer> player;
@property (nonatomic, assign) UIInterfaceOrientation visibleInterfaceOrientation;
@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientations;
@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) id<VKVideoPlayerExternalMonitorProtocol> externalMonitor;

@property (nonatomic, strong, readonly) NSURL* streamURL;
@property (nonatomic, strong) NSString* defaultStreamKey;

@property (nonatomic, assign) CGRect portraitFrame;
@property (nonatomic, assign) CGRect landscapeFrame;
@property (nonatomic, assign) BOOL forceRotate;


- (id)initWithVideoPlayerView:(VKVideoPlayerView*)videoPlayerView;

- (void)seekToLastWatchedDuration;
- (void)seekToTimeInSecond:(float)sec userAction:(BOOL)isUserAction completionHandler:(void (^)(BOOL finished))completionHandler;
- (BOOL)isPlayingVideo;
- (BOOL)isPlayingOnExternalDevice;
- (NSTimeInterval)currentTime;
- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation;

#pragma mark - Error Handling
- (NSString*)videoPlayerErrorCodeToString:(VKVideoPlayerErrorCode)code;

#pragma mark - Resource
- (void)loadVideoWithTrack:(id<VKVideoPlayerTrackProtocol>)track;
- (void)loadVideoWithStreamURL:(NSURL*)streamURL;
- (void)reloadCurrentVideoTrack;
- (VKVideoPlayerView*)activePlayerView;

#pragma mark - Controls
- (void)playContent;
- (void)pauseContent;
- (void)pauseContentWithCompletionHandler:(void (^)())completionHandler;
- (void)pauseContent:(BOOL)isUserAction completionHandler:(void (^)())completionHandler;
- (void)updateTrackControls;

#pragma mark - Captions
- (void)clearCaptions;
- (void)setCaptionToBottom:(id<VKVideoPlayerCaptionProtocol>)caption;
- (void)setCaptionToBottom:(id<VKVideoPlayerCaptionProtocol>)caption playerView:(VKVideoPlayerView*)playerView;
- (void)setCaptionToTop:(id<VKVideoPlayerCaptionProtocol>)caption;
- (void)setCaptionToTop:(id<VKVideoPlayerCaptionProtocol>)caption playerView:(VKVideoPlayerView*)playerView;

- (void)updateCaptionView:(DTAttributedLabel*)captionView caption:(id<VKVideoPlayerCaptionProtocol>)caption playerView:(VKVideoPlayerView*)playerView;
- (void)clearCaptionView:(DTAttributedLabel*)captionView;
@end
