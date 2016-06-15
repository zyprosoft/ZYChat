//
//  WechatShortVideoController.m
//  SCRecorderPack
//
//  Created by AliThink on 15/8/17.
//  Copyright (c) 2015年 AliThink. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015 AliThink
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WechatShortVideoController.h"
#import "SCRecorder.h"
#import "SCRecordSessionManager.h"
#import "MBProgressHUD.h"
#import "GJCFCachePathManager.h"


@interface WechatShortVideoController () <SCRecorderDelegate, SCAssetExportSessionDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIView *scanPreviewView;
@property (weak, nonatomic) IBOutlet UIView *operatorView;
@property (weak, nonatomic) IBOutlet UIButton *captureTipBtn;
@property (weak, nonatomic) IBOutlet UIView *middleTipView;
@property (weak, nonatomic) IBOutlet UILabel *middleOperatorTip;
@property (weak, nonatomic) IBOutlet UIButton *captureRealBtn;
@property (strong, nonatomic) SCRecorderToolsView *focusView;
@property (weak, nonatomic) IBOutlet UIView *middleProgressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleProgressViewWidthConstraint;
@property (strong, nonatomic) NSTimer *exportProgressBarTimer;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation WechatShortVideoController {
    BOOL captureValidFlag;
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
    NSTimer *longPressTimer;
    
    //Preview
    SCPlayer *_player;
    
    //Video filepath
    NSURL *VIDEO_OUTPUTFILE;
}

@synthesize delegate;

#pragma mark - Do Next Func
- (void)doNextWhenVideoSavedSuccess {
    //file path is VIDEO_OUTPUTFILE
    
}

- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    VIDEO_OUTPUTFILE = [NSURL fileURLWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:VIDEO_DEFAULTNAME]];
    
    captureValidFlag = NO;
    
    [self configRecorder];
    [self configControlStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareSession];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorder stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _recorder.previewView = nil;
    [_player pause];
    _player = nil;
}


#pragma mark - View Config
- (void)configRecorder {
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(30 * VIDEO_MAX_TIME, 30);
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    UIView *previewView = self.scanPreviewView;
    _recorder.previewView = previewView;
    
    self.focusView = [[SCRecorderToolsView alloc] initWithFrame:previewView.bounds];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"WechatShortVideo_scan_focus"];
    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)configControlStyle {
    self.middleProgressView.backgroundColor = NORMAL_TIPCOLOR;
    [self.captureTipBtn setTitleColor:NORMAL_TIPCOLOR forState:UIControlStateNormal];
    self.captureTipBtn.layer.borderColor = [NORMAL_TIPCOLOR CGColor];
    [self.captureTipBtn setTitle:RECORD_BTN_TITLE forState:UIControlStateNormal];
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        _recorder.session = session;
    }
}

- (void)initialProgressView {
    self.middleProgressViewWidthConstraint.constant = self.middleTipView.frame.size.width;
}

- (void)refreshProgressViewLengthByTime:(CMTime)duration {
    CGFloat durationTime = CMTimeGetSeconds(duration);
    CGFloat progressWidthConstant = (VIDEO_MAX_TIME - durationTime) / VIDEO_MAX_TIME * self.middleTipView.frame.size.width;
    self.middleProgressViewWidthConstraint.constant = progressWidthConstant >= 0 ? progressWidthConstant : 0;
}

- (void)showMiddleTipView {
    [self setNormalOperatorTipStyle];
    [self initialProgressView];
    [UIView animateWithDuration:0.2 animations:^{
        self.middleTipView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideMiddleTipView {
    [UIView animateWithDuration:0.2 animations:^{
        self.middleTipView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showCaptureBtn {
    //cancel capture and restore the capture button
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.captureTipBtn.transform = CGAffineTransformIdentity;
        self.captureTipBtn.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideCaptureBtn {
    //scale and hidden
    [UIView animateWithDuration:0.2 animations:^{
        self.captureTipBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.captureTipBtn.alpha = 0;
    } completion:^(BOOL finished) {
                
    }];
}

- (void)setNormalOperatorTipStyle {
    self.middleOperatorTip.textColor = NORMAL_TIPCOLOR;
    self.middleOperatorTip.text = OPERATE_RECORD_TIP;
    self.middleOperatorTip.backgroundColor = [UIColor clearColor];
    self.middleProgressView.backgroundColor = NORMAL_TIPCOLOR;
}

- (void)setReleaseOperatorTipStyle {
    self.middleOperatorTip.textColor = [UIColor whiteColor];
    self.middleOperatorTip.backgroundColor = WARNING_TIPCOLOR;
    self.middleOperatorTip.text = OPERATE_CANCEL_TIP;
    self.middleProgressView.backgroundColor = WARNING_TIPCOLOR;
}

- (void)captureSuccess {
    captureValidFlag = YES;
}



- (void)cancelCaptureWithSaveFlag:(BOOL)saveFlag {
    [_recorder pause:^{
        if (saveFlag) {
            //Preview and save
            [self configPreviewMode];
        } else {
            //retake prepare
            SCRecordSession *recordSession = _recorder.session;
            if (recordSession != nil) {
                _recorder.session = nil;
                if ([[SCRecordSessionManager sharedInstance] isSaved:recordSession]) {
                    [recordSession endSegmentWithInfo:nil completionHandler:nil];
                } else {
                    [recordSession cancelSession:nil];
                }
            }
            [self prepareSession];
        }
    }];
}

#pragma mark - Record finish Preview and save
- (void)configPreviewMode {
    if ([self.scanPreviewView viewWithTag:400]) {
        return;
    }
    
    [self hideCaptureBtn];
    self.captureRealBtn.enabled = NO;
    
    _player = [SCPlayer player];
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.tag = 400;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = self.scanPreviewView.bounds;
    playerView.autoresizingMask = self.scanPreviewView.autoresizingMask;
    [self.scanPreviewView addSubview:playerView];
    _player.loopEnabled = YES;
    
    [_player setItemByAsset:_recorder.session.assetRepresentingSegments];
    [_player play];
    
    UIView *videoOperateView = [[UIView alloc] init];
    videoOperateView.alpha = 0;
    videoOperateView.tag = 400;
    videoOperateView.frame = CGRectMake(self.operatorView.frame.size.width / 2.0 - 100, self.operatorView.frame.size.height/ 2.0 - 65, 200, 130);
    videoOperateView.backgroundColor = [UIColor clearColor];
    
    UIButton *videoConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    videoConfirmBtn.frame = CGRectMake(0, 0, videoOperateView.frame.size.width, 50);
    videoConfirmBtn.layer.cornerRadius = 25;
    videoConfirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [videoConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [videoConfirmBtn setTitle:SAVE_BTN_TITLE forState:UIControlStateNormal];
    videoConfirmBtn.layer.backgroundColor = [NORMAL_TIPCOLOR CGColor];
    [videoConfirmBtn addTarget:self action:@selector(saveCapture) forControlEvents:UIControlEventTouchUpInside];
    
    [videoOperateView addSubview:videoConfirmBtn];
    
    UIButton *videoRetakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    videoRetakeBtn.frame = CGRectMake(0, videoOperateView.frame.size.height - 50, videoOperateView.frame.size.width, 50);
    videoRetakeBtn.layer.cornerRadius = 25;
    videoRetakeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [videoRetakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [videoRetakeBtn setTitle:RETAKE_BTN_TITLE forState:UIControlStateNormal];
    videoRetakeBtn.layer.backgroundColor = [WARNING_TIPCOLOR CGColor];
    [videoRetakeBtn addTarget:self action:@selector(removePreviewMode) forControlEvents:UIControlEventTouchUpInside];
    [videoOperateView addSubview:videoRetakeBtn];
    
    [self.operatorView addSubview:videoOperateView];
    
    
    [UIView animateWithDuration:1 animations:^{
        videoOperateView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)removePreviewMode {
    self.captureRealBtn.enabled = YES;
    [_player pause];
    _player = nil;
    for (UIView *subview in self.scanPreviewView.subviews) {
        if (subview.tag == 400) {
            [subview removeFromSuperview];
        }
    }
    for (UIView *subview in self.operatorView.subviews) {
        if (subview.tag == 400) {
            [subview removeFromSuperview];
        }
    }
    
    [self cancelCaptureWithSaveFlag:NO];
    [self showCaptureBtn];
}

- (void)saveCapture {
    [_player pause];
    
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            NSString *fileName = url.lastPathComponent;
            NSString *cachePath = GJCFAppCachePath(fileName);
            NSURL *fileUrl = [NSURL fileURLWithPath:cachePath];
            [GJCFFileManager copyItemAtURL:url toURL:fileUrl error:nil];
        } else {
            self.progressHUD.labelText = [NSString stringWithFormat:@"Failed to save\n%@", error.localizedDescription];
            self.progressHUD.mode = MBProgressHUDModeCustomView;
            [self.progressHUD hide:YES afterDelay:3];
        }
    };
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = VIDEO_OUTPUTFILE;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    self.progressHUD.delegate = self;
    self.progressHUD.mode = MBProgressHUDModeDeterminate;
    
    CFTimeInterval time = CACurrentMediaTime();
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [_player play];
        
        NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    //update progressBar
    [self refreshProgressViewLengthByTime:recordSession.duration];
}

- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
    //confirm capture
    [self hideMiddleTipView];
    if (captureValidFlag) {
        //preview and save video
        [self cancelCaptureWithSaveFlag:YES];
    } else {
        [self cancelCaptureWithSaveFlag:NO];
        [self showCaptureBtn];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if (error == nil) {
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatShortVideo_37x-Checkmark.png"]];
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1];

        //return the filepath
        [self removePreviewMode];
        [self doNextWhenVideoSavedSuccess];
        
        if ([delegate respondsToSelector:@selector(finishWechatShortVideoCapture:)]) {
            [delegate finishWechatShortVideoCapture:VIDEO_OUTPUTFILE];
        }
    } else {
        self.progressHUD.labelText = [NSString stringWithFormat:@"Failed to save\n%@", error.localizedDescription];
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:3];
    }
}

#pragma mark - SCAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession {
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = assetExportSession.progress;
        self.progressHUD.progress = progress;
    });
}

#pragma mark - Center Record Btn ActionEvent
- (IBAction)captureStartDragExit:(UIButton *)captureBtn {
    [UIView transitionWithView:self.middleOperatorTip duration:0.2 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self setReleaseOperatorTipStyle];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)captureStartDrayEnter:(UIButton *)captureBtn {
    [UIView transitionWithView:self.middleOperatorTip duration:0.2 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self setNormalOperatorTipStyle];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)captureStartTouchUpInside:(UIButton *)captureBtn {
    //confirm capture
    [self hideMiddleTipView];
    if (captureValidFlag) {
        //preview and save video
        [self cancelCaptureWithSaveFlag:YES];
    } else {
        [self cancelCaptureWithSaveFlag:NO];
        [self showCaptureBtn];
    }
}

- (IBAction)captureStartTouchUpOutside:(UIButton *)captureBtn {
    if (self.captureRealBtn.enabled) {
        [self showCaptureBtn];
    }
    [self hideMiddleTipView];
    [self cancelCaptureWithSaveFlag:NO];
}

- (IBAction)captureStartTouchDownAction:(UIButton *)captureBtn {
    captureValidFlag = NO;
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    longPressTimer = [NSTimer scheduledTimerWithTimeInterval:VIDEO_VALID_MINTIME target:self selector:@selector(captureSuccess) userInfo:nil repeats:NO];
    
    [_recorder record];
    [self hideCaptureBtn];
    [self showMiddleTipView];
}

@end
