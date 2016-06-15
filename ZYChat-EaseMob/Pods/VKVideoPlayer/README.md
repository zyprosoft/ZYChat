# VKVideoPlayer

![VKVideoPlayer](http://engineering.viki.com/images/blog/video_player_running_man.jpg)

VKVideoPlayer is the same battle tested video player used in our [Viki iOS App](https://itunes.apple.com/app/id445553058?mt=8&&referrer=click%3Dda6fe9d2-66b5-4f5e-a45e-8aa1eb02b82b) enjoyed by millions of users all around the world.

[Read The Intro on Our Engineering Blog](http://engineering.viki.com/blog/2014/a-full-featured-custom-video-player-for-ios-vkvideoplayer/)

Some of the  advance features are:
- Fully customizable UI
- No full screen restrictions (have it any size and position you would like!)
- Display subtitles (SRT supported out of the box)
- Customize subtitles (use CSS for styling courtesy of DTCoreText)
- Supports HTTP Live streaming
- Orientation change support (even when orientation lock is enabled)
- Bulletproof event machine to easily integrate features like video ads
- Lots of delegate callbacks for your own logging requirements

## Usage

To run the Demo project; clone the repo, and run `pod install` from the VKVideoPlayer directory first.
After installed pod, open `VKVideoPlayer.xcworkspace` in Xcode to run Demo Application.

## Installation

VKVideoPlayer is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "VKVideoPlayer", "~> 0.1.1"

## Getting Start
Simple way to play Http Live Streaming contents.

    VKVideoPlayerViewController *viewController = [[VKVideoPlayerViewController alloc] init];
    [self presentModalViewController:viewController animated:YES];
    [viewController playVideoWithStreamURL:[NSURL URLWithString:@"http://content.viki.com/test_ios/ios_240.m3u8"]];

## Customize
### Video Player
It is able to use customized video player view.

    self.player = [[VKVikiVideoPlayer alloc] initWithVideoPlayerView:[[VKVikiVideoPlayer alloc] init]];
    self.player.delegate = self;
    [self.view addSubview:self.player]

Also `VKVideoPlayerView` has simple way for additional control.

    - (void)addSubviewForControl:(UIView *)view;
    - (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView;
    - (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView forOrientation:(UIInterfaceOrientationMask)orientation;

Sample

    // Display newButton when screen is landscape mode.
    [self.player.view addSubviewForControl:newButton toView:self.player.view forOrientation:UIInterfaceOrientationMaskLandscape]



To cofigure VKVideoPlayer, there are some properties.

    @property (nonatomic, assign) BOOL forceRotate;
This property can change behavior of orientation. If UIViewController has only Portrait mode, but it can rotate to Landscape when set it `YES`.

    @property (nonatomic, assign) CGRect portraitFrame;
This property is used when rotate to Portrait by forceRotate. Video player view will be this frame size.

    @property (nonatomic, assign) CGRect landscapeFrame;
This property is used when rotate to Landscape by forceRotate. Video player view will be this frame size.

### Subtitles
To customize subtitles, there are some way.
To change font size, use VKSharedUtility. There are 3 values.

    // value accepts @0, @1, @2 or @3;
    // @0 : Tiny
    // @1 : Medium
    // @2 : Large
    // @3 : Huge
    [VKSharedUtility setValue:@1 forKey:kVKSettingsSubtitleSizeKey];

Or you can override following method to customize caption style.

    - (DTCSSStylesheet*)captionStyleSheet:(NSString*)color {
      float fontSize = 1.3f;
      float shadowSize = 1.0f;

      switch ([[VKSharedUtility setting:kVKSettingsSubtitleSizeKey] integerValue]) {
        case 1:
          fontSize = 1.5f;
          break;
        case 2:
          fontSize = 2.0f;
          shadowSize = 1.2f;
          break;
        case 3:
          fontSize = 3.5f;
          shadowSize = 1.5f;
          break;
      }

      DTCSSStylesheet* stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:[NSString stringWithFormat:@"body{\
        text-align: center;\
        font-size: %fem;\
        font-family: Helvetica Neue;\
        font-weight: bold;\
        color: %@;\
        text-shadow: -%fpx -%fpx %fpx #000, %fpx -%fpx %fpx #000, -%fpx %fpx %fpx #000, %fpx %fpx %fpx #000;\
        vertical-align: bottom;\
        }", fontSize, color, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize]];
      return stylesheet;
    }


### Delegate methods
VKVideoPlayer has a delegate protocol `VKVideoPlayerDelegate`.
You can use it for your application's logging or other controls.
There are all `@optional`.

    - (BOOL)shouldVideoPlayer:(VKVideoPlayer*)videoPlayer changeStateTo:(VKVideoPlayerState)toState;
This method is called before changing state. You can prevent changing state of video player if you return `NO`.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState;
This method is before changing state. also before `-shouldVideoPlayer:changeStateTo:`.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState;
This method is called after changing state.

    - (BOOL)shouldVideoPlayer:(VKVideoPlayer*)videoPlayer startVideo:(id<VKVideoPlayerTrackProtocol>)track;
This method is called before loading video. You can prevent before it makes traffic if video shouldn't play.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer willStartVideo:(id<VKVideoPlayerTrackProtocol>)track;
This method is called before starting video. You cannot stop video here.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didStartVideo:(id<VKVideoPlayerTrackProtocol>)track;
This method is called after starting video.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayFrame:(id<VKVideoPlayerTrackProtocol>)track time:(NSTimeInterval)time lastTime:(NSTimeInterval)lastTime;
This method is called every second during playing video.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track;
This method is called finished to play video. You can start to play next video here.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event;
This method is called when user did some actions.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeSubtitleFrom:(NSString*)fronLang to:(NSString*)toLang;
This method is called when user changed bottom caption language.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeOrientationTo:(UIInterfaceOrientation)orientation;
This method is called before rotating animation.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeOrientationFrom:(UIInterfaceOrientation)orientation;
This method is called after rotating animation.

    - (void)handleErrorCode:(VKVideoPlayerErrorCode)errorCode track:(id<VKVideoPlayerTrackProtocol>)track customMessage:(NSString*)customMessage;
This method is called when ocurred an error.


## Available Subtitle Formats
- SRT

## Requirements

iOS 5.0 or later

## License

VKVideoPlayer is licensed under the Apache License, Version 2.0. See the LICENSE file for more info.
