//
//  GJCFFileUploadManager.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-12.
//  Copyright (c) 2014年 ZYProSoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJCFFileUploadTask.h"

/* 文件上传进度,该block会在子线程调用，请务必将UI更新代码放在主线执行 */
typedef void (^GJCFFileUploadManagerUpdateTaskProgressBlock) (GJCFFileUploadTask *updateTask,CGFloat progressValue);

/* 文件上传完成,该block会在子线程调用，请务必将UI更新代码放在主线执行 */
typedef void (^GJCFFileUploadManagerTaskCompletionBlock) (GJCFFileUploadTask *task,NSDictionary *resultDict);

/* 文件上传失败,该block会在子线程调用，请务必将UI更新代码放在主线执行 */
typedef void (^GJCFFileUploadManagerTaskFaildBlock) (GJCFFileUploadTask *task,NSError *error);

/* 文件上传组件 */
@interface GJCFFileUploadManager : NSObject

/*
 * 默认是前台执行的上传任务的进度block 
 */
@property (nonatomic,copy)GJCFFileUploadManagerUpdateTaskProgressBlock progressBlock;

/*
 * 默认是前台执行的上传任务的完成block 
 */
@property (nonatomic,copy)GJCFFileUploadManagerTaskCompletionBlock completionBlock;

/*
 * 默认是前台执行的上传任务的失败block 
 */
@property (nonatomic,copy)GJCFFileUploadManagerTaskFaildBlock faildBlock;

/* 有这个可以更好的提示block实现*/
- (void)setCompletionBlock:(GJCFFileUploadManagerTaskCompletionBlock)completionBlock;

/* 有这个可以更好的提示block实现*/
- (void)setProgressBlock:(GJCFFileUploadManagerUpdateTaskProgressBlock)progressBlock;

/* 有这个可以更好的提示block实现*/
- (void)setFaildBlock:(GJCFFileUploadManagerTaskFaildBlock)faildBlock;

/*
 * 为某个观察对象建立成功观察状态block 
 */
- (void)setCompletionBlock:(GJCFFileUploadManagerTaskCompletionBlock)completionBlock forObserver:(NSObject*)observer;

/*
 * 为某个观察对象建立进度观察状态block 
 */
- (void)setProgressBlock:(GJCFFileUploadManagerUpdateTaskProgressBlock)progressBlock forObserver:(NSObject*)observer;

/*
 * 为某个观察对象建立失败观察状态block 
 */
- (void)setFaildBlock:(GJCFFileUploadManagerTaskFaildBlock)faildBlock forObserver:(NSObject*)observer;

/*
 * 设定当前前台的观察者,这个观察者可以实现观察三个进度的block 
 */
- (void)setCurrentObserver:(NSObject*)observer;

/* 
 * 重要注释：谨慎使用单例共享模式
 *
 * 为了更好的实现上传组件对任务的观察，并且不让观察者因为更新UI问题而造成观察者引用计数加1却无法在Dealloc的时候减1的情况
 *
 * 单例模式下设定前台的观察任务block的时候，请注意观察这个任务是否当前观察者想处理的任务
 *
 * 通过 GJCFFileUploadTask 的方法，判断自己是否这个任务的观察者 :  - (BOOL)taskIsObservedByUniqueIdentifier:(NSString*)uniqueId;
 *
 * 请谨慎按照下面的规范使用单例模式
 *
 */

/* ========================= 单例模式下任务观察范例 ========================= */

    /* 创建观察者弱引用指针,避免引用计数加1,导致无法释放
     __weak typeof(self)weakSelf = self;
     
    任务执行成功
    [[GJCFFileUploadManager shareUploadManager] setCompletionBlock:^(GJCFFileUploadTask *task,NSDictionary *resultDict){
    
        NSLog(@"GJImageUpload sucess:%@",resultDict[@"result"]);
    
        NSDictionary *result = resultDict[@"result"];
    
        //采用弱引用指针调用对应响应的方法
        [weakSelf updateUIByCompletion:task result:result];
    
    }];

    任务执行进度
    [[GJCFFileUploadManager shareUploadManager]setProgressBlock:^(GJCFFileUploadTask *updateTask,CGFloat progressValue){
    
        //采用弱引用指针调用对应响应的方法
        [weakSelf updateUIByProgress:updateTask percent:progressValue];
    
    }];

    任务执行失败
    [[GJCFFileUploadManager shareUploadManager] setFaildBlock:^(GJCFFileUploadTask *task,NSError *error){
    
        //采用弱引用指针调用对应响应的方法
        [weakSelf updateUIByFaild:task faild:error];
    
    }];*/

/* ====================================================================== */

/* 单例共享 */
+ (GJCFFileUploadManager *)shareUploadManager;

/* ========================= 非单例模式下任务观察范例 ========================= */

    /* 
     
     创建自身弱引用指针，避免循环引用问题
    __weak typeof(self)weakSelf = self;

    [self.fileUploadManager setProgressBlock:^(GJCFFileUploadTask *updateTask,CGFloat progressValue){
    
          weakSelf.xxx = @"xxx";
    
    }];
     
     [self.fileUploadManager setCompletionBlock:^(GJCFFileUploadTask *task,NSDictionary *resultDict){
     
          weakSelf.xxx = @"xxx";

     }];
     
     [self.fileUploadManager setFaildBlock:^(GJCFFileUploadTask *task,NSError *error){
    
         weakSelf.xxx = @"xxx";
     
     }];
     
     */

/* ====================================================================== */

/*
 * 非单例模式初始化
 *
 * 如果作为成员变量使用，编译器会主动触发循环引用警告，可以更容易更早的注意到循环引用问题
 *
 */
- (instancetype)initWithOwner:(id)owner;

/*
 * 设置当前文件上传服务的默认地址 
 */
- (void)setDefaultHostUrl:(NSString*)url;

/*
 * 设置文件上传的请求路径 
 */
- (void)setDefaultUploadPath:(NSString*)path;

/*
 * 设置文件上传时候的默认参数 
 */
- (void)setDefaultRequestParams:(NSDictionary*)parma;

/*
 * 设置文件上传时候的默认HttpHeader 
 */
- (void)setDefaultRequestHeader:(NSDictionary*)requestHeaders;

/*
 * 添加指定文件上传时候的默认HttpHeader
 */
- (void)addRequestHeader:(NSDictionary*)requestHeaders;

/*
 * 添加文件上传时候的默认参数
 */
- (void)addRequestParams:(NSDictionary*)parmas;

/*
 * 添加一个上传任务 
 */
- (void)addTask:(GJCFFileUploadTask *)aTask;

/*
 * 仅仅退出一个上传任务
 */
- (void)cancelTaskOnly:(NSString *)aTaskIdentifier;

/*
 * 退出并且清除上传任务 
 */
- (void)cancelTaskAndRemove:(NSString *)aTaskIdentifier;

/*
 * 退出所有正在上传的任务 
 */
- (void)cancelAllExcutingTask;

/*
 * 清除所有任务 
 */
- (void)removeAllTask;

/*
 * 清除所有失败了的任务 
 */
- (void)removeAllFaildTask;

/*
 * 根据任务Id重新尝试上传 
 */
- (void)tryDoTaskByUniqueIdentifier:(NSString*)uniqueIdentifier;

/*
 * 尝试上传所有没有成功的任务 
 */
- (void)tryDoAllUnSuccessTask;

/*
 * 将所有失败的上传任务归档 
 */
- (void)persistAllFaildAndCanceledTask;

/*
 * 清除当前视图的Block观察 
 */
- (void)clearCurrentObserveBlocks;

/*
 * 清除某个观察者的block引用 
 */
- (void)clearBlockForObserver:(NSObject*)observer;

/*
 * 观察者唯一标识生成方法 
 */
+ (NSString*)uniqueKeyForObserver:(NSObject*)observer;

@end
