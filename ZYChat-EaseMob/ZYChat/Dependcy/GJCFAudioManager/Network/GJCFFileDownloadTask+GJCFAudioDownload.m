//
//  GJCFFileDownloadTask+GJCFAudioDownload.m
//  GJCommonFoundation
//
//  Created by ZYVincent QQ:1003081775 on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFFileDownloadTask+GJCFAudioDownload.h"
#import "GJCFAudioFileUitil.h"

@implementation GJCFFileDownloadTask (GJCFAudioDownload)

+ (GJCFFileDownloadTask *)taskWithAudioFile:(GJCFAudioModel*)audioFile withObserver:(NSObject*)observer getTaskIdentifier:(NSString *__autoreleasing *)taskIdentifier
{
    if (!audioFile.remotePath) {
        
        NSLog(@"GJCFFileDownloadTask+GJCFAudioDownload 没有远程下载地址无法下载文件");
        return nil;
    }
    
    /* 设定缓存路径 */
    NSString *cachePath = nil;
    if (!audioFile.tempEncodeFilePath && audioFile.isNeedConvertEncodeToSave) {
        [GJCFAudioFileUitil setupAudioFileTempEncodeFilePath:audioFile];
        cachePath = audioFile.tempEncodeFilePath;
    }else{
        [GJCFAudioFileUitil setupAudioFileLocalStorePath:audioFile];
        cachePath = audioFile.localStorePath;
    }
    
    GJCFFileDownloadTask *task = [GJCFFileDownloadTask taskWithDownloadUrl:audioFile.remotePath withCachePath:cachePath withObserver:observer getTaskIdentifer:taskIdentifier];
    task.userInfo = @{@"audioFile": audioFile};
    
    
    return task;
}

@end
