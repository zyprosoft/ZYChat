//
//  GJCFAudioRecord.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GJCFAudioRecordDelegate.h"
#import "GJCFAudioRecordSettings.h"

@interface GJCFAudioRecord : NSObject

@property (nonatomic,readonly)BOOL isRecording;

@property (nonatomic,readonly)CGFloat soundMouter;

@property (nonatomic,assign)NSTimeInterval limitRecordDuration;

/* 最小有小时间,默认1秒 */
@property (nonatomic,assign)NSTimeInterval minEffectDuration;

@property (nonatomic,weak)id<GJCFAudioRecordDelegate> delegate;

@property (nonatomic,strong)GJCFAudioRecordSettings *recordSettings;

/* 获取当前录制音频文件*/
- (GJCFAudioModel*)getCurrentRecordAudioFile;

- (void)startRecord;

- (void)finishRecord;

- (void)cancelRecord;

- (NSTimeInterval)currentRecordFileDuration;

@end
