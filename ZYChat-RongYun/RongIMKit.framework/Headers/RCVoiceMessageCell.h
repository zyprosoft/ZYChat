//
//  RCVoiceMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageCell.h"
#define kAudioBubbleMinWidth 60
#define kAudioBubbleMaxWidth 180
#define kBubbleBackgroundViewHeight 36

/**
 *  停止播放通知Key
 */
UIKIT_EXTERN NSString *const kNotificationStopVoicePlayer;

/**
 *  语音消息Cell
 */
@interface RCVoiceMessageCell : RCMessageCell

/**
 *  消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 *  播放声音视图
 */
@property(nonatomic, strong) UIImageView *playVoiceView;

/**
 *  语音未读标记视图
 */
@property(nonatomic, strong) UIImageView *voiceUnreadTagView;

/**
 *  语音时长视图
 */
@property(nonatomic, strong) UILabel *voiceDurationLabel;

/**
 *  播放语音
 */
- (void)playVoice;

@end
