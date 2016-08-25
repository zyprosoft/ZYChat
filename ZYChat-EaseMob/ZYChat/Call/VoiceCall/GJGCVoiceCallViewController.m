//
//  GJGCVoiceCallViewController.m
//  ZYChat
//
//  Created by bob on 16/8/25.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCVoiceCallViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

static CTCallCenter *g_callCenter;

@interface GJGCVoiceCallViewController ()<EMCallManagerDelegate>
{
    EMCallSession *_voicesession;
    BOOL _isIncoming;
    NSTimer *_timeTimer;
    NSInteger _timeLength;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *slienceButton;
@property (weak, nonatomic) IBOutlet UIButton *handsFreeButton;
@property (weak, nonatomic) IBOutlet UIButton *hungUpButton;
@property (weak, nonatomic) IBOutlet UIButton *minWindowButton;

@end

@implementation GJGCVoiceCallViewController

- (instancetype)initWithSession:(EMCallSession *)session
                     isIncoming:(BOOL)isIncoming
{
    self = [super init];
    if (self) {
        _voicesession = session;
        _isIncoming = isIncoming;
        _timeLabel.text = nil;
        _chatter = session.remoteUsername;
        
        [[EMClient sharedClient].callManager removeDelegate:self];
        [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameLabel.text = _chatter;
    
    if (_isIncoming) {
        self.minWindowButton.hidden = YES;
        self.hungUpButton.hidden = YES;
        self.timeLabel.hidden = YES;
        self.stateLabel.text = @"邀请你进行语音聊天";
        [self.slienceButton setTitle:@"挂断" forState:UIControlStateNormal];
        [self.handsFreeButton setTitle:@"接听" forState:UIControlStateNormal];
    }
    else{
        self.minWindowButton.hidden = YES;
        self.slienceButton.hidden = YES;
        self.handsFreeButton.hidden = YES;
        self.timeLabel.hidden = YES;
    }
}

- (void)closeVoiceCall
{
    _voicesession = nil;
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    [[EMClient sharedClient].callManager removeDelegate:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    _voicesession = nil;
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    [[EMClient sharedClient].callManager removeDelegate:self];
}

- (IBAction)minWindowButtonAction:(UIButton *)sender {
    
}

- (IBAction)silenceButtonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"静音"]) {
        [[EMClient sharedClient].callManager markCallSession:_voicesession.sessionId isSilence:YES];
    }
    
    if ([sender.currentTitle isEqualToString:@"挂断"]) {
        [[EMClient sharedClient].callManager endCall:_voicesession.sessionId reason:EMCallEndReasonHangup];
        [self closeVoiceCall];
    }
    
}
- (IBAction)hungUpButtonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"取消"]) {
        [[EMClient sharedClient].callManager endCall:_voicesession.sessionId reason:EMCallEndReasonHangup];
        [self closeVoiceCall];
    }
    
    if ([sender.currentTitle isEqualToString:@"挂断"]) {
        [[EMClient sharedClient].callManager endCall:_voicesession.sessionId reason:EMCallEndReasonHangup];
        [self closeVoiceCall];
    }
}

- (IBAction)handFreeButtonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"接听"]) {
        [[EMClient sharedClient].callManager answerCall:_voicesession.sessionId];
    }
    if ([sender.currentTitle isEqualToString:@"免提"]) {
        
    }
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    NSInteger hour = _timeLength / 3600;
    NSInteger m = (_timeLength - hour * 3600) / 60;
    NSInteger s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%li:%li:%ld", (long)hour, (long)m, (long)s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

/*!
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)didReceiveCallAccepted:(EMCallSession *)aSession
{
    NSLog(@"同意Call请求");
    
    self.minWindowButton.hidden = NO;
    self.stateLabel.hidden = YES;
    self.timeLabel.hidden = NO;
    
    if(_isIncoming){
        self.hungUpButton.hidden = NO;
        [self.slienceButton setTitle:@"静音" forState:UIControlStateNormal];
        [self.hungUpButton setTitle:@"挂断" forState:UIControlStateNormal];
        [self.handsFreeButton setTitle:@"免提" forState:UIControlStateNormal];
    }else{
        self.slienceButton.hidden = NO;
        self.handsFreeButton.hidden = NO;
        [self.hungUpButton setTitle:@"挂断" forState:UIControlStateNormal];
    }
    _timeLength = 0;
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

/*!
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 */
- (void)didReceiveCallNetworkChanged:(EMCallSession *)aSession
                              status:(EMCallNetworkStatus)aStatus
{
    NSLog(@"Call网络状态出现不稳定");
}

/*!
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */
- (void)didReceiveCallTerminated:(EMCallSession *)aSession
                          reason:(EMCallEndReason)aReason
                           error:(EMError *)aError
{
    NSLog(@"Call结束");
    
    [self closeVoiceCall];
}

@end
