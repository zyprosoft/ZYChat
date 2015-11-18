//
//  GJCFFileDownloadTask.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

/* 下载任务的状态 */
typedef NS_ENUM(NSUInteger, GJCFFileDownloadState) {
    
    /* 从来没有执行过这个任务 */
    GJFileDownloadStateNeverBegin = 0,
    
    /* 任务已经执行失败过 */
    GJFileDownloadStateHadFaild = 1,
    
    /* 任务正在执行 */
    GJFileDownloadStateDownloading = 2,
    
    /* 任务执行已经成功 */
    GJFileDownloadStateSuccess = 3,
    
    /* 任务被取消了 */
    GJFileDownloadStateCancel = 4,
};

@interface GJCFFileDownloadTask : NSObject

/* 任务唯一标示 */
@property (nonatomic,readonly)NSString *taskUniqueIdentifier;

/* 任务执行状态 */
@property (nonatomic,assign)GJCFFileDownloadState taskState;

/* 任务观察者 */
@property (nonatomic,readonly)NSArray *taskObservers;

/* 任务需要缓存的路径组 */
@property (nonatomic,readonly)NSArray *cacheToPaths;

/* 下载数据指定缓存路径 */
@property (nonatomic,strong)NSString *cachePath;

/* 下载任务指定的自定义参数，通常时需要URLEncode之后加到url后面的 */
@property (nonatomic,strong)NSString *customUrlEncodedParams;

/* 将要下载文件的路径 */
@property (nonatomic,strong)NSString *downloadUrl;

/* 是否使用下载管理器的主机地址，默认不使用 */
@property (nonatomic,assign)BOOL useDowloadManagerHost;

/* 用户自定义内容 */
@property (nonatomic,strong)NSDictionary *userInfo;

/* 下载任务组标识，可以用来退出一组请求 */
@property (nonatomic,strong)NSString *groupTaskIdentifier;

- (void)addTaskObserver:(NSObject*)observer;

- (void)addTaskObserverFromOtherTask:(NSString *)observeIdentifier;

- (void)addTaskCachePath:(NSString *)cachePath;

- (void)removeTaskObserver:(NSObject*)observer;

+ (GJCFFileDownloadTask *)taskWithDownloadUrl:(NSString *)downloadUrl withCachePath:(NSString*)cachePath withObserver:(NSObject*)observer getTaskIdentifer:(NSString **)taskIdentifier;

/* 任务自检是否能下载 */
- (BOOL)isValidateForDownload;

- (BOOL)isEqualToTask:(GJCFFileDownloadTask *)task;

@end
