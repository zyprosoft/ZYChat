//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerView.h"
#import "VKScrubber.h"
#import <QuartzCore/QuartzCore.h>
#import "DDLog.h"
#import "VKVideoPlayerConfig.h"
#import "VKFoundation.h"
#import "VKScrubber.h"
#import "VKVideoPlayerTrack.h"
#import "UIImage+VKFoundation.h"
#import "VKVideoPlayerSettingsManager.h"

#define PADDING 8

#ifdef DEBUG
  static const int ddLogLevel = LOG_LEVEL_WARN;
#else
  static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface VKVideoPlayerView()
@property (nonatomic, strong) NSMutableArray* customControls;
@property (nonatomic, strong) NSMutableArray* portraitControls;
@property (nonatomic, strong) NSMutableArray* landscapeControls;
@end

@implementation VKVideoPlayerView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.scrubber removeObserver:self forKeyPath:@"maximumValue"];
  [self.rewindButton removeObserver:self forKeyPath:@"hidden"];
  [self.nextButton removeObserver:self forKeyPath:@"hidden"];
}

- (void)initialize {

  self.customControls = [NSMutableArray array];
  self.portraitControls = [NSMutableArray array];
  self.landscapeControls = [NSMutableArray array];
  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
  self.view.frame = self.frame;
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [self addSubview:self.view];
  
  self.titleLabel.font = THEMEFONT(@"fontRegular", DEVICEVALUE(22.0f, 14.0f));
  self.titleLabel.textColor = THEMECOLOR(@"colorFont4");
  self.titleLabel.text = @"";

  self.captionButton.titleLabel.font = THEMEFONT(@"fontRegular", 13.0f);
  [self.captionButton setTitleColor:THEMECOLOR(@"colorFont4") forState:UIControlStateNormal];

  self.videoQualityButton.titleLabel.font = THEMEFONT(@"fontRegular", 13.0f);
  [self.videoQualityButton setTitleColor:THEMECOLOR(@"colorFont4") forState:UIControlStateNormal];
  
  self.currentTimeLabel.font = THEMEFONT(@"fontRegular", DEVICEVALUE(16.0f, 10.0f));
  self.currentTimeLabel.textColor = THEMECOLOR(@"colorFont4");
  self.totalTimeLabel.font = THEMEFONT(@"fontRegular", DEVICEVALUE(16.0f, 10.0f));
  self.totalTimeLabel.textColor = THEMECOLOR(@"colorFont4");
  
  [self.scrubber addObserver:self forKeyPath:@"maximumValue" options:0 context:nil];
  
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(durationDidLoad:) name:kVKVideoPlayerDurationDidLoadNotification object:nil];
  [defaultCenter addObserver:self selector:@selector(scrubberValueUpdated:) name:kVKVideoPlayerScrubberValueUpdatedNotification object:nil];
  
  [self.scrubber addTarget:self action:@selector(updateTimeLabels) forControlEvents:UIControlEventValueChanged];
    
  UIView* overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bottomControlOverlay.frame.size.width, self.bottomControlOverlay.frame.size.height)];
  overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  overlay.backgroundColor = THEMECOLOR(@"colorBackground8");
  overlay.alpha = 0.6f;
  [self.bottomControlOverlay addSubview:overlay];
  [self.bottomControlOverlay sendSubviewToBack:overlay];

  overlay = [[UIView alloc] initWithFrame:self.topControlOverlay.frame];
  overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  overlay.backgroundColor = THEMECOLOR(@"colorBackground8");
  overlay.alpha = 0.6f;
  [self.topControlOverlay addSubview:overlay];
  [self.topControlOverlay sendSubviewToBack:overlay];
  
  [self.captionButton setTitle:[VKSharedVideoPlayerSettingsManager.subtitleLanguageCode uppercaseString] forState:UIControlStateNormal];
  
  [self.videoQualityButton setTitle:[VKSharedVideoPlayerSettingsManager videoQualityShortDescription:[VKSharedVideoPlayerSettingsManager streamKey]] forState:UIControlStateNormal];
  
  self.externalDeviceLabel.adjustsFontSizeToFitWidth = YES;
  
  [self.rewindButton addObserver:self forKeyPath:@"hidden" options:0 context:nil];
  [self.nextButton addObserver:self forKeyPath:@"hidden" options:0 context:nil];
  
  self.fullscreenButton.hidden = NO;  
  
  for (UIButton* button in @[
    self.topPortraitCloseButton
  ]) {
    [button setBackgroundImage:[[UIImage imageWithColor:THEMECOLOR(@"colorBackground8")] imageByApplyingAlpha:0.6f] forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0f;
    button.clipsToBounds = YES;
  }
  
  [self.topPortraitCloseButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  self.playerControlsAutoHideTime = @5;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void) awakeFromNib {
  [super awakeFromNib];
  [self initialize];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma - VKVideoPlayerViewDelegates

- (IBAction)playButtonTapped:(id)sender {

  UIButton* playButton;
  if ([sender isKindOfClass:[UIButton class]]) {
    playButton = (UIButton*)sender;
  }

  if (playButton.selected)  {
    [self.delegate playButtonPressed];
    [self setPlayButtonsSelected:NO];
  } else {
    [self.delegate pauseButtonPressed];
    [self setPlayButtonsSelected:YES];
  }
}

- (IBAction)nextTrackButtonPressed:(id)sender {
  [self.delegate nextTrackButtonPressed];
}

- (IBAction)previousTrackButtonPressed:(id)sender {
  [self.delegate previousTrackButtonPressed];
}

- (IBAction)rewindButtonPressed:(id)sender {
  [self.delegate rewindButtonPressed];
}

- (IBAction)fullscreenButtonTapped:(id)sender {
  self.fullscreenButton.selected = !self.fullscreenButton.selected;
  [self.delegate fullScreenButtonTapped];
}

- (IBAction)captionButtonTapped:(id)sender {
  [self.delegate captionButtonTapped];
}

- (IBAction)videoQualityButtonTapped:(id)sender {
  [self.delegate videoQualityButtonTapped];
}

- (IBAction)doneButtonTapped:(id)sender {
  [self.delegate doneButtonTapped];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == self.scrubber) {
    if ([keyPath isEqualToString:@"maximumValue"]) {
      DDLogVerbose(@"scrubber Value change: %f", self.scrubber.value);
      RUN_ON_UI_THREAD(^{
        [self updateTimeLabels];
      });
    }
  }
  
  if ([object isKindOfClass:[UIButton class]]) {
    UIButton* button = object;
    if ([button isDescendantOfView:self.topControlOverlay]) {
      [self layoutTopControls];
    }
  }
}

- (void)setDelegate:(id<VKVideoPlayerViewDelegate>)delegate {
  _delegate = delegate;
  self.scrubber.delegate = delegate;
}

- (void)durationDidLoad:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  NSNumber* duration = [info objectForKey:@"duration"];
  [self.delegate videoTrack].totalVideoDuration = duration;
  RUN_ON_UI_THREAD(^{
    self.scrubber.maximumValue = [duration floatValue];
    self.scrubber.hidden = NO;
  });
}

- (void)scrubberValueUpdated:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  RUN_ON_UI_THREAD(^{
    DDLogVerbose(@"scrubberValueUpdated: %@", [info objectForKey:@"scrubberValue"]);
    [self.scrubber setValue:[[info objectForKey:@"scrubberValue"] floatValue] animated:YES];
    [self updateTimeLabels];
  });
}

- (void)updateTimeLabels {
  DDLogVerbose(@"Updating TimeLabels: %f", self.scrubber.value);
  
  [self.currentTimeLabel setFrameWidth:100.0f];
  [self.totalTimeLabel setFrameWidth:100.0f];
  
  self.currentTimeLabel.text = [VKSharedUtility timeStringFromSecondsValue:(int)self.scrubber.value];
  [self.currentTimeLabel sizeToFit];
  [self.currentTimeLabel setFrameHeight:CGRectGetHeight(self.bottomControlOverlay.frame)];
  
  self.totalTimeLabel.text = [VKSharedUtility timeStringFromSecondsValue:(int)self.scrubber.maximumValue];
  [self.totalTimeLabel sizeToFit];
  [self.totalTimeLabel setFrameHeight:CGRectGetHeight(self.bottomControlOverlay.frame)];
  
  [self layoutSlider];
}

- (void)layoutSliderForOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
    [self.totalTimeLabel setFrameOriginX:CGRectGetMinX(self.fullscreenButton.frame) - self.totalTimeLabel.frame.size.width];
  } else {
    [self.totalTimeLabel setFrameOriginX:CGRectGetMinX(self.captionButton.frame) - self.totalTimeLabel.frame.size.width - PADDING];
  }

  [self.scrubber setFrameOriginX:self.currentTimeLabel.frame.origin.x + self.currentTimeLabel.frame.size.width + 4];
  [self.scrubber setFrameWidth:self.totalTimeLabel.frame.origin.x - self.scrubber.frame.origin.x - 4];
  [self.scrubber setFrameOriginY:CGRectGetHeight(self.bottomControlOverlay.frame)/2 - CGRectGetHeight(self.scrubber.frame)/2];
}

- (void)layoutSlider {
  [self layoutSliderForOrientation:self.delegate.visibleInterfaceOrientation];
}

- (void)layoutTopControls {
  
  CGFloat rightMargin = CGRectGetMaxX(self.topControlOverlay.frame);
  for (UIView* button in self.topControlOverlay.subviews) {
    if ([button isKindOfClass:[UIButton class]] && button != self.doneButton && !button.hidden) {
      rightMargin = MIN(CGRectGetMinX(button.frame), rightMargin);
    }
  }
  
  [self.titleLabel setFrameWidth:rightMargin - CGRectGetMinX(self.titleLabel.frame) - 20];
}

- (void)setPlayButtonsSelected:(BOOL)selected {
  self.playButton.selected = selected;
  self.bigPlayButton.selected = selected;
}

- (void)setPlayButtonsEnabled:(BOOL)enabled {
  self.playButton.enabled = enabled;
  self.bigPlayButton.enabled = enabled;
}

- (void)setControlsEnabled:(BOOL)enabled {
  
  self.captionButton.enabled = enabled;
  self.videoQualityButton.enabled = enabled;
  self.topSettingsButton.enabled = enabled;
  
  [self setPlayButtonsEnabled:enabled];

  self.previousButton.enabled = enabled && self.delegate.videoTrack.hasPrevious;
  self.nextButton.enabled = enabled && self.delegate.videoTrack.hasNext;
  self.scrubber.enabled = enabled;
  self.rewindButton.enabled = enabled;
  self.fullscreenButton.enabled = enabled;
  
  self.isControlsEnabled = enabled;
  
  NSMutableArray *controlList = self.customControls.mutableCopy;
  [controlList addObjectsFromArray:self.portraitControls];
  [controlList addObjectsFromArray:self.landscapeControls];
  for (UIView *control in controlList) {
    if ([control isKindOfClass:[UIButton class]]) {
      UIButton *button = (UIButton*)control;
      button.enabled = enabled;
    }
  }
}

- (IBAction)handleSingleTap:(id)sender {
  [self setControlsHidden:!self.isControlsHidden];
  if (!self.isControlsHidden) {
    self.controlHideCountdown = [self.playerControlsAutoHideTime integerValue];
  }
  [self.delegate playerViewSingleTapped];
}

- (IBAction)handleSwipeLeft:(id)sender {
  [self.delegate nextTrackBySwipe];
}

- (IBAction)handleSwipeRight:(id)sender {
  [self.delegate previousTrackBySwipe];
}

- (void)setControlHideCountdown:(NSInteger)controlHideCountdown {
  if (controlHideCountdown == 0) {
    [self setControlsHidden:YES];
  } else {
    [self setControlsHidden:NO];
  }
  _controlHideCountdown = controlHideCountdown;
}

- (void)hideControlsIfNecessary {
  if (self.isControlsHidden) return;
  if (self.controlHideCountdown == -1) {
    [self setControlsHidden:NO];
  } else if (self.controlHideCountdown == 0) {
    [self setControlsHidden:YES];
  } else {
    self.controlHideCountdown--;
  }
}

- (void)setControlsHidden:(BOOL)hidden {
  DDLogVerbose(@"Controls: %@", hidden ? @"hidden" : @"visible");

  if (self.isControlsHidden != hidden) {
    self.isControlsHidden = hidden;
    self.controls.hidden = hidden;

    if (UIInterfaceOrientationIsLandscape(self.delegate.visibleInterfaceOrientation)) {
      for (UIView *control in self.landscapeControls) {
        control.hidden = hidden;
      }
    }
    if (UIInterfaceOrientationIsPortrait(self.delegate.visibleInterfaceOrientation)) {
      for (UIView *control in self.portraitControls) {
        control.hidden = hidden;
      }
    }
    for (UIView *control in self.customControls) {
      control.hidden = hidden;
    }
  }
  
  [self layoutTopControls];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isKindOfClass:[VKScrubber class]] ||
      [touch.view isKindOfClass:[UIButton class]]) {
    // prevent recognizing touches on the slider
    return NO;
  }
  return YES;
}

- (void)layoutForOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
    self.topControlOverlay.hidden = YES;
    self.topPortraitControlOverlay.hidden = NO;
    
    [self.buttonPlaceHolderView setFrameOriginY:PADDING/2];
    self.buttonPlaceHolderView.hidden = YES;
    
    self.captionButton.hidden = YES;
    self.videoQualityButton.hidden = YES;
    
    [self.bigPlayButton setFrameOriginY:CGRectGetMinY(self.bottomControlOverlay.frame)/2 - CGRectGetHeight(self.bigPlayButton.frame)/2];
    
    for (UIView *control in self.portraitControls) {
      control.hidden = self.isControlsHidden;
    }
    for (UIView *control in self.landscapeControls) {
      control.hidden = YES;
    }
    
  } else {
    [self.topControlOverlay setFrameOriginY:0.0f];
    self.topControlOverlay.hidden = NO;
    self.topPortraitControlOverlay.hidden = YES;
    
    [self.buttonPlaceHolderView setFrameOriginY:PADDING/2 + CGRectGetMaxY(self.topControlOverlay.frame)];
    self.buttonPlaceHolderView.hidden = NO;
    
    self.captionButton.hidden = NO;
    self.videoQualityButton.hidden = NO;

    [self.bigPlayButton setFrameOriginY:(CGRectGetMinY(self.bottomControlOverlay.frame) - CGRectGetMaxY(self.topControlOverlay.frame))/2 + CGRectGetMaxY(self.topControlOverlay.frame) - CGRectGetHeight(self.bigPlayButton.frame)/2];
    
    for (UIView *control in self.portraitControls) {
      control.hidden = YES;
    }
    for (UIView *control in self.landscapeControls) {
      control.hidden = self.isControlsHidden;
    }
  }
  
  [self layoutTopControls];
  [self layoutSliderForOrientation:interfaceOrientation];
}

- (void)addSubviewForControl:(UIView *)view {
  [self addSubviewForControl:view toView:self];
}
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView {
  [self addSubviewForControl:view toView:parentView forOrientation:UIInterfaceOrientationMaskAll];
}
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView forOrientation:(UIInterfaceOrientationMask)orientation {
  view.hidden = self.isControlsHidden;
  if (orientation == UIInterfaceOrientationMaskAll) {
    [self.customControls addObject:view];
  } else if (orientation == UIInterfaceOrientationMaskPortrait) {
    [self.portraitControls addObject:view];
  } else if (orientation == UIInterfaceOrientationMaskLandscape) {
    [self.landscapeControls addObject:view];
  }
  [parentView addSubview:view];
}
- (void)removeControlView:(UIView*)view {
  [view removeFromSuperview];
  [self.customControls removeObject:view];
  [self.landscapeControls removeObject:view];
  [self.portraitControls removeObject:view];
}

@end
