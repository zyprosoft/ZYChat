//
//  GJCFAudioNetwork.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFFileUploadManager.h"
#import "GJCFFileDownloadManager.h"
#import "GJCFAudioModel.h"
#import "GJCFFileUploadTask+GJCFAudioUpload.h"
#import "GJCFFileDownloadTask+GJCFAudioDownload.h"
#import "GJCFAudioNetworkDelegate.h"

@interface GJCFAudioNetwork : NSObject

@property (nonatomic,strong)GJCFFileUploadManager *uploadManager;

@property (nonatomic,weak)id<GJCFAudioNetworkDelegate> delegate;

- (void)uploadAudioFile:(GJCFAudioModel *)audioFile;

- (void)downloadAudioFile:(GJCFAudioModel *)audioFile;

/* 下载完是否立即播放的参数判断 */
- (void)downloadAudioFileWithUrl:(NSString *)remoteAudioUrl withFinishDownloadPlayCheck:(BOOL)finishPlay withFileUniqueIdentifier:(NSString **)fileUniqueIdentifier;

/* 下载指定地址的音频文件 */
- (void)downloadAudioFileWithUrl:(NSString *)remoteAudioUrl withFileUniqueIdentifier:(NSString **)fileUniqueIdentifier;

@end
