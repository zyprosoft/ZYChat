//
//  GJCFAudioRecordDelegate.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAudioModel.h"

@class GJCFAudioRecord;
@protocol GJCFAudioRecordDelegate <NSObject>

@optional

- (void)audioRecord:(GJCFAudioRecord *)audioRecord finishRecord:(GJCFAudioModel*)resultAudio;

- (void)audioRecord:(GJCFAudioRecord *)audioRecord soundMeter:(CGFloat)soundMeter;

- (void)audioRecord:(GJCFAudioRecord *)audioRecord didFaildByMinRecordDuration:(NSTimeInterval)minDuration;

- (void)audioRecordDidCancel:(GJCFAudioRecord*)audioRecord;

- (void)audioRecord:(GJCFAudioRecord *)audioRecord limitDurationProgress:(CGFloat)progress;

- (void)audioRecord:(GJCFAudioRecord *)audioRecord didOccusError:(NSError *)error;

@end
