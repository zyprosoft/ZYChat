//
//  GJCFFileUploadTask.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-12.
//  Copyright (c) 2014年 ZYProSoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFUploadFileModel.h"

/* 上传任务的状态 */
typedef NS_ENUM(NSUInteger, GJCFFileUploadState) {
    
    /* 从来没有执行过这个任务 */
    GJFileUploadStateNeverBegin = 0,
    
    /* 任务已经执行失败过 */
    GJFileUploadStateHadFaild = 1,
    
    /* 任务正在执行 */
    GJFileUploadStateUploading = 2,
    
    /* 任务执行已经成功 */
    GJFileUploadStateSuccess = 3,
    
    /* 任务被取消了 */
    GJFileUploadStateCancel = 4,
};

/* 文件上传任务 */
@interface GJCFFileUploadTask : NSObject<NSCoding>

/* 当前状态 */
@property (nonatomic,assign)GJCFFileUploadState uploadState;

/* 唯一标示 */
@property (nonatomic,readonly)NSString *uniqueIdentifier;

/* 自定义请求的HttpHeader */
@property (nonatomic,strong)NSDictionary *customRequestHeader;

/* 自定义请求的参数内容 */
@property (nonatomic,strong)NSDictionary *customRequestParams;

/* 需要上传文件的对象数组，包含GJCFUploadFileModel */
@property (nonatomic,strong)NSMutableArray *filesArray;

/* 用户自定义信息 */
@property (nonatomic,strong)NSDictionary *userInfo;

/* 用户自己设定的任务索引号 */
@property (nonatomic,assign)NSInteger customTaskIndex;

/* 任务的观察者，用来响应任务执行的block, 支持单任务多观察者 */
@property (nonatomic,readonly)NSArray *taskObservers;

// ==========   为了内存考虑，不推荐使用直接在任务中填充文件二进制数据，但是如果必须使用文件二进制数据，填充任务，请注意内存使用问题 ===========

/* ============== 推荐使用下面得给任务赋予待上传文件路径的方式方式初始化任务 ================= */

/*
 * 使用待上传文件组的路径来上传这些文件
 */
+ (GJCFFileUploadTask *)taskWithUploadFilePaths:(NSArray *)filePaths usingCommonExtension:(BOOL)isCommmonExtentsion commonExtension:(NSString *)commonExtension withFormName:(NSString *)formName taskObserver:(NSObject*)observer getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 指定特殊这个任务特殊的观察者情况下: 单个文件路径上传任务便捷生成
 */
+ (GJCFFileUploadTask *)taskWithFilePath:(NSString*)filePath withFileName:(NSString*)fileName withFormName:(NSString*)formName taskObserver:(NSObject*)observer getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/* ================= 下面是直接传递待上传文件二进制数据的任务初始化，使用时需谨慎,在任务失败的情况下，会保留在内存中，如果不需要这个任务数据可以在调用Manager接口移除任务 ==================== */
/* 
 * 指定特殊这个任务特殊的观察者情况下: 相同属性，无文件名的图片便捷任务生成
 */
+ (GJCFFileUploadTask *)taskWithUploadImages:(NSArray *)imagesArray commonExtension:(NSString*)extention withFormName:(NSString*)formName taskObserver:(NSObject*)observer getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 指定特殊这个任务特殊的观察者情况下: 单个文件上传任务便捷生成 
 */
+ (GJCFFileUploadTask *)taskWithFileData:(NSData*)fileData withFileName:(NSString*)fileName withFormName:(NSString*)formName taskObserver:(NSObject*)observer getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 指定特殊这个任务特殊的观察者情况下: 文件组上传任务
 */
+ (GJCFFileUploadTask *)taskWithMutilFile:(NSArray*)fileModelArray taskObserver:(NSObject*)observer getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 指定特殊这个任务特殊的观察者情况下: 单个文件上传任务 
 */
+ (GJCFFileUploadTask *)taskForFile:(GJCFUploadFileModel*)aFile taskObserver:(NSObject*)observer getTaskUniqueIdentifier:(NSString *__autoreleasing *)taskIdentifier;


/*
 * 默认由UploadManager指定观察者情况下: 相同属性，无文件名的图片便捷任务生成 
 */
+ (GJCFFileUploadTask *)taskWithUploadImages:(NSArray *)imagesArray commonExtension:(NSString*)extention withFormName:(NSString*)formName getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 默认由UploadManager指定观察者情况下: 单个文件上传任务便捷生成
 */
+ (GJCFFileUploadTask *)taskWithFileData:(NSData*)fileData withFileName:(NSString*)fileName withFormName:(NSString*)formName getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 默认由UploadManager指定观察者情况下: 文件组上传任务 
 */
+ (GJCFFileUploadTask *)taskWithMutilFile:(NSArray*)fileModelArray getTaskUniqueIdentifier:(NSString**)taskIdentifier;

/*
 * 默认由UploadManager指定观察者情况下: 单个文件上传任务
 */
+ (GJCFFileUploadTask *)taskForFile:(GJCFUploadFileModel*)aFile getTaskUniqueIdentifier:(NSString *__autoreleasing *)taskIdentifier;

/*
 * 根据任务唯一标示符判定两个任务是否相同 
 */
- (BOOL)isEqual:(GJCFFileUploadTask*)aTask;

/*
 * 单任务多观察者添加 
 */
- (void)addNewTaskObserver:(id)observer;

/*
 * 移除任务观察者 
 */
- (void)removeTaskObserver:(id)observer;

/*
 * 移除所有任务观察者 
 */
- (void)removeAllTaskObserver;

/*
 * 单任务多观察者添加观察者唯一标示 
 */
- (void)addNewTaskObserverUniqueIdentifier:(NSString*)uniqueId;

/*
 * 单任务多观察移除加观察者唯一标示 
 */
- (void)removeTaskObserverUniqueIdentifier:(NSString*)uniqueId;

/*
 * 判断某个观察者Id是否存在 
 */
- (BOOL)taskIsObservedByUniqueIdentifier:(NSString*)uniqueId;

/* 
 * 该任务是否符合上传条件
 */
- (BOOL)isValidateBeingForUpload;

@end
