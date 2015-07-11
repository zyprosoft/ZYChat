//
//  GJCFAudioManager.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFAudioPlayerDelegate.h"
#import "GJCFAudioRecordDelegate.h"
#import "GJCFAudioNetworkDelegate.h"
#import "GJCFAudioManager.h"
#import "GJCFAudioModel.h"
#import "GJCFAudioFileUitil.h"
#import "GJCFEncodeAndDecode.h"

typedef void (^GJCFAudioManagerDidFinishUploadCurrentRecordFileBlock) (NSString *remoteUrl);

typedef void (^GJCFAudioManagerDidFaildUploadCurrentRecordFileBlock) (NSError *error);

typedef void (^GJCFAudioManagerDidFinishGetRemoteFileDurationBlock) (NSString *remoteUrl, NSTimeInterval duration);

typedef void (^GJCFAudioManagerDidFaildGetRemoteFileDurationBlock) (NSString *remoteUrl, NSError *error);

typedef void (^GJCFAudioManagerShouldShowRecordSoundMouterBlock) (CGFloat recordSoundMouter);

typedef void (^GJCFAudioManagerStartPlayRemoteUrlBlock) (NSString *remoteUrl,NSString *localWavPath);

typedef void (^GJCFAudioManagerPlayRemoteUrlFaildByDownloadErrorBlock) (NSString *remoteUrl);

typedef void (^GJCFAudioManagerPlayFaildBlock) (NSString *localWavPath);

typedef void (^GJCFAudioManagerRecordFaildBlock) (NSString *localWavPath);

typedef void (^GJCFAudioManagerShouldShowPlaySoundMouterBlock) (CGFloat playSoundMouter);

typedef void (^GJCFAudioManagerShouldShowPlayProgressBlock) (NSString *audioLocalPath,CGFloat progress,CGFloat duration);

typedef void (^GJCFAudioManagerShouldShowPlayProgressDetailBlock) (NSString *audioLocalPath,NSTimeInterval playCurrentTime,NSTimeInterval duration);

typedef void (^GJCFAudioManagerDidFinishPlayCurrentAudioBlock) (NSString *audioLocalPath);

typedef void (^GJCFAudioManagerDidFinishRecordCurrentAudioBlock) (NSString *audioLocalPath,NSTimeInterval duration);

typedef void (^GJCFAudioManagerUploadAudioFileProgressBlock) (NSString *audioLocalPath,CGFloat progress);

typedef void (^GJCFAudioManagerUploadCompletionBlock) (NSString *audioLocalPath,BOOL result,NSString *remoteUrl);

@interface GJCFAudioManager : NSObject

/* 如果外部需要接管这个播放过程，那么实现这个代理并赋值 */
@property (nonatomic,weak)id<GJCFAudioPlayerDelegate> playerDelegate;

/* 如果外部需要接管这个录制过程，那么实现这个代理并赋值 */
@property (nonatomic,weak)id<GJCFAudioRecordDelegate> recordDelegate;

/* 如果外部需要接管这个上传，下载过程，那么实现这个代理并赋值 */
@property (nonatomic,weak)id<GJCFAudioNetworkDelegate> networkDelegate;

/* 创建共享单例 */
+ (GJCFAudioManager *)shareManager;

/* 访问当前录音文件信息 */
- (GJCFAudioModel *)getCurrentRecordAudioFile;

/* 访问当前播放文件信息 */
- (GJCFAudioModel *)getCurrentPlayAudioFile;

/* 开始录音 */
- (void)startRecord;

/* 开始一个时间限制的录音 */
- (void)startRecordWithLimitDuration:(NSTimeInterval)limitSeconds;

/* 完成录音 */
- (void)finishRecord;

/* 取消录音 */
- (void)cancelCurrentRecord;

/* 停止播放 */
- (void)stopPlayCurrentAudio;

/* 暂停播放 */
- (void)pausePlayCurrentAudio;

/* 继续当前播放 */
- (void)startPlayFromLastStopTimestamp;

/*  播放本地指定音频文件  */
- (void)playLocalWavFile:(NSString *)audioFilePath;

/* 播放一个音频文件 */
- (void)playAudioFile:(GJCFAudioModel *)audioFile;

/* 播放当前录制的文件 */
- (void)playCurrentRecodFile;

/* 通过一个远程音频文件地址播放音频 */
- (void)playRemoteAudioFileByUrl:(NSString *)remoteAudioUrl;

/* 获取指定本地路径音频文件的时长 */
- (NSTimeInterval)getDurationForLocalWavPath:(NSString *)localAudioFilePath;

/* 获取网络音频文件时长 */
- (void)getDurationForRemoteUrl:(NSString *)remoteUrl withFinish:(GJCFAudioManagerDidFinishGetRemoteFileDurationBlock)finishBlock withFaildBlock:(GJCFAudioManagerDidFaildGetRemoteFileDurationBlock)faildBlock;

/* 设定观察录音音量波形 */
- (void)setShowRecordSoundMouter:(GJCFAudioManagerShouldShowRecordSoundMouterBlock)recordBlock;

/* 设定观察播放音量波形 */
- (void)setShowPlaySoundMouter:(GJCFAudioManagerShouldShowPlaySoundMouterBlock)playBlock;

/* 设置上传时候的认证类型的参数到HttpHeader */
- (void)setUploadAuthorizedParamsForHttpHeader:(NSDictionary *)headerValues;

/* 设置上传时候的认证类型的参数到params */
- (void)setUploadAuthorizedParamsForHttpRequestParams:(NSDictionary *)params;

/* 开始上传当前录制的音频文件 */
- (void)startUploadCurrentRecordFile;

/* 开始上传当前录制的音频文件 */
- (void)startUploadCurrentRecordFileWithFinish:(GJCFAudioManagerDidFinishUploadCurrentRecordFileBlock)finishBlock withFaildBlock:(GJCFAudioManagerDidFaildUploadCurrentRecordFileBlock)faildBlock;

/* 开始上传指定文件 */
- (void)startUploadAudioFile:(GJCFAudioModel *)audioFile;

/* 观察播放进度 */
- (void)setCurrentAudioPlayProgressBlock:(GJCFAudioManagerShouldShowPlayProgressBlock)progressBlock;

/* 观察播放详细进度 */
- (void)setCurrentAudioPlayProgressDetailBlock:(GJCFAudioManagerShouldShowPlayProgressDetailBlock)progressDetailBlock;

/* 观察当前播放完成 */
- (void)setCurrentAudioPlayFinishedBlock:(GJCFAudioManagerDidFinishPlayCurrentAudioBlock)finishBlock;

/* 观察录音完成 */
- (void)setFinishRecordCurrentAudioBlock:(GJCFAudioManagerDidFinishRecordCurrentAudioBlock)finishBlock;

/* 观察上传进度 */
- (void)setCurrentAudioUploadProgressBlock:(GJCFAudioManagerUploadAudioFileProgressBlock)progressBlock;

/* 观察上传完成 */
- (void)setCurrentAudioUploadCompletionBlock:(GJCFAudioManagerUploadCompletionBlock)completionBlock;

/* 清除当前所有观察block */
- (void)clearAllCurrentObserverBlocks;

/* 观察播放远程音频文件开始播放 */
- (void)setStartRemoteUrlPlayBlock:(GJCFAudioManagerStartPlayRemoteUrlBlock)startRemoteBlock;

/* 观察远程播放失败 */
- (void)setFaildPlayRemoteUrlBlock:(GJCFAudioManagerPlayRemoteUrlFaildByDownloadErrorBlock)playErrorBlock;

/* 观察播放失败 */
- (void)setFaildPlayAudioBlock:(GJCFAudioManagerPlayFaildBlock)faildPlayBlock;

/* 观察录音失败 */
- (void)setRecrodFaildBlock:(GJCFAudioManagerRecordFaildBlock)faildRecordBlock;

@end
