//
//  GJCFFileDownloadManager.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFFileDownloadTask.h"

@class GJCFFileDownloadTask;

typedef void (^GJCFFileDownloadManagerCompletionBlock) (GJCFFileDownloadTask *task,NSData *fileData,BOOL isFinishCache);

typedef void (^GJCFFileDownloadManagerProgressBlock) (GJCFFileDownloadTask *task,CGFloat progress);

typedef void (^GJCFFileDownloadManagerFaildBlock) (GJCFFileDownloadTask *task,NSError *error);

@interface GJCFFileDownloadManager : NSObject


+ (GJCFFileDownloadManager *)shareDownloadManager;


/* 设置下载服务器地址，不是必须的，是为了用来当没有主机地址的时候，可以用来补全 */
- (void)setDefaultDownloadHost:(NSString *)host;


/* 添加一个下载任务 */
- (void)addTask:(GJCFFileDownloadTask *)task;

/*
 * 观察者唯一标识生成方法
 */
+ (NSString*)uniqueKeyForObserver:(NSObject*)observer;

/* 
 * 设定观察者完成方法
 */
- (void)setDownloadCompletionBlock:(GJCFFileDownloadManagerCompletionBlock)completionBlock forObserver:(NSObject*)observer;

/*
 * 设定观察者进度方法
 */
- (void)setDownloadProgressBlock:(GJCFFileDownloadManagerProgressBlock)progressBlock forObserver:(NSObject*)observer;

/*
 * 设定观察者失败方法
 */
- (void)setDownloadFaildBlock:(GJCFFileDownloadManagerFaildBlock)faildBlock forObserver:(NSObject*)observer;

/*
 * 将观察者的block全部清除
 */
- (void)clearTaskBlockForObserver:(NSObject *)observer;

/**
 *  退出指定下载任务
 *
 *  @param taskUniqueIdentifier 下载任务标示
 */
- (void)cancelTask:(NSString *)taskUniqueIdentifier;

/**
 *  退出有相同标示的下载任务组
 *
 *  @param groupTaskUniqueIdentifier
 */
- (void)cancelGroupTask:(NSString *)groupTaskUniqueIdentifier;

@end
