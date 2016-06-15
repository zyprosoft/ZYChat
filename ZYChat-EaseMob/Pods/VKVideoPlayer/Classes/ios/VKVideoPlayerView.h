//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "VKScrubber.h"
//#import "VKButtonPanel.h"
#import "VKPickerButton.h"
#import "VKView.h"
#import "VKVideoPlayerConfig.h"

#define kPlayerControlsDisableAutoHide -1

@class VKVideoPlayerTrack;
@class VKVideoPlayerLayerView;

@protocol VKVideoPlayerViewDelegate <VKScrubberDelegate>
@property (nonatomic, readonly) VKVideoPlayerTrack* videoTrack;
@property (nonatomic, readonly) UIInterfaceOrientation visibleInterfaceOrientation;
- (void)fullScreenButtonTapped;
- (void)playButtonPressed;
- (void)pauseButtonPressed;

- (void)nextTrackButtonPressed;
- (void)previousTrackButtonPressed;
- (void)rewindButtonPressed;

- (void)nextTrackBySwipe;
- (void)previousTrackBySwipe;

- (void)captionButtonTapped;
- (void)videoQualityButtonTapped;

- (void)doneButtonTapped;

- (void)playerViewSingleTapped;

- (void)scrubbingBegin;
- (void)scrubbingEnd;

@end

@interface VKVideoPlayerView : UIView
@property (nonatomic, strong) IBOutlet UIView* view;
@property (nonatomic, strong) IBOutlet VKVideoPlayerLayerView* playerLayerView;
@property (nonatomic, strong) IBOutlet UIView* controls;
@property (nonatomic, strong) IBOutlet UIView* bottomControlOverlay;
@property (nonatomic, strong) IBOutlet UIView* topControlOverlay;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet VKPickerButton* captionButton;
@property (nonatomic, strong) IBOutlet VKPickerButton* videoQualityButton;
@property (nonatomic, strong) IBOutlet UIButton* topSettingsButton;

@property (nonatomic, strong) IBOutlet UIButton* playButton;
@property (nonatomic, strong) IBOutlet UIButton* nextButton;
@property (nonatomic, strong) IBOutlet UILabel* currentTimeLabel;
@property (nonatomic, strong) IBOutlet VKScrubber* scrubber;
@property (nonatomic, strong) IBOutlet UILabel* totalTimeLabel;
@property (nonatomic, strong) IBOutlet UIButton* rewindButton;
@property (nonatomic, strong) IBOutlet UIButton* fullscreenButton;

@property (nonatomic, strong) IBOutlet UIButton* previousButton;
@property (nonatomic, strong) IBOutlet UIButton* doneButton;

@property (nonatomic, strong) IBOutlet UILabel* messageLabel;

@property (nonatomic, strong) IBOutlet UIView* buttonPlaceHolderView;

@property (nonatomic, strong) IBOutlet UIButton* bigPlayButton;

@property (nonatomic, strong) IBOutlet DTAttributedLabel* captionTopView;
@property (nonatomic, strong) IBOutlet DTAttributedLabel* captionBottomView;
@property (nonatomic, strong) IBOutlet UIView* captionTopContainerView;

@property (nonatomic, assign) BOOL isControlsEnabled;
@property (nonatomic, assign) BOOL isControlsHidden;

@property (nonatomic, weak) id<VKVideoPlayerViewDelegate> delegate;

@property (nonatomic, assign) NSInteger controlHideCountdown;

@property (nonatomic, strong) IBOutlet UIView* externalDeviceView;
@property (nonatomic, strong) IBOutlet UIImageView* externalDeviceImageView;
@property (nonatomic, strong) IBOutlet UILabel* externalDeviceLabel;

@property (nonatomic, strong) IBOutlet UIView* topPortraitControlOverlay;
@property (nonatomic, strong) IBOutlet UIButton* topPortraitCloseButton;

@property (nonatomic, strong) IBOutlet UIImageView* playerShadow;

@property (nonatomic, strong) NSNumber* playerControlsAutoHideTime;

- (IBAction)fullscreenButtonTapped:(id)sender;
- (IBAction)playButtonTapped:(id)sender;
- (IBAction)nextTrackButtonPressed:(id)sender;
- (IBAction)previousTrackButtonPressed:(id)sender;
- (IBAction)rewindButtonPressed:(id)sender;

- (IBAction)captionButtonTapped:(id)sender;
- (IBAction)videoQualityButtonTapped:(id)sender;

- (IBAction)handleSingleTap:(id)sender;
- (IBAction)handleSwipeLeft:(id)sender;
- (IBAction)handleSwipeRight:(id)sender;

- (void)updateTimeLabels;
- (void)setControlsHidden:(BOOL)hidden;
- (void)setControlsEnabled:(BOOL)enabled;
- (void)hideControlsIfNecessary;

- (void)setPlayButtonsSelected:(BOOL)selected;
- (void)setPlayButtonsEnabled:(BOOL)enabled;

- (void)layoutForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)addSubviewForControl:(UIView *)view;
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView;
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView forOrientation:(UIInterfaceOrientationMask)orientation;
- (void)removeControlView:(UIView*)view;
@end