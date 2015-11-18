//
//  GJCFAudioNetwork.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAudioNetwork.h"

@interface GJCFAudioNetwork ()

@property (nonatomic,strong)NSMutableArray *uploadTasksArray;

@property (nonatomic,strong)NSMutableArray *downloadTasksArray;

@end

@implementation GJCFAudioNetwork

- (id)init
{
    if (self = [super init]) {
        
        self.uploadTasksArray = [[NSMutableArray alloc]init];
        self.downloadTasksArray = [[NSMutableArray alloc]init];
        
        /* 设定任务上传组件 */
        [self setAudioUploadManager];
        
        /* 延迟一秒观察任务下载任务观察 */
        [self performSelector:@selector(observeDownloadTask) withObject:nil afterDelay:1.f];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[GJCFFileDownloadManager shareDownloadManager]clearTaskBlockForObserver:self];
}

#pragma mark - 上传任务观察
- (void)setAudioUploadManager
{
    if (self.uploadManager) {
        self.uploadManager = nil;
    }
    self.uploadManager = [[GJCFFileUploadManager alloc]init];
    
    /* 设定任务观察 */
    [self observeUploadTask];
}

- (void)observeUploadTask
{
    __weak typeof(self)weakSelf = self;
    
    [self.uploadManager setCompletionBlock:^(GJCFFileUploadTask *task, NSDictionary *resultDict) {
       
        NSDictionary *result = [resultDict objectForKey:@"result"];
        
        [weakSelf uploadCompletionWithTask:task resultDict:result];
        
    }];
    
    [self.uploadManager setProgressBlock:^(GJCFFileUploadTask *updateTask, CGFloat progressValue) {
       
        [weakSelf uploadProgressWithTask:updateTask progress:progressValue];
    }];
    
    [self.uploadManager setFaildBlock:^(GJCFFileUploadTask *task, NSError *error) {
       
        [weakSelf uploadFaildWithTask:task faild:error];
        
    }];
}

#pragma mark - 上传任务处理
- (void)uploadCompletionWithTask:(GJCFFileUploadTask *)task resultDict:(NSDictionary *)result
{
    GJCFAudioModel *originFile = task.userInfo[@"audioFile"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:formateUploadResult:formateDict:)]) {
        
      GJCFAudioModel  *formatedModel = [self.delegate audioNetwork:self formateUploadResult:originFile formateDict:result];
        
        if (formatedModel) {
            
            formatedModel.isBeenUploaded = YES;

            if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:finishUploadAudioFile:)]) {
                
                [self.delegate audioNetwork:self finishUploadAudioFile:formatedModel];
            }
            
        }else{
            
            GJCFAudioModel *originFile = task.userInfo[@"audioFile"];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:forAudioFile:uploadFaild:)]) {
                
                NSError *serverError = [NSError errorWithDomain:@"http://www.ZYProSoft" code:-123 userInfo:@{@"msg": @"参数非法"}];
                [self.delegate audioNetwork:self forAudioFile:originFile.localStorePath uploadFaild:serverError];
            }
            
        }
    }
}

- (void)uploadProgressWithTask:(GJCFFileUploadTask *)task progress:(CGFloat)progress
{
    GJCFAudioModel *originFile = task.userInfo[@"audioFile"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:forAudioFile:uploadProgress:)]) {
        
        [self.delegate audioNetwork:self forAudioFile:originFile.localStorePath uploadProgress:progress];
        
    }
}

- (void)uploadFaildWithTask:(GJCFFileUploadTask *)task faild:(NSError *)error
{
    GJCFAudioModel *originFile = task.userInfo[@"audioFile"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:forAudioFile:uploadFaild:)]) {
        
        [self.delegate audioNetwork:self forAudioFile:originFile.localStorePath uploadFaild:error];
    }
}

#pragma mark - 下载任务观察
- (void)observeDownloadTask
{
    __weak typeof(self)weakSelf = self;
    [[GJCFFileDownloadManager shareDownloadManager]setDownloadCompletionBlock:^(GJCFFileDownloadTask *task, NSData *fileData, BOOL isFinishCache) {
        
        [weakSelf downloadCompletion:task withFileData:fileData isFinishCached:isFinishCache];
        
    } forObserver:self];
    
    [[GJCFFileDownloadManager shareDownloadManager]setDownloadProgressBlock:^(GJCFFileDownloadTask *task, CGFloat progress) {
        
        [weakSelf downloadProgress:task withPorgress:progress];
        
    } forObserver:self];
    
    [[GJCFFileDownloadManager shareDownloadManager]setDownloadFaildBlock:^(GJCFFileDownloadTask *task, NSError *error) {
        
        [weakSelf downloadFaild:task faild:error];
        
    } forObserver:self];
}

#pragma mark - 下载具体处理
- (void)downloadCompletion:(GJCFFileDownloadTask *)task withFileData:(NSData *)fileData isFinishCached:(BOOL)finishCache
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:finishDownloadWithAudioFile:)]) {
        
        GJCFAudioModel *audioFile = task.userInfo[@"audioFile"];
        
        [self.delegate audioNetwork:self finishDownloadWithAudioFile:audioFile];
    }
}

- (void)downloadProgress:(GJCFFileDownloadTask *)task withPorgress:(CGFloat)progress
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:forAudioFile:downloadProgress:)]) {
        
        GJCFAudioModel *audioFile = task.userInfo[@"audioFile"];

        [self.delegate audioNetwork:self forAudioFile:audioFile.uniqueIdentifier downloadProgress:progress];
    }
}

- (void)downloadFaild:(GJCFFileDownloadTask *)task faild:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioNetwork:forAudioFile:downloadFaild:)]) {
        
        GJCFAudioModel *audioFile = task.userInfo[@"audioFile"];

        [self.delegate audioNetwork:self forAudioFile:audioFile.remotePath downloadFaild:error];
        
    }
    
}

- (void)uploadAudioFile:(GJCFAudioModel *)audioFile
{
    NSString *taskIdentifier = nil;
    GJCFFileUploadTask *task = [GJCFFileUploadTask taskWithAudioFile:audioFile withObserver:self withTaskIdentifier:&taskIdentifier];
    
    if (!task) {
        NSLog(@"GJCFAudioNetwork 不能开始一个空的上传任务");
        return;
    }
    
    [self.uploadTasksArray addObject:taskIdentifier];
    
    if (self.uploadManager) {
        
        [self.uploadManager addTask:task];
        
        NSLog(@"GJCFAudioNetwork task:%@ begin upload .... ",taskIdentifier);
    }
    
}

- (void)downloadAudioFile:(GJCFAudioModel *)audioFile
{
    /* 创建下载任务开始下载 */
    NSString *taskIdentifier = nil;
    GJCFFileDownloadTask *task = [GJCFFileDownloadTask taskWithAudioFile:audioFile withObserver:self getTaskIdentifier:&taskIdentifier];
    
    [self.downloadTasksArray addObject:taskIdentifier];
    
    [[GJCFFileDownloadManager shareDownloadManager] addTask:task];
    
    NSLog(@"GJCFAudioNetwork task:%@ begin dowload .... ",taskIdentifier);
}

- (void)downloadAudioFileWithUrl:(NSString *)remoteAudioUrl withFinishDownloadPlayCheck:(BOOL)finishPlay withFileUniqueIdentifier:(NSString **)fileUniqueIdentifier
{
    GJCFAudioModel *audioFile = [[GJCFAudioModel alloc]init];
    audioFile.remotePath = remoteAudioUrl;
    audioFile.isNeedConvertEncodeToSave = YES;
    audioFile.shouldPlayWhileFinishDownload = finishPlay;
    audioFile.isDeleteWhileFinishConvertToLocalFormate = YES;
    *fileUniqueIdentifier = audioFile.uniqueIdentifier;
    
    [self downloadAudioFile:audioFile];
}

- (void)downloadAudioFileWithUrl:(NSString *)remoteAudioUrl withFileUniqueIdentifier:(NSString **)fileUniqueIdentifier
{
    [self downloadAudioFileWithUrl:remoteAudioUrl withFinishDownloadPlayCheck:NO withFileUniqueIdentifier:fileUniqueIdentifier];
}

@end
