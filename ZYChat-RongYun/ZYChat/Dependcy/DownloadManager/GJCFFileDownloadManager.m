//
//  GJCFFileDownloadManager.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-18.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFFileDownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "GJCFUitils.h"

static NSString * kGJCFFileDownloadManagerCompletionBlockKey = @"kGJCFFileUploadManagerCompletionBlockKey";

static NSString * kGJCFFileDownloadManagerProgressBlockKey = @"kGJCFFileUploadManagerProgressBlockKey";

static NSString * kGJCFFileDownloadManagerFaildBlockKey = @"kGJCFFileUploadManagerFaildBlockKey";

static NSString * kGJCFFileDownloadManagerObserverUniqueIdentifier = @"kGJCFFileDownloadManagerObserverUniqueIdentifier";

static NSString * kGJCFFileDownloadManagerQueue = @"com.gjcf.download.queue";

static dispatch_queue_t _gjcfFileDownloadManagerOperationQueue ;

@interface GJCFFileDownloadManager ()

@property (nonatomic,strong)NSMutableArray *taskArray;

@property (nonatomic,strong)NSMutableDictionary *taskOberverAction;

@property (nonatomic,strong)NSString *defaultHost;

@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation GJCFFileDownloadManager

+ (GJCFFileDownloadManager *)shareDownloadManager
{
    static GJCFFileDownloadManager *_downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        if (!_downloadManager) {
            _downloadManager = [[self alloc]init];
        }
    });
    return _downloadManager;
}

- (id)init
{
    if (self = [super init]) {
        
        self.taskArray = [[NSMutableArray alloc]init];
        self.taskOberverAction = [[NSMutableDictionary alloc]init];
        _gjcfFileDownloadManagerOperationQueue = dispatch_queue_create(kGJCFFileDownloadManagerQueue.UTF8String, NULL);
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.zyprosoft.com"]];
    }
    return self;
}


#pragma mark - 观察者调用
+ (NSString*)uniqueKeyForObserver:(NSObject*)observer
{
    return [NSString stringWithFormat:@"%@_%lu",kGJCFFileDownloadManagerObserverUniqueIdentifier,(unsigned long)[observer hash]];
}

#pragma mark - 公开方法

/* 设置默认主机地址 */
- (void)setDefaultDownloadHost:(NSString *)host
{
    if ([self.defaultHost isEqualToString:host]) {
        return;
    }
    self.defaultHost = host;
    
    if (self.requestOperationManager) {
        self.requestOperationManager = nil;
    }
    
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]init];

}

- (void)addTask:(GJCFFileDownloadTask *)task
{
    if (!task) {
        NSLog(@"GJFileDownloadManager 错误: 试图添加一个空的下载任务:%@",task);
        return;
    }
    
    /* 如果没有指定下载地址，那么就不开始了 */
    if (![task isValidateForDownload]) {
        NSLog(@"GJCFFileDownloadManager 错误: 下载任务没有目标下载地址:%@",task.downloadUrl);
        return;
    }
    
    dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
       
        /* 判断下载地址是否有主机地址，如果没有的话，给补全，我们默认没有找到http://就给它补全 */
        if (task.useDowloadManagerHost) {
            
            /* 如果当前没有设置下载主机地址，那么可以直接退出了 */
            if (self.defaultHost == nil) {
                return;
            }
            
            /* 主机地址最后一位是不是 '/' */
            unichar lastHostChar = [self.defaultHost characterAtIndex:self.defaultHost.length-1];
            NSString *lastHostString = [NSString stringWithFormat:@"%c",lastHostChar];
            
            unichar firstDownloadUrlChar = [task.downloadUrl characterAtIndex:0];
            NSString *firstDownloadUrlString = [NSString stringWithFormat:@"%c",firstDownloadUrlChar];
            
            /* 如果会产生 // 情况，我们要干掉这个情况 */
            if ([lastHostString isEqualToString:@"/"] && [firstDownloadUrlString isEqualToString:lastHostString]) {
                
                task.downloadUrl = [NSString stringWithFormat:@"%@%@",self.defaultHost,[task.downloadUrl substringToIndex:1]];
            }
            
        }else{
            
            if (![task.downloadUrl hasPrefix:@"http://"] && ![task.downloadUrl hasPrefix:@"https://"] && ![task.downloadUrl hasPrefix:@"ftp://"]) {
                task.downloadUrl = [NSString stringWithFormat:@"http://%@",task.downloadUrl];
            }
        }
        
        
        
        /* 如果有自定义的参数 */
        if (task.customUrlEncodedParams) {
            
            /* 判断自定义参数字符串的第一个字符是不是 & 如果是，那么我们就不用加了，如果不是，那么我们补上 */
            unichar firstChar = [task.customUrlEncodedParams characterAtIndex:0] ;
            NSString *firstCharString = [NSString stringWithFormat:@"%c",firstChar];
            
            if (![firstCharString isEqualToString:@"&"]) {
                
                task.downloadUrl = [NSString stringWithFormat:@"&%@",task.customUrlEncodedParams];
            }
        }
        
        /* 如果有相同的下载任务就不添加进入队列 */
        for (GJCFFileDownloadTask *dTask in self.taskArray) {
            
            if ([task isEqualToTask:dTask]) {
                
                /* 将这个任务的所有观察者添加到存在的任务的观察者中 */
                for (NSString *observer in task.taskObservers) {
                    [dTask addTaskObserverFromOtherTask:observer];
                }
                
                return;
            }
        }
        
        /* 建立下载链接 */
        NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:task.downloadUrl]];
        AFHTTPRequestOperation *downloadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:downloadRequest];
        downloadOperation.userInfo = @{@"task": task};
        
        NSLog(@"GJCFFileDownloadManager 开始下载 地址:%@",downloadRequest.URL.absoluteString);
        
        /* 观察三个任务状态 */
        [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //        NSLog(@"GJCFFileDownloadManager 下载成功:%@",operation.userInfo);
            
            dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
                
                NSDictionary *userInfo = operation.userInfo;
                GJCFFileDownloadTask *task = [userInfo objectForKey:@"task"];
                
                [self completionWithTask:task resultData:responseObject];
                
            });

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //        NSLog(@"GJCFFileDownloadManager 下载失败 :%@",error);
            
            dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
                
                NSDictionary *userInfo = operation.userInfo;
                GJCFFileDownloadTask *task = [userInfo objectForKey:@"task"];
                
                [self faildWithTask:task faild:error];

            });
            
        }];
        
        __weak typeof (downloadOperation) weakOperation = downloadOperation;
        [downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
            
                NSDictionary *userInfo = weakOperation.userInfo;
                GJCFFileDownloadTask *task = [userInfo objectForKey:@"task"];
                
                CGFloat uploadKbSize = totalBytesRead/1024.0f;
                CGFloat totoalSize = totalBytesExpectedToRead/1024.0f;
                CGFloat downloadProgreessValue = (uploadKbSize/1024.f)/(totoalSize/1024.f);
                
                [self progressWithTask:task progress:downloadProgreessValue];
                
            });
            
        }];
        
        /* 加入队列 */
        if (self.requestOperationManager) {
            
            [self.requestOperationManager.operationQueue addOperation:downloadOperation];
            task.taskState = GJFileDownloadStateDownloading;
            [self.taskArray addObject:task];
        }
        
    });
}

#pragma mark - 请求的三个状态
- (void)completionWithTask:(GJCFFileDownloadTask *)task resultData:(NSData*)downloadData
{
    NSArray *taskObservers = task.taskObservers;
    task.taskState = GJFileDownloadStateSuccess;
    
    NSLog(@"GJCFFileDownloadManager 找到任务所有观察者:%@ for TaskUrl:%@",taskObservers,task.downloadUrl);
    
    /* 如果任务设定了存储路径 */
    BOOL cacheState = NO;
    if (downloadData) {
        
        if (task.cachePath) {
            
            cacheState = [downloadData writeToFile:task.cachePath atomically:YES];

        }
        
        for (NSString *path in task.cacheToPaths) {
            
            [downloadData writeToFile:path atomically:YES];
        }
    }
    
    [taskObservers enumerateObjectsUsingBlock:^(NSString *observeUniqueIdentifier, NSUInteger idx, BOOL *stop) {
       
        NSMutableDictionary *actionDict = [self.taskOberverAction objectForKey:observeUniqueIdentifier];
        
//        NSLog(@"GJCFFileDownloadManager 找到响应任务block:%@",actionDict);
        
        if (actionDict) {
            
            GJCFFileDownloadManagerCompletionBlock completionBlcok = [actionDict objectForKey:kGJCFFileDownloadManagerCompletionBlockKey];
            
            
            if (completionBlcok) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    completionBlcok(task,downloadData,cacheState);

                });
                
            }
            
        }
        
    }];
    
    [self.taskArray removeObject:task];
    
    /* 取消相同的下载任务 */
    [self cancelSameUrlDownloadTaskForTask:task];
}

- (void)progressWithTask:(GJCFFileDownloadTask *)task progress:(CGFloat)progress
{
    NSArray *taskObservers = task.taskObservers;

    [taskObservers enumerateObjectsUsingBlock:^(NSString *observeUniqueIdentifier, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *actionDict = [self.taskOberverAction objectForKey:observeUniqueIdentifier];
        
        if (actionDict) {
            
            GJCFFileDownloadManagerProgressBlock progressBlcok = [actionDict objectForKey:kGJCFFileDownloadManagerProgressBlockKey];
            
            
            if (progressBlcok) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    progressBlcok(task,progress);

                });
                
            }
            
        }
        
    }];

}

- (void)faildWithTask:(GJCFFileDownloadTask *)task faild:(NSError*)error
{
    NSArray *taskObservers = task.taskObservers;
    task.taskState = GJFileDownloadStateHadFaild;
    
    [taskObservers enumerateObjectsUsingBlock:^(NSString *observeUniqueIdentifier, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *actionDict = [self.taskOberverAction objectForKey:observeUniqueIdentifier];
        
        if (actionDict) {
            
            GJCFFileDownloadManagerFaildBlock faildBlcok = [actionDict objectForKey:kGJCFFileDownloadManagerFaildBlockKey];
            
            
            if (faildBlcok) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    faildBlcok(task,error);

                });
            }
            
        }
        
    }];

    [self.taskArray removeObject:task];
}

#pragma mark - 设定任务观察者
/*
 * 设定观察者完成方法
 */
- (void)setDownloadCompletionBlock:(GJCFFileDownloadManagerCompletionBlock)completionBlock forObserver:(NSObject*)observer
{
    if (!observer) {
        return;
    }
    
    NSString *observerUnique = [GJCFFileDownloadManager uniqueKeyForObserver:observer];
    
    NSMutableDictionary *observerActionDict = nil;
    if (![self.taskOberverAction objectForKey:observerUnique]) {
        
        observerActionDict = [NSMutableDictionary dictionary];
        
    }else{
        
        observerActionDict = [self.taskOberverAction objectForKey:observerUnique];
    }
    
    [observerActionDict setObject:completionBlock forKey:kGJCFFileDownloadManagerCompletionBlockKey];
    [self.taskOberverAction setObject:observerActionDict forKey:observerUnique];
}

/*
 * 设定观察者进度方法
 */
- (void)setDownloadProgressBlock:(GJCFFileDownloadManagerProgressBlock)progressBlock forObserver:(NSObject*)observer
{
    if (!observer) {
        return;
    }
    
    NSString *observerUnique = [GJCFFileDownloadManager uniqueKeyForObserver:observer];

    NSMutableDictionary *observerActionDict = nil;
    if (![self.taskOberverAction objectForKey:observerUnique]) {
        
        observerActionDict = [NSMutableDictionary dictionary];
        
    }else{
        
        observerActionDict = [self.taskOberverAction objectForKey:observerUnique];
    }
    
    [observerActionDict setObject:progressBlock forKey:kGJCFFileDownloadManagerProgressBlockKey];
    [self.taskOberverAction setObject:observerActionDict forKey:observerUnique];
}

/*
 * 设定观察者失败方法
 */
- (void)setDownloadFaildBlock:(GJCFFileDownloadManagerFaildBlock)faildBlock forObserver:(NSObject*)observer
{
    if (!observer) {
        return;
    }
    
    NSString *observerUnique = [GJCFFileDownloadManager uniqueKeyForObserver:observer];

    NSMutableDictionary *observerActionDict = nil;
    if (![self.taskOberverAction objectForKey:observerUnique]) {
        
        observerActionDict = [NSMutableDictionary dictionary];
        
    }else{
        
        observerActionDict = [self.taskOberverAction objectForKey:observerUnique];
    }
    
    [observerActionDict setObject:faildBlock forKey:kGJCFFileDownloadManagerFaildBlockKey];
    [self.taskOberverAction setObject:observerActionDict forKey:observerUnique];
}

/*
 * 将观察者的block全部清除
 */
- (void)clearTaskBlockForObserver:(NSObject *)observer
{
    if (!observer) {
        return;
    }
    
    NSString *observerUnique = [GJCFFileDownloadManager uniqueKeyForObserver:observer];

    if (![self.taskOberverAction.allKeys containsObject:observerUnique]) {
        return;
    }
    
    [self.taskOberverAction removeObjectForKey:observerUnique];
}

- (NSInteger)taskIndexForUniqueIdentifier:(NSString *)identifier
{
    NSInteger resultIndex = NSNotFound;
    for (int i = 0; i < self.taskArray.count ; i++) {
        
        GJCFFileDownloadTask *task = [self.taskArray objectAtIndex:i];
        
        if ([task.taskUniqueIdentifier isEqualToString:identifier]) {
            
            resultIndex = i;
            
            break;
        }
    }
    return resultIndex;
}

- (void)cancelTask:(NSString *)taskUniqueIdentifier
{
    if (GJCFStringIsNull(taskUniqueIdentifier)) {
        return;
    }
    
    dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
        
        NSInteger taskIndex = [self taskIndexForUniqueIdentifier:taskUniqueIdentifier];
        if (taskIndex == NSNotFound) {
            return;
        }
        GJCFFileDownloadTask *task = [self.taskArray objectAtIndex:taskIndex];
        
        /* 移除任务的所有观察者block */
        [task.taskObservers enumerateObjectsUsingBlock:^(NSString *observerIdentifier, NSUInteger idx, BOOL *stop) {
            
            [self clearTaskBlockForObserver:observerIdentifier];
            
        }];
        
        /* 退出任务 */
        for (AFHTTPRequestOperation *request in self.requestOperationManager.operationQueue.operations) {
            
            GJCFFileDownloadTask *destTask = request.userInfo[@"task"];
            
            if ([task.taskUniqueIdentifier isEqualToString:destTask.taskUniqueIdentifier]) {
                
                [request cancel];
                
                [self.taskArray removeObjectAtIndex:taskIndex];
                break;
            }
        }    

    });
    
}

- (NSArray *)groupTaskByUniqueIdentifier:(NSString *)groupTaskIdnetifier
{
    NSMutableArray *groupTaskArray = [NSMutableArray array];
    
    for (GJCFFileDownloadTask *task in self.taskArray) {
        
        if ([task.groupTaskIdentifier isEqualToString:groupTaskIdnetifier]) {
            
            [groupTaskArray addObject:task];
        }
    }
    
    return groupTaskArray;
}

- (void)cancelGroupTask:(NSString *)groupTaskUniqueIdentifier
{
    if (!groupTaskUniqueIdentifier || [groupTaskUniqueIdentifier isKindOfClass:[NSNull class]] || groupTaskUniqueIdentifier.length == 0 || [groupTaskUniqueIdentifier isEqualToString:@""]) {
        return;
    }
    
    dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
        
        NSArray *groupTaskArray = [self groupTaskByUniqueIdentifier:groupTaskUniqueIdentifier];
        if (groupTaskArray.count == 0) {
            return;
        }
        
        for (GJCFFileDownloadTask *task in groupTaskArray) {
            
            /* 移除任务的所有观察者block */
            [task.taskObservers enumerateObjectsUsingBlock:^(NSString *observerIdentifier, NSUInteger idx, BOOL *stop) {
                
                [self clearTaskBlockForObserver:observerIdentifier];
                
            }];
            
            /* 退出任务 */
            for (AFHTTPRequestOperation *request in self.requestOperationManager.operationQueue.operations) {
                
                GJCFFileDownloadTask *destTask = request.userInfo[@"task"];
                
                if ([task.taskUniqueIdentifier isEqualToString:destTask.taskUniqueIdentifier]) {
                    
                    [request cancel];
                    
                    [self.taskArray removeObject:task];
                    
                    break;
                }
            }
            
        }
        
    });
}

- (void)cancelTaskWithCompletion:(NSString *)taskUniqueIdentifier
{
    if (GJCFStringIsNull(taskUniqueIdentifier)) {
        return;
    }
    
    dispatch_async(_gjcfFileDownloadManagerOperationQueue, ^{
        
        NSInteger taskIndex = [self taskIndexForUniqueIdentifier:taskUniqueIdentifier];
        if (taskIndex == NSNotFound) {
            return;
        }
        GJCFFileDownloadTask *task = [self.taskArray objectAtIndex:taskIndex];
        
        /* 退出任务 */
        for (AFHTTPRequestOperation *request in self.requestOperationManager.operationQueue.operations) {
            
            GJCFFileDownloadTask *destTask = request.userInfo[@"task"];
            
            if ([task.taskUniqueIdentifier isEqualToString:destTask.taskUniqueIdentifier]) {
                
                [request cancel];
                
                break;
            }
        }
        
        /* 如果任务设定了存储路径 */
        BOOL cacheState = YES;
        NSData *downloadData = [NSData dataWithContentsOfFile:task.cachePath];
        
        [task.taskObservers enumerateObjectsUsingBlock:^(NSString *observeUniqueIdentifier, NSUInteger idx, BOOL *stop) {
            
            NSMutableDictionary *actionDict = [self.taskOberverAction objectForKey:observeUniqueIdentifier];
            
            //        NSLog(@"GJCFFileDownloadManager 找到响应任务block:%@",actionDict);
            
            if (actionDict) {
                
                GJCFFileDownloadManagerCompletionBlock completionBlcok = [actionDict objectForKey:kGJCFFileDownloadManagerCompletionBlockKey];
                
                if (completionBlcok) {
                    
                    completionBlcok(task,downloadData,cacheState);
                }
                
            }
            
        }];
        
        /* 移除任务的所有观察者block */
        [task.taskObservers enumerateObjectsUsingBlock:^(NSString *observerIdentifier, NSUInteger idx, BOOL *stop) {
            
            [self clearTaskBlockForObserver:observerIdentifier];
            
        }];
        
        [self.taskArray removeObjectAtIndex:taskIndex];

    });
    
}

- (void)cancelSameUrlDownloadTaskForTask:(GJCFFileDownloadTask *)task
{
    for (GJCFFileDownloadTask *dTask in self.taskArray) {
        
        if ([task isEqualToTask:dTask]) {
            
            [self cancelTaskWithCompletion:dTask.taskUniqueIdentifier];
        }
    }
}

@end
