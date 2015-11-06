//
//  GJCFAudioManager.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAudioManager.h"
#import "GJCFAudioRecord.h"
#import "GJCFAudioPlayer.h"
#import "GJCFAudioNetwork.h"
#import "GJCFAudioNetworkDelegate.h"
#import "GJCFEncodeAndDecode.h"
#import "GJCFAudioFileUitil.h"

@interface GJCFAudioManager ()<GJCFAudioNetworkDelegate,GJCFAudioPlayerDelegate,GJCFAudioRecordDelegate>

@property (nonatomic,strong)GJCFAudioRecord *audioRecorder;

@property (nonatomic,strong)GJCFAudioPlayer *audioPlayer;

@property (nonatomic,strong)GJCFAudioNetwork *audioNetwork;

@property (nonatomic,strong)GJCFAudioModel *currentRecordAudioFile;

@property (nonatomic,strong)NSMutableArray *downloadAudioFileUniqueIdentifiers;

@property (nonatomic,copy)GJCFAudioManagerDidFaildUploadCurrentRecordFileBlock uploadFaildBlock;

@property (nonatomic,copy)GJCFAudioManagerDidFinishUploadCurrentRecordFileBlock uploadFinishBlock;

@property (nonatomic,copy)GJCFAudioManagerDidFaildGetRemoteFileDurationBlock durationGetFaildBlock;

@property (nonatomic,copy)GJCFAudioManagerDidFinishGetRemoteFileDurationBlock durationGetSuccessBlock;

@property (nonatomic,copy)GJCFAudioManagerShouldShowPlaySoundMouterBlock playMouterBlock;

@property (nonatomic,copy)GJCFAudioManagerShouldShowRecordSoundMouterBlock recordMouterBlock;

@property (nonatomic,copy)GJCFAudioManagerDidFinishPlayCurrentAudioBlock finishPlayBlock;

@property (nonatomic,copy)GJCFAudioManagerShouldShowPlayProgressBlock playProgressBlock;

@property (nonatomic,copy)GJCFAudioManagerShouldShowPlayProgressDetailBlock playProgressDetailBlock;

@property (nonatomic,copy)GJCFAudioManagerDidFinishRecordCurrentAudioBlock recordFinishBlock;

@property (nonatomic,copy)GJCFAudioManagerUploadAudioFileProgressBlock uploadProgressBlock;

@property (nonatomic,copy)GJCFAudioManagerUploadCompletionBlock uploadCompletionBlock;

@property (nonatomic,copy)GJCFAudioManagerStartPlayRemoteUrlBlock startPlayRemoteBlock;

@property (nonatomic,copy)GJCFAudioManagerPlayRemoteUrlFaildByDownloadErrorBlock remotePlayFaildBlock;

@property (nonatomic,copy)GJCFAudioManagerPlayFaildBlock playFaildBlock;

@property (nonatomic,copy)GJCFAudioManagerRecordFaildBlock recordFaildBlock;

@end

@implementation GJCFAudioManager

/* 创建共享单例 */
+ (GJCFAudioManager *)shareManager
{
    static GJCFAudioManager *_audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        if (!_audioManager) {
            _audioManager = [[self alloc]init];
        }
    });
    return _audioManager;
}

- (id)init
{
    if (self = [super init]) {
        
        /* 下载文件的唯一标示 */
        self.downloadAudioFileUniqueIdentifiers = [[NSMutableArray alloc]init];
        
        /* 录音模块 */
        self.audioRecorder = [[GJCFAudioRecord alloc]init];
        /* 如果外部设置了代理，想要接管，那么就让外部接管 */
        if (self.recordDelegate) {
            self.audioRecorder.delegate = self.recordDelegate;
        }else{
            self.audioRecorder.delegate = self;
        }
        
        /* 播放模块 */
        self.audioPlayer = [[GJCFAudioPlayer alloc]init];
        
        /* 如果外部设置了代理，想要接管，那么就让外部接管 */
        if (self.playerDelegate) {
            self.audioPlayer.delegate = self.playerDelegate;
        }else{
            self.audioPlayer.delegate = self;
        }
        
        /* 网络数据模块 */
        self.audioNetwork = [[GJCFAudioNetwork alloc]init];
        
        /* 如果外部设置了代理，想要接管，那么就让外部接管 */
        if (self.networkDelegate) {
            
            self.audioNetwork.delegate = self.networkDelegate;
        }else{
            self.audioNetwork.delegate = self;
        }
    }
    return self;
}

- (void)setRecordDelegate:(id<GJCFAudioRecordDelegate>)recordDelegate
{
    if (!recordDelegate) {
        return;
    }
    if (_recordDelegate == recordDelegate) {
        return;
    }
    _recordDelegate = recordDelegate;
    self.audioRecorder.delegate = _recordDelegate;
}

- (void)setPlayerDelegate:(id<GJCFAudioPlayerDelegate>)playerDelegate
{
    if (!playerDelegate) {
        return;
    }
    if (_playerDelegate == playerDelegate) {
        return;
    }
    _playerDelegate = playerDelegate;
    self.audioPlayer.delegate = _playerDelegate;
}

- (void)setNetworkDelegate:(id<GJCFAudioNetworkDelegate>)networkDelegate
{
    if (!networkDelegate) {
        return;
    }
    if (_networkDelegate == networkDelegate) {
        return;
    }
    _networkDelegate = networkDelegate;
    self.audioNetwork.delegate = _networkDelegate;
}

#pragma mark - 公开方法

/* 访问当前录音文件信息 */
- (GJCFAudioModel *)getCurrentRecordAudioFile
{
    return [self.audioRecorder getCurrentRecordAudioFile];
}

/* 访问当前播放文件信息 */
- (GJCFAudioModel *)getCurrentPlayAudioFile
{
    return [self.audioPlayer getCurrentPlayingAudioFile];
}

- (void)startRecord
{
    if (!self.audioRecorder) {
        
        NSLog(@"GJCFAudioManager startRecord setting no audioRecord or recordDelegate");
        
        return;
    }
    
    /* 如果当前录音文件没有被上传，那么删掉这段录音 */
    if (!self.currentRecordAudioFile.isBeenUploaded) {
        
        /* 开始录音前将当前文件的wav文件和临时转码文件都删除 */
        NSLog(@"GJCFAudioManager 重新开始录音，清除当前录音文件的数据开始...");
        [self.currentRecordAudioFile deleteTempEncodeFile];
        [self.currentRecordAudioFile deleteWavFile];
        NSLog(@"GJCFAudioManager 重新开始录音，清除当前录音文件的数据完成...");
        
    }
    

    /* 开始录音 */
    self.audioRecorder.limitRecordDuration = 0.f;//默认是没有时间限制
    [self.audioRecorder startRecord];
}

- (void)startRecordWithLimitDuration:(NSTimeInterval)limitSeconds
{
    if (!self.audioRecorder) {
        
        NSLog(@"GJCFAudioManager startRecord setting no audioRecord or recordDelegate");
        
        return;
    }
    
    /* 如果当前录音文件没有被上传，那么删掉这段录音 */
    if (!self.currentRecordAudioFile.isBeenUploaded) {
        
        /* 开始录音前将当前文件的wav文件和临时转码文件都删除 */
        NSLog(@"GJCFAudioManager 重新开始录音，清除当前录音文件的数据开始...");
        [self.currentRecordAudioFile deleteTempEncodeFile];
        [self.currentRecordAudioFile deleteWavFile];
        NSLog(@"GJCFAudioManager 重新开始录音，清除当前录音文件的数据完成...");
        
    }
    
    /* 开始录音 */
    self.audioRecorder.limitRecordDuration = limitSeconds;
    [self.audioRecorder startRecord];
}

- (void)finishRecord
{
    if (self.audioRecorder.isRecording == NO) {
        
        return;
    }
    
    [self.audioRecorder finishRecord];
}

/* 取消录音 */
- (void)cancelCurrentRecord
{
    if (!self.audioRecorder) {
        return;
    }
    if (!self.audioRecorder.isRecording) {
        return;
    }
    [self.audioRecorder cancelRecord];
}

/* 暂停播放 */
- (void)stopPlayCurrentAudio
{
    if (!self.audioPlayer) {
        return;
    }
    if (!self.audioPlayer.isPlaying) {
        return;
    }
    [self.audioPlayer stop];
}

/* 继续当前播放 */
- (void)startPlayFromLastStopTimestamp
{
    if (!self.audioPlayer) {
        return;
    }
    if (self.audioPlayer.isPlaying) {
        return;
    }
    [self.audioPlayer play];
}

/* 暂停播放 */
- (void)pausePlayCurrentAudio
{
    if (!self.audioPlayer) {
        return;
    }
    if (!self.audioPlayer.isPlaying) {
        return;
    }
    [self.audioPlayer pause];
}

- (void)playCurrentRecodFile
{
    NSLog(@"GJCFAudioManager 开始播放当前录音文件");

    [self.audioPlayer playAudioFile:self.currentRecordAudioFile];
}

/* 播放本地指定音频文件 */
- (void)playLocalWavFile:(NSString *)audioFilePath
{
    if (!audioFilePath) {
        return;
    }
    GJCFAudioModel *existAudio = [[GJCFAudioModel alloc]init];
    existAudio.localStorePath = audioFilePath;
    
    [self playAudioFile:existAudio];
}

- (void)playAudioFile:(GJCFAudioModel *)audioFile
{
    if (!audioFile) {
        return;
    }
    if (!self.audioPlayer) {
        return;
    }
    
    if (!audioFile.localStorePath) {
        
        NSLog(@"GJCFAudioManager 错误:播放没有音频文件路径");
        
        return;
    }
    
    NSData *fileData = [NSData dataWithContentsOfFile:audioFile.localStorePath];
    if (!fileData) {
        NSLog(@"GJCFAudioManager 错误:播放没有实际数据的音频文件路径");
        return;
    }
    [self.audioPlayer playAudioFile:audioFile];
}

- (void)playRemoteAudioFileByUrl:(NSString *)remoteAudioUrl
{
    if (!remoteAudioUrl) {
        return;
    }
    
    /* 检测本地是否已经有对应的wav文件 */
    NSString *localWavPath = [GJCFAudioFileUitil localWavPathForRemoteUrl:remoteAudioUrl];
    NSData *fileData = [NSData dataWithContentsOfFile:localWavPath];
    
    /* 确保有路径并且有数据 */
    if (localWavPath && fileData) {

        GJCFAudioModel *existAudio = [[GJCFAudioModel alloc]init];
        existAudio.localStorePath = localWavPath;
        
        NSLog(@"GJCFAudioManager 播放已经下载过的音频文件:%@",existAudio.localStorePath);
        [self playAudioFile:existAudio];
        
        /* 开始播放远程文件的观察调用 */
        if (self.startPlayRemoteBlock) {
            self.startPlayRemoteBlock(remoteAudioUrl,localWavPath);
        }
        
        return;
    }
    
    NSString *fileIdentifier = nil;
    [self.audioNetwork downloadAudioFileWithUrl:remoteAudioUrl withFinishDownloadPlayCheck:YES withFileUniqueIdentifier:&fileIdentifier];
    [self.downloadAudioFileUniqueIdentifiers addObject:fileIdentifier];
}

- (void)startUploadCurrentRecordFile
{
    NSLog(@"GJCFAudioManager 开始上传录音文件");
    
    /* 如果当前这个录音文件已经上传过了就直接返回成功结果 */
    if (self.currentRecordAudioFile.remotePath) {
        
        NSLog(@"GJCFAudioManager 当前录音文件已经上传过, 直接返回一个已经上传过的音频文件的远程地址:%@",self.currentRecordAudioFile.remotePath);
        
        if (self.uploadFinishBlock) {
            self.uploadFinishBlock(self.currentRecordAudioFile.remotePath);
        }
        if (self.uploadCompletionBlock) {
            self.uploadCompletionBlock(self.currentRecordAudioFile.localStorePath,YES,self.currentRecordAudioFile.remotePath);
        }
        return;
    }
    
    if (self.currentRecordAudioFile) {
        
        [self startUploadAudioFile:self.currentRecordAudioFile];
        
    }
}

- (void)startUploadAudioFile:(GJCFAudioModel *)audioFile
{
    if (!audioFile) {
        return;
    }

    if (self.audioNetwork) {
        
        /* 通常情况为了上传之后不占缓存，我们要将转码的临时文件在上传完成之后删掉 */
        audioFile.isDeleteWhileUploadFinish = YES;
        [self.audioNetwork uploadAudioFile:audioFile];
    }
}

/* 获取指定本地路径音频文件的时长 */
- (NSTimeInterval)getDurationForLocalWavPath:(NSString *)localAudioFilePath
{
    return [self.audioPlayer getLocalWavFileDuration:localAudioFilePath];
}

/* 获取网络音频文件时长 */
- (void)getDurationForRemoteUrl:(NSString *)remoteUrl withFinish:(GJCFAudioManagerDidFinishGetRemoteFileDurationBlock)finishBlock withFaildBlock:(GJCFAudioManagerDidFaildGetRemoteFileDurationBlock)faildBlock
{
    if (!remoteUrl) {
        if (faildBlock) {
            NSError *error = [NSError errorWithDomain:@"gjcf.AuidoManager.com" code:-235 userInfo:@{@"msg": @"没有远程地址"}];
            faildBlock(remoteUrl,error);
        }
        return;
    }
    
    /* 测试一下直接去网络上读取这个文件音频时间的效率 */
    /*AVURLAsset* audioAsset =[AVURLAsset assetWithURL:[NSURL URLWithString:remoteUrl]];
    CMTime audioDuration = audioAsset.duration;
    NSTimeInterval remoteDuration =   CMTimeGetSeconds(audioDuration);
    
    if (self.durationGetSuccessBlock) {
        self.durationGetSuccessBlock ( remoteUrl , remoteDuration);
        return;
    }*/
    
    /* 检查是否已经下载过了，有对应的本地音频文件 */
    NSString *localWavPath = [GJCFAudioFileUitil localWavPathForRemoteUrl:remoteUrl];
    
    if (localWavPath && [NSData dataWithContentsOfFile:localWavPath]) {
        
        NSTimeInterval duration = [self getDurationForLocalWavPath:localWavPath];
        
        if (finishBlock) {
            finishBlock(remoteUrl,duration);
        }
        return;
    }
    
    /* block赋值 */
    if (self.durationGetSuccessBlock) {
        self.durationGetSuccessBlock = nil;
    }
    self.durationGetSuccessBlock = finishBlock;
    if (self.durationGetFaildBlock) {
        self.durationGetFaildBlock = nil;
    }
    self.durationGetFaildBlock = faildBlock;

    /* 先去下载这个音频文件到本地 */
    NSString *fileIdentifier = nil;
    [self.audioNetwork downloadAudioFileWithUrl:remoteUrl withFinishDownloadPlayCheck:NO withFileUniqueIdentifier:&fileIdentifier];
    [self.downloadAudioFileUniqueIdentifiers addObject:fileIdentifier];
}

/* 开始上传当前录制的音频文件 */
- (void)startUploadCurrentRecordFileWithFinish:(GJCFAudioManagerDidFinishUploadCurrentRecordFileBlock)finishBlock withFaildBlock:(GJCFAudioManagerDidFaildUploadCurrentRecordFileBlock)faildBlock
{
    if (!self.currentRecordAudioFile) {
        return;
    }
    
    if (self.uploadFinishBlock) {
        self.uploadFinishBlock = nil;
    }
    if (self.uploadFaildBlock) {
        self.uploadFaildBlock = nil;
    }
    self.uploadFaildBlock = faildBlock;
    self.uploadFinishBlock = finishBlock;
    
    [self startUploadCurrentRecordFile];
}

/* 设定观察录音音量波形 */
- (void)setShowRecordSoundMouter:(GJCFAudioManagerShouldShowRecordSoundMouterBlock)recordBlock
{
    if (self.recordMouterBlock) {
        self.recordMouterBlock = nil;
    }
    self.recordMouterBlock = recordBlock;
}

/* 设定观察播放音量波形 */
- (void)setShowPlaySoundMouter:(GJCFAudioManagerShouldShowPlaySoundMouterBlock)playBlock
{
    if (self.playMouterBlock) {
        self.playMouterBlock = nil;
    }
    self.playMouterBlock = playBlock;
}

/* 设置上传时候的认证类型的参数到HttpHeader */
- (void)setUploadAuthorizedParamsForHttpHeader:(NSDictionary *)headerValues
{
    if (self.audioNetwork.uploadManager) {
        [self.audioNetwork.uploadManager addRequestHeader:headerValues];
    }
}

/* 设置上传时候的认证类型的参数到params */
- (void)setUploadAuthorizedParamsForHttpRequestParams:(NSDictionary *)params
{
    if (self.audioNetwork.uploadManager) {
        [self.audioNetwork.uploadManager addRequestParams:params];
    }
}

/* 观察播放进度 */
- (void)setCurrentAudioPlayProgressBlock:(GJCFAudioManagerShouldShowPlayProgressBlock)progressBlock
{
    if (self.playProgressBlock) {
        self.playProgressBlock = nil;
    }
    self.playProgressBlock = progressBlock;
}

/* 观察播放详细进度 */
- (void)setCurrentAudioPlayProgressDetailBlock:(GJCFAudioManagerShouldShowPlayProgressDetailBlock)progressDetailBlock
{
    if (self.playProgressDetailBlock) {
        self.playProgressDetailBlock = nil;
    }
    self.playProgressDetailBlock = progressDetailBlock;
}

/* 观察当前播放完成 */
- (void)setCurrentAudioPlayFinishedBlock:(GJCFAudioManagerDidFinishPlayCurrentAudioBlock)finishBlock
{
    if (self.finishPlayBlock) {
        self.finishPlayBlock = nil;
    }
    self.finishPlayBlock = finishBlock;
}

/* 观察录音完成 */
- (void)setFinishRecordCurrentAudioBlock:(GJCFAudioManagerDidFinishRecordCurrentAudioBlock)finishBlock
{
    if (self.recordFinishBlock) {
        self.recordFinishBlock = nil;
    }
    self.recordFinishBlock = finishBlock;
}

/* 观察上传进度 */
- (void)setCurrentAudioUploadProgressBlock:(GJCFAudioManagerUploadAudioFileProgressBlock)progressBlock
{
    if (self.uploadProgressBlock) {
        self.uploadProgressBlock = nil;
    }
    self.uploadProgressBlock = progressBlock;
}

/* 观察上传完成 */
- (void)setCurrentAudioUploadCompletionBlock:(GJCFAudioManagerUploadCompletionBlock)completionBlock
{
    if (self.uploadCompletionBlock) {
        self.uploadCompletionBlock = nil;
    }
    self.uploadCompletionBlock = completionBlock;
}


/* 观察播放远程音频文件开始播放 */
- (void)setStartRemoteUrlPlayBlock:(GJCFAudioManagerStartPlayRemoteUrlBlock)startRemoteBlock
{
    if (self.startPlayRemoteBlock) {
        self.startPlayRemoteBlock = nil;
    }
    self.startPlayRemoteBlock = startRemoteBlock;
}

/* 观察远程播放失败 */
- (void)setFaildPlayRemoteUrlBlock:(GJCFAudioManagerPlayRemoteUrlFaildByDownloadErrorBlock)playErrorBlock
{
    if (self.remotePlayFaildBlock) {
        self.remotePlayFaildBlock = nil;
    }
    self.remotePlayFaildBlock = playErrorBlock;
}

/* 观察播放失败 */
- (void)setFaildPlayAudioBlock:(GJCFAudioManagerPlayFaildBlock)faildPlayBlock
{
    if (self.playFaildBlock) {
        self.playFaildBlock = nil;
    }
    self.playFaildBlock = faildPlayBlock;
}

/* 观察录音失败 */
- (void)setRecrodFaildBlock:(GJCFAudioManagerRecordFaildBlock)faildRecordBlock
{
    if (self.recordFaildBlock) {
        self.recordFaildBlock = nil;
    }
    self.recordFaildBlock = faildRecordBlock;
}

/* 清除当前所有观察block */
- (void)clearAllCurrentObserverBlocks
{
    /* 清除正在执行的录音播放动作 */
    [self.audioPlayer stop];
    [self.audioRecorder cancelRecord];
    
    if (self.durationGetSuccessBlock) {
        self.durationGetSuccessBlock = nil;
    }
    
    if (self.durationGetFaildBlock) {
        self.durationGetFaildBlock = nil;
    }
    
    if (self.uploadFinishBlock) {
        self.uploadFinishBlock = nil;
    }
    
    if (self.uploadFaildBlock) {
        self.uploadFaildBlock = nil;
    }
    
    if (self.recordMouterBlock) {
        self.recordMouterBlock = nil;
    }
    
    if (self.playMouterBlock) {
        self.playMouterBlock = nil;
    }
    
    if (self.playProgressBlock) {
        self.playProgressBlock = nil;
    }
    
    if (self.finishPlayBlock) {
        self.finishPlayBlock = nil;
    }
    
    if (self.recordFinishBlock) {
        self.recordFinishBlock = nil;
    }
    
    if (self.uploadProgressBlock) {
        self.uploadProgressBlock = nil;
    }
    
    if (self.uploadCompletionBlock) {
        self.uploadCompletionBlock = nil;
    }
    
    /* 清除上传和下载请求 */
    
}

#pragma mark - 网络数据管理

#pragma mark - 网络数据上传代理

- (GJCFAudioModel *)audioNetwork:(GJCFAudioNetwork *)audioNetwork formateUploadResult:(GJCFAudioModel *)baseResultModel formateDict:(NSDictionary *)formateDict
{
    NSLog(@"GJCFAudioManager 上传完成:%@",formateDict);

    /* 这里还得判断上传是否真的成功 */
    if ([[formateDict objectForKey:@"status"] intValue] == 0) {
        
        /* 根据IM目前的内容格式来处理成对象Model */
        baseResultModel.remotePath = [formateDict objectForKey:@"data"];
        
        /* 远程文件和本地文件建立关系 */
        [GJCFAudioFileUitil createRemoteUrl:baseResultModel.remotePath relationWithLocalWavPath:baseResultModel.localStorePath];
        self.currentRecordAudioFile.remotePath = baseResultModel.remotePath;
        
        /* 上传完成如果设置了要删除临时转码文件 */
        if (baseResultModel.isDeleteWhileUploadFinish) {
            
            if (baseResultModel.tempEncodeFilePath) {
                
                NSLog(@"GJCFAudioManager 删除临时转码文件开始");
                
                BOOL deleteTempEncodeFileResult = [GJCFAudioFileUitil deleteTempEncodeFileWithPath:baseResultModel.tempEncodeFilePath];
                
                /* 已经删除转码文件 */
                if (deleteTempEncodeFileResult) {
                    
                    baseResultModel.tempEncodeFilePath = nil;
                }
                
                NSLog(@"GJCFAudioManager 删除临时转码文件结束");
                
            }
        }
        
        return baseResultModel;

    }else{
        
        /* 上传失败 */
        return nil;
    }
}

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork finishUploadAudioFile:(GJCFAudioModel *)audioFile
{
    NSLog(@"GJCFAudioManager 上传成功:%@",audioFile);
    
    if (self.uploadFinishBlock) {
        
        self.uploadFinishBlock(audioFile.remotePath);
    }

    if (self.uploadCompletionBlock) {
        self.uploadCompletionBlock(audioFile.localStorePath,YES,audioFile.remotePath);
    }
}

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileLocalPath uploadFaild:(NSError *)error
{
    NSLog(@"GJCFAudioManager 上传失败:%@",error);
    
    if (self.uploadFaildBlock) {
        
        self.uploadFaildBlock(error);
    }
    
    if (self.uploadCompletionBlock) {
        self.uploadCompletionBlock(audioFileLocalPath,NO,nil);
    }

}

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileLocalPath uploadProgress:(CGFloat)progress
{
    NSLog(@"GJCFAudioManager 上传进度:%f",progress);
    if (self.uploadProgressBlock) {
        
        self.uploadProgressBlock(audioFileLocalPath,progress);
    }
}

#pragma mark - 网络数据下载代理
- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork finishDownloadWithAudioFile:(GJCFAudioModel *)audioFile
{

    NSLog(@"GJCFAudioManager 需要转码文件:%d",audioFile.isNeedConvertEncodeToSave);
    
    NSLog(@"GJCFAudioManager 需要转码完成播放:%d",audioFile.shouldPlayWhileFinishDownload);
    
    /* 判断是不是需要转码的类型 */
    if (audioFile.isNeedConvertEncodeToSave) {
        
        BOOL convertEncodeResult = [GJCFEncodeAndDecode convertAudioFileToWAV:audioFile];
        
        NSLog(@"GJCFAudioManager 转码结果:%d",convertEncodeResult);
        
        /* 转码成功获取音频的时间 */
        if (convertEncodeResult) {
            
            if (self.durationGetSuccessBlock) {
                
                NSTimeInterval duration = [self getDurationForLocalWavPath:audioFile.localStorePath];
                
                self.durationGetSuccessBlock(audioFile.remotePath,duration);
            }
            
        }else{
            
            if (self.durationGetFaildBlock) {
                
                NSError *faildError = [NSError errorWithDomain:@"gjcf.AudioManager.com" code:-234 userInfo:@{@"msg": @"GJCFAuidoManager转码失败"}];
                self.durationGetFaildBlock(audioFile.remotePath,faildError);
            }
        }
        
        /* 转码 */
        if (convertEncodeResult) {
            
            /* 转码成功之后建立一个远程地址和本地wav建立一个关系，避免重复下载 */
            BOOL shipCreateState =[GJCFAudioFileUitil createRemoteUrl:audioFile.remotePath relationWithLocalWavPath:audioFile.localStorePath];
            if (shipCreateState) {
                
                NSLog(@"GJCFAudioManager 远程地址和本地转码后的wav文件建立关系成功");
                
            }else{
                
                NSLog(@"GJCFAudioManager 远程地址和本地转码后的wav文件建立关系失败");
                
            }
            
        }
        
        
        /* 如果转码成功 */
        if (convertEncodeResult) {
            
            if (audioFile.shouldPlayWhileFinishDownload) {
                
                NSLog(@"GJCFAudioManager 下载完成:%@",audioFile);

                /* 调用播放器播放 */
                [self.audioPlayer playAudioFile:audioFile];
                
                if (self.startPlayRemoteBlock) {
                    self.startPlayRemoteBlock(audioFile.remotePath,audioFile.localStorePath);
                }
                
                NSLog(@"GJCFAudioManager 转码播放:%@",audioFile.localStorePath);

                return;
            }
            
        }else{
            
            
        }
    }
    
    NSLog(@"GJCFAudioManager 下载完成:%@",audioFile);

    /* 如果不需要转码,要求立即播放 */
    if (audioFile.shouldPlayWhileFinishDownload) {
        
        /* 调用播放器播放 */
        [self.audioPlayer playAudioFile:audioFile];
        
        if (self.startPlayRemoteBlock) {
            self.startPlayRemoteBlock(audioFile.remotePath,audioFile.localStorePath);
        }
        
        NSLog(@"GJCFAudioManager 不转码播放:%@",audioFile.localStorePath);

    }
    

}

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileUnique downloadProgress:(CGFloat)progress
{
    NSLog(@"GJCFAudioManager 下载:%@ 进度:%f",audioFileUnique,progress);
}

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileUnique downloadFaild:(NSError *)error
{
    NSLog(@"GJCFAudioManager 下载:%@ 错误:%@",audioFileUnique,error);
    if (self.durationGetFaildBlock) {
        self.durationGetFaildBlock(audioFileUnique,error);
    }
    if (self.remotePlayFaildBlock) {
        self.remotePlayFaildBlock(audioFileUnique);
    }
}

#pragma mark - 录音管理
- (void)audioRecord:(GJCFAudioRecord *)audioRecord didFaildByMinRecordDuration:(NSTimeInterval)minDuration
{
    NSLog(@"GJCFAudioManager 录音到达限制时间:%lf",minDuration);
    if (self.recordFaildBlock) {
        self.recordFaildBlock([audioRecord getCurrentRecordAudioFile].localStorePath);
    }
}

- (void)audioRecord:(GJCFAudioRecord *)audioRecord didOccusError:(NSError *)error
{
    NSLog(@"GJCFAudioManager 录音错误:%@",error);
    if (self.recordFaildBlock) {
        self.recordFaildBlock([audioRecord getCurrentRecordAudioFile].localStorePath);
    }

}

- (void)audioRecord:(GJCFAudioRecord *)audioRecord finishRecord:(GJCFAudioModel *)resultAudio
{
    self.currentRecordAudioFile = resultAudio;
    
    /* 创建一份AMR转码文件 */
    [GJCFEncodeAndDecode convertAudioFileToAMR:self.currentRecordAudioFile];
    
    /* 获取录音时间 */
    if (self.recordFinishBlock) {
        
        GJCFAudioModel *currentRecordFile = [audioRecord getCurrentRecordAudioFile];
        
        self.recordFinishBlock(currentRecordFile.localStorePath,currentRecordFile.duration);
    }
    
}

- (void)audioRecord:(GJCFAudioRecord *)audioRecord limitDurationProgress:(CGFloat)progress
{
    NSLog(@"GJCFAudioManager 录音进度:%f",progress);

}

- (void)audioRecord:(GJCFAudioRecord *)audioRecord soundMeter:(CGFloat)soundMeter
{
    NSLog(@"GJCFAudioManager 录音输入量:%f",soundMeter);
    if (self.recordMouterBlock) {
        self.recordMouterBlock(soundMeter*100);
    }
}

- (void)audioRecordDidCancel:(GJCFAudioRecord *)audioRecord
{
    NSLog(@"GJCFAudioManager 录音取消");
}

#pragma mark - 播放管理
- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didFinishPlayAudio:(GJCFAudioModel *)audioFile
{
    NSLog(@"GJCFAudioManager 播放完成:%@",audioFile.localStorePath);
    
    if (self.finishPlayBlock) {
        self.finishPlayBlock(audioFile.localStorePath);
    }
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didOccusError:(NSError *)error
{
    NSLog(@"GJCFAudioManager 播放错误:%@",error);
    if (self.playFaildBlock) {
        self.playFaildBlock ([audioPlay getCurrentPlayingAudioFile].localStorePath);
    }
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay playingProgress:(CGFloat)progressValue
{
    NSLog(@"GJCFAudioManager 播放进度:%f",progressValue);
    if (self.playProgressBlock) {
        
        NSString *currentPlayFilePath = [audioPlay currentPlayAudioFileLocalPath];
        
        NSTimeInterval currentFileDuration = [audioPlay currentPlayAudioFileDuration];
        
        self.playProgressBlock(currentPlayFilePath,progressValue,currentFileDuration);
    }
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay playingProgress:(NSTimeInterval)playCurrentTime duration:(NSTimeInterval)duration
{
    NSLog(@"GJCFAudioManager 详细播放进度:%f 秒",playCurrentTime);

    if (self.playProgressDetailBlock) {
        
        NSString *currentPlayFilePath = [audioPlay currentPlayAudioFileLocalPath];

        self.playProgressDetailBlock(currentPlayFilePath,playCurrentTime,duration);
    }
}

- (void)audioPlayer:(GJCFAudioPlayer *)audioPlay didUpdateSoundMouter:(CGFloat)soundMouter
{
    NSLog(@"GJCFAudioManager 播放音量波形:%f",soundMouter);
    if (self.playMouterBlock) {
        self.playMouterBlock(soundMouter*100);
    }
}


@end
