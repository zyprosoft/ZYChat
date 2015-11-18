//
//  GJCFFileDownloadTask+GJCFAudioDownload.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
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
    if (!audioFile.tempEncodeFilePath) {
        [GJCFAudioFileUitil setupAudioFileTempEncodeFilePath:audioFile];
    }
    
    GJCFFileDownloadTask *task = [GJCFFileDownloadTask taskWithDownloadUrl:audioFile.remotePath withCachePath:audioFile.tempEncodeFilePath withObserver:observer getTaskIdentifer:taskIdentifier];
    task.userInfo = @{@"audioFile": audioFile};
    
    
    return task;
}

@end
